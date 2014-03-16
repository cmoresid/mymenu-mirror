package ca.mymenuapp.data;

import ca.mymenuapp.MyMenuApi;
import ca.mymenuapp.data.api.model.DietaryRestriction;
import ca.mymenuapp.data.api.model.DietaryRestrictionResponse;
import ca.mymenuapp.data.api.model.MenuCategory;
import ca.mymenuapp.data.api.model.MenuItem;
import ca.mymenuapp.data.api.model.MenuItemReview;
import ca.mymenuapp.data.api.model.MenuResponse;
import ca.mymenuapp.data.api.model.Restaurant;
import ca.mymenuapp.data.api.model.RestaurantMenu;
import ca.mymenuapp.data.api.model.RestaurantResponse;
import ca.mymenuapp.data.api.model.User;
import ca.mymenuapp.data.api.model.UserResponse;
import ca.mymenuapp.data.api.model.UserRestrictionLink;
import ca.mymenuapp.data.api.model.UserRestrictionResponse;
import ca.mymenuapp.data.rx.EndObserver;
import java.util.Collections;
import java.util.List;
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
        .cache()
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

  public Subscription getRestaurant(final long id, Observer<Restaurant> observer) {
    return myMenuApi.getRestaurant(id)
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(observer);
  }

  public Subscription getRestaurantAndMenu(final User user, final long restaurantId,
      Observer<RestaurantMenu> observer) {
    return myMenuApi.getMenu(String.format(MyMenuApi.GET_RESTAURANT_MENU, restaurantId)) //
        .map(new Func1<MenuResponse, List<MenuItem>>() {
          @Override
          public List<MenuItem> call(MenuResponse menuResponse) {
            return menuResponse.menuItems;
          }
        })
        .map(new Func1<List<MenuItem>, RestaurantMenu>() {
          @Override
          public RestaurantMenu call(List<MenuItem> menuItems) {
            Restaurant restaurant =
                BlockingObservable.from(myMenuApi.getRestaurant(restaurantId)).first();
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
        .subscribe(observer);
  }

  public Subscription getAllRestaurants(Observer<List<Restaurant>> observer) {
    return myMenuApi.getAllRestaurants(MyMenuApi.GET_ALL_RESTAURANTS)
        .map(new Func1<RestaurantResponse, List<Restaurant>>() {
          @Override
          public List<Restaurant> call(RestaurantResponse restResponse) {
            return restResponse.restList;
          }
        })
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(observer);
  }
}
