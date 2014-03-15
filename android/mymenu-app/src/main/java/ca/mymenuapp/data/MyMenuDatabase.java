package ca.mymenuapp.data;

import com.f2prateek.ln.Ln;

import java.util.Collections;
import java.util.List;

import javax.inject.Inject;
import javax.inject.Singleton;

import ca.mymenuapp.MyMenuApi;
import ca.mymenuapp.data.api.model.CategorizedMenu;
import ca.mymenuapp.data.api.model.DietaryRestriction;
import ca.mymenuapp.data.api.model.DietaryRestrictionResponse;
import ca.mymenuapp.data.api.model.MenuCategory;
import ca.mymenuapp.data.api.model.MenuItem;
import ca.mymenuapp.data.api.model.MenuResponse;
import ca.mymenuapp.data.api.model.Restaurant;
import ca.mymenuapp.data.api.model.RestaurantResponse;
import ca.mymenuapp.data.api.model.User;
import ca.mymenuapp.data.api.model.UserResponse;
import ca.mymenuapp.data.api.model.UserRestrictionLink;
import ca.mymenuapp.data.api.model.UserRestrictionResponse;
import retrofit.client.Response;
import rx.Observable;
import rx.Observer;
import rx.Subscription;
import rx.android.schedulers.AndroidSchedulers;
import rx.functions.Func1;
import rx.observables.BlockingObservable;
import rx.schedulers.Schedulers;

@Singleton
public class MyMenuDatabase {

    private final MyMenuApi myMenuApi;

    @Inject
    public MyMenuDatabase(MyMenuApi myMenuApi) {
        this.myMenuApi = myMenuApi;
    }

    public Subscription getUser(final String email, final String password, Observer<User> observer) {
        final String query = String.format(MyMenuApi.GET_USER_QUERY, email, password);
        return myMenuApi.getUser(query).map(new Func1<UserResponse, List<User>>() {
            @Override
            public List<User> call(UserResponse userResponse) {
                return userResponse.userList;
            }
        }).map(new Func1<List<User>, User>() {
            @Override
            public User call(List<User> users) {
                return users.get(0);
            }
        }).subscribeOn(Schedulers.io()).observeOn(AndroidSchedulers.mainThread()).subscribe(observer);
    }

    public Subscription createUser(final User user, Observer<Response> observer) {
        return myMenuApi.createUser(user.email, user.firstName, user.lastName, user.password, user.city,
                user.locality, user.country, user.gender, user.birthday, user.birthmonth, user.birthyear)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(observer);
    }

    public Subscription getAllRestrictions(Observer<List<DietaryRestriction>> observer) {
        return myMenuApi.getAllDietaryRestrictions(MyMenuApi.GET_ALL_RESTRICTIONS_QUERY)
                .map(new Func1<DietaryRestrictionResponse, List<DietaryRestriction>>() {
                    @Override
                    public List<DietaryRestriction> call(
                            DietaryRestrictionResponse dietaryRestrictionResponse) {
                        return dietaryRestrictionResponse.restrictionList;
                    }
                })
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(observer);
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

    /**
     * Use restaurantId so we don't have to wait for full restaurant response.
     */
    public Subscription getMenu(final User user, final long restaurantId,
                                Observer<CategorizedMenu> observer) {
        final String query = String.format(MyMenuApi.GET_RESTAURANT_MENU, restaurantId);
        Ln.d(query);
        return myMenuApi.getMenu(query) //
                .map(new Func1<MenuResponse, List<MenuItem>>() {
                    @Override
                    public List<MenuItem> call(MenuResponse menuResponse) {
                        Ln.d(menuResponse);
                        return menuResponse.menuItems;
                    }
                })
                .map(new Func1<List<MenuItem>, CategorizedMenu>() {
                    @Override
                    public CategorizedMenu call(List<MenuItem> menuItems) {
                        List<MenuCategory> categories =
                                BlockingObservable.from(myMenuApi.getMenuCategories(MyMenuApi.GET_MENU_CATEGORIES))
                                        .first().categories;
                        return CategorizedMenu.parse(menuItems, categories);
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
                    public List<Restaurant> call(
                            RestaurantResponse restResponse) {
                        return restResponse.restList;
                    }
                })
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe(observer);
    }
}
