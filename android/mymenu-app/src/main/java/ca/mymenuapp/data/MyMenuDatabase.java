/*
 * Copyright (C) 2014 MyMenu, Inc.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see [http://www.gnu.org/licenses/].
 */

package ca.mymenuapp.data;

import ca.mymenuapp.MyMenuApi;
import ca.mymenuapp.data.api.model.DietaryRestriction;
import ca.mymenuapp.data.api.model.DietaryRestrictionResponse;
import ca.mymenuapp.data.api.model.MenuCategory;
import ca.mymenuapp.data.api.model.MenuItem;
import ca.mymenuapp.data.api.model.MenuItemModification;
import ca.mymenuapp.data.api.model.MenuItemModificationResponse;
import ca.mymenuapp.data.api.model.MenuItemReview;
import ca.mymenuapp.data.api.model.MenuResponse;
import ca.mymenuapp.data.api.model.MenuSpecial;
import ca.mymenuapp.data.api.model.MenuSpecialResponse;
import ca.mymenuapp.data.api.model.Restaurant;
import ca.mymenuapp.data.api.model.RestaurantListResponse;
import ca.mymenuapp.data.api.model.RestaurantMenu;
import ca.mymenuapp.data.api.model.User;
import ca.mymenuapp.data.api.model.UserResponse;
import ca.mymenuapp.data.api.model.UserRestrictionLink;
import ca.mymenuapp.data.api.model.UserRestrictionResponse;
import ca.mymenuapp.data.rx.EndObserver;
import ca.mymenuapp.util.Strings;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import retrofit.client.Response;
import rx.Observable;
import rx.Observer;
import rx.Subscription;
import rx.android.schedulers.AndroidSchedulers;
import rx.observables.BlockingObservable;
import rx.schedulers.Schedulers;
import rx.subjects.PublishSubject;
import rx.util.functions.Func1;

/**
 * Explicitly marked as a dependency in modules, Dagger seemed to be creating new ones for each
 * activity.
 */
public class MyMenuDatabase {

  private final MyMenuApi myMenuApi;

  // cache of dietaryRestrictions
  private PublishSubject<List<DietaryRestriction>> dietaryRestrictionsRequest;
  private List<DietaryRestriction> dietaryRestrictionsCache;

  // cache of restaurants
  private PublishSubject<List<Restaurant>> restaurantsRequest;
  private List<Restaurant> restaurantsCache;

  // Cache of menus
  private final Map<Long, PublishSubject<RestaurantMenu>> menuRequests = new LinkedHashMap<>();
  private final Map<Long, RestaurantMenu> menuCache = new LinkedHashMap<>();

  public MyMenuDatabase(MyMenuApi myMenuApi) {
    this.myMenuApi = myMenuApi;
  }

  public Subscription getUser(final String email, final String password, Observer<User> observer) {
    final String query = String.format(MyMenuApi.GET_USER_QUERY, email, password);
    return myMenuApi //
        .getUser(query).map(new Func1<UserResponse, List<User>>() {
          @Override public List<User> call(UserResponse userResponse) {
            return userResponse.userList;
          }
        }) //
        .map(new Func1<List<User>, User>() {
          @Override public User call(List<User> users) {
            return users.get(0);
          }
        }) //
        .subscribeOn(Schedulers.io()) //
        .observeOn(AndroidSchedulers.mainThread()) //
        .subscribe(observer);
  }

  public Subscription createUser(final User user, Observer<Response> observer) {
    return myMenuApi.createUser(user.email, user.firstName, user.lastName, user.password, user.city,
        user.locality, user.country, user.gender, user.birthday, user.birthmonth,
        user.birthyear).subscribeOn(Schedulers.io()) //
        .observeOn(AndroidSchedulers.mainThread()).subscribe(observer);
  }

  public Subscription editUser(final User user, Observer<Response> observer) {
    final String query =
        String.format(MyMenuApi.EDIT_USER, user.firstName, user.lastName, user.password, user.city,
            user.locality, user.gender, user.email);
    return myMenuApi.editUser(query)
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(observer);
  }

  public Subscription getAllRestrictions(Observer<List<DietaryRestriction>> observer) {
    if (dietaryRestrictionsCache != null) {
      // We have a cached value. Emit it immediately.
      observer.onNext(dietaryRestrictionsCache);
    }
    if (dietaryRestrictionsRequest != null) {
      // There's an in-flight network request for this section already. Join it.
      return dietaryRestrictionsRequest.subscribe(observer);
    }

    dietaryRestrictionsRequest = PublishSubject.create();
    Subscription subscription = dietaryRestrictionsRequest.subscribe(observer);
    dietaryRestrictionsRequest.subscribe(new EndObserver<List<DietaryRestriction>>() {
      @Override public void onEnd() {
        dietaryRestrictionsRequest = null;
      }

      @Override public void onNext(List<DietaryRestriction> response) {
        dietaryRestrictionsCache = response;
      }
    });

    myMenuApi.getAllDietaryRestrictions(MyMenuApi.GET_ALL_RESTRICTIONS_QUERY)
        .map(new Func1<DietaryRestrictionResponse, List<DietaryRestriction>>() {
          @Override public List<DietaryRestriction> call(
              DietaryRestrictionResponse dietaryRestrictionResponse) {
            return dietaryRestrictionResponse.restrictionList;
          }
        })
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(dietaryRestrictionsRequest);

    return subscription;
  }

  public Subscription getUserRestrictions(final User user, Observer<List<Long>> observer) {
    final String query = String.format(MyMenuApi.GET_USER_RESTRICTIONS, user.email);
    return myMenuApi.getRestrictionsForUser(query)
        .map(new Func1<UserRestrictionResponse, List<UserRestrictionLink>>() {
               @Override
               public List<UserRestrictionLink> call(
                   UserRestrictionResponse userRestrictionResponse) {
                 // restrictions may be null if user is not allergic to anything
                 if (userRestrictionResponse.links == null) {
                   return Collections.emptyList();
                 } else {
                   return userRestrictionResponse.links;
                 }
               }
             }
        )
        .flatMap(new Func1<List<UserRestrictionLink>, Observable<UserRestrictionLink>>() {
                   @Override
                   public Observable<UserRestrictionLink> call(
                       List<UserRestrictionLink> userRestrictionLinks) {
                     return Observable.from(userRestrictionLinks);
                   }
                 }
        )
        .map(new Func1<UserRestrictionLink, Long>() {
          @Override
          public Long call(UserRestrictionLink userRestrictionLink) {
            return userRestrictionLink.restrictId;
          }
        })
        .toList()
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(observer);
  }

  public Subscription deleteUserRestrictions(final User user, Observer<Response> observer) {
    final String query = String.format(MyMenuApi.DELETE_USER_RESTRICTIONS, user.email);
    return myMenuApi.deleteUserRestrictions(query)
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(observer);
  }

  public Subscription updateUserRestrictions(final User user, Observer<List<Response>> observer) {
    return Observable.from(user.restrictions)
        .flatMap(new Func1<Long, Observable<Response>>() {
          @Override
          public Observable<Response> call(Long aLong) {
            return myMenuApi.putUserRestriction(user.email, aLong);
          }
        })
        .toList()
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(observer);
  }

  // todo, when we call this, we will already have the restaurant, so pass that instead of id
  public Subscription getRestaurantAndMenu(final User user, final long restaurantId,
      Observer<RestaurantMenu> observer) {
    RestaurantMenu menu = menuCache.get(restaurantId);
    if (menu != null) {
      // We have a cached value. Emit it immediately.
      observer.onNext(menu);
    }

    PublishSubject<RestaurantMenu> menuRequest = menuRequests.get(restaurantId);
    if (menuRequest != null) {
      // There's an in-flight network request for this section already. Join it.
      return menuRequest.subscribe(observer);
    }

    menuRequest = PublishSubject.create();
    menuRequests.put(restaurantId, menuRequest);

    Subscription subscription = menuRequest.subscribe(observer);

    menuRequest.subscribe(new EndObserver<RestaurantMenu>() {
      @Override public void onEnd() {
        menuRequests.remove(restaurantId);
      }

      @Override public void onNext(RestaurantMenu menu) {
        menuCache.put(restaurantId, menu);
      }
    });

    final String getMenuQuery =
        String.format(MyMenuApi.GET_RESTAURANT_MENU, user.email, restaurantId, user.email,
            restaurantId);
    myMenuApi.getMenu(getMenuQuery)
        .map(new Func1<MenuResponse, List<MenuItem>>() {
               @Override
               public List<MenuItem> call(MenuResponse menuResponse) {
                 return menuResponse.menuItems;
               }
             }
        )
        .map(new Func1<List<MenuItem>, RestaurantMenu>() {
          @Override
          public RestaurantMenu call(List<MenuItem> menuItems) {
            final String getRestaurantQuery = String.format(MyMenuApi.GET_RESTAURANT, restaurantId);
            Restaurant restaurant =
                BlockingObservable.from(myMenuApi.getRestaurant(getRestaurantQuery))
                    .first().restList.get(0);
            List<MenuCategory> categories =
                BlockingObservable.from(myMenuApi.getMenuCategories(MyMenuApi.GET_MENU_CATEGORIES))
                    .first().categories;
            List<MenuItemReview> reviews = BlockingObservable.from(
                myMenuApi.getReviewsForRestaurant(
                    String.format(MyMenuApi.GET_RESTAURANT_REVIEWS, restaurantId))
            ).first().reviews;
            return RestaurantMenu.generate(restaurant, menuItems, categories, reviews);
          }
        })
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(menuRequest);

    return subscription;
  }

  public Subscription getNearbyRestaurants(final double lat, final double lng,
      Observer<List<Restaurant>> observer) {
    if (restaurantsCache != null) {
      // We have a cached value. Emit it immediately.
      observer.onNext(restaurantsCache);
    }
    if (restaurantsRequest != null) {
      // There's an in-flight network request for this section already. Join it.
      return restaurantsRequest.subscribe(observer);
    }

    restaurantsRequest = PublishSubject.create();
    Subscription subscription = restaurantsRequest.subscribe(observer);
    restaurantsRequest.subscribe(new EndObserver<List<Restaurant>>() {
      @Override public void onEnd() {
        restaurantsRequest = null;
      }

      @Override public void onNext(List<Restaurant> response) {
        restaurantsCache = response;
      }
    });
    final String query = String.format(MyMenuApi.GET_NEARBY_RESTAURANTS, lng, lat);
    myMenuApi.getNearbyRestaurants(query)
        .map(new Func1<RestaurantListResponse, List<Restaurant>>() {
          @Override
          public List<Restaurant> call(RestaurantListResponse restResponse) {
            return restResponse.restList;
          }
        })
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(restaurantsRequest);

    return subscription;
  }

  public Subscription getNearbyRestaurantsByName(final double lat, final double lng,
      final String name, Observer<List<Restaurant>> observer) {
    final String query = String.format(MyMenuApi.GET_NEARBY_RESTAURANTS_BY_NAME, lng, lat, name);
    return myMenuApi.getNearbyRestaurantsByName(query)
        .map(new Func1<RestaurantListResponse, List<Restaurant>>() {
          @Override
          public List<Restaurant> call(RestaurantListResponse restResponse) {
            return restResponse.restList;
          }
        })
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(observer);
  }

  public Subscription likeReview(User user, MenuItemReview review, Observer<Response> observer) {
    String query = String.format(MyMenuApi.POST_LIKE_REVIEW, user.email, review.id, review.merchId,
        review.menuId);
    return myMenuApi.likeReview(query)
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(observer);
  }

  public Subscription getModifications(User user, MenuItem menuItem,
      Observer<List<MenuItemModification>> observer) {
    String query =
        String.format(MyMenuApi.GET_MODIFICATIONS, Long.toString(menuItem.id), user.email);
    return myMenuApi.getModifications(query)
        .map(new Func1<MenuItemModificationResponse, List<MenuItemModification>>() {
          @Override public List<MenuItemModification> call(
              MenuItemModificationResponse menuItemModificationResponse) {
            return menuItemModificationResponse.modificationList;
          }
        })
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(observer);
  }

  public Subscription addRating(final MenuItemReview review, Observer<Response> observer) {
    final String query =
        String.format(MyMenuApi.POST_INSERT_REVIEW, review.userEmail, review.menuId, review.merchId,
            Double.toString(review.rating), review.description);
    return myMenuApi.addRating(query)
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(observer);
  }

  public Subscription getSpecialsForDateRange(Date startDate, Date endDate,
      Observer<List<MenuSpecial>> observer) {
    List<String> days = new ArrayList<>();
    Calendar start = Calendar.getInstance();
    start.setTime(startDate);
    Calendar end = Calendar.getInstance();
    end.setTime(endDate);
    while (!start.after(end)) {
      days.add("'" + MenuSpecial.getDayStringForDay(start.get(Calendar.DAY_OF_WEEK)) + "'");
      start.add(Calendar.DATE, 1);
    }

    String allDays = Strings.join(days);

    String query = String.format(MyMenuApi.GET_SPECIALS_FOR_DATE, allDays,
        MenuSpecial.DATE_FORMAT.format(endDate),
        MenuSpecial.DATE_FORMAT.format(startDate)); // note that enddate comes before startdate
    return myMenuApi.getSpecialsForDateRange(query)
        .map(new Func1<MenuSpecialResponse, List<MenuSpecial>>() {
          @Override public List<MenuSpecial> call(MenuSpecialResponse menuSpecialResponse) {
            return menuSpecialResponse.menuSpecials;
          }
        })
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(observer);
  }

  public Subscription addReport(final MenuItemReview review, User user,
      Observer<Response> observer) {
    final String query =
        String.format(MyMenuApi.POST_SPAM_REVIEW, user.email, review.id, review.menuId,
            review.merchId);
    return myMenuApi.addReport(query)
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(observer);
  }
}
