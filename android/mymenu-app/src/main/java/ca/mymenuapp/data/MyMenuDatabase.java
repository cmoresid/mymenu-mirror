package ca.mymenuapp.data;

import ca.mymenuapp.MyMenuApi;
import ca.mymenuapp.data.api.model.DietaryRestriction;
import ca.mymenuapp.data.api.model.DietaryRestrictionResponse;
import ca.mymenuapp.data.api.model.Menu;
import ca.mymenuapp.data.api.model.User;
import ca.mymenuapp.data.api.model.UserResponse;
import ca.mymenuapp.data.api.model.UserRestrictionResponse;
import java.util.List;
import javax.inject.Inject;
import javax.inject.Singleton;
import retrofit.client.Response;
import rx.Observable;
import rx.Observer;
import rx.Subscription;
import rx.android.schedulers.AndroidSchedulers;
import rx.functions.Func1;
import rx.schedulers.Schedulers;

@Singleton
public class MyMenuDatabase {

  private final MyMenuApi myMenuApi;

  @Inject public MyMenuDatabase(MyMenuApi myMenuApi) {
    this.myMenuApi = myMenuApi;
  }

  public Subscription getUser(final String email, final String password, Observer<User> observer) {
    return myMenuApi.getUser(String.format(MyMenuApi.GET_USER_QUERY, email, password))
        .map(new Func1<UserResponse, List<User>>() {
          @Override public List<User> call(UserResponse userResponse) {
            return userResponse.userList;
          }
        })
        .map(new Func1<List<User>, User>() {
          @Override public User call(List<User> users) {
            return users.get(0);
          }
        })
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(observer);
  }

  public Subscription createUser(final User user, Observer<Response> observer) {
    return myMenuApi.createUser(user.email, user.firstName, user.lastName, user.password, user.city,
        user.locality, user.country, user.gender, user.birthday, user.birthmonth, user.birthyear)
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(observer);
  }

  public Subscription getMenu(final int id, Observer<Menu> observer) {
    return myMenuApi.getMenu(id)
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(observer);
  }

  public Subscription getAllRestrictions(Observer<List<DietaryRestriction>> observer) {
    return myMenuApi.getAllDietaryRestrictions(MyMenuApi.GET_ALL_RESTRICTIONS_QUERY)
        .map(new Func1<DietaryRestrictionResponse, List<DietaryRestriction>>() {
          @Override public List<DietaryRestriction> call(
              DietaryRestrictionResponse dietaryRestrictionResponse) {
            return dietaryRestrictionResponse.restrictionList;
          }
        })
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(observer);
  }

  public Subscription getUserRestrictions(final User user, Observer<List<Long>> observer) {
    return myMenuApi.getRestrictionsForUser(
        String.format(MyMenuApi.GET_USER_RESTRICTIONS, user.email))
        .map(
            new Func1<UserRestrictionResponse, List<UserRestrictionResponse.UserRestrictionLink>>() {
              @Override public List<UserRestrictionResponse.UserRestrictionLink> call(
                  UserRestrictionResponse userRestrictionResponse) {
                return userRestrictionResponse.links;
              }
            }
        )
        .flatMap(
            new Func1<List<UserRestrictionResponse.UserRestrictionLink>, Observable<UserRestrictionResponse.UserRestrictionLink>>() {
              @Override public Observable<UserRestrictionResponse.UserRestrictionLink> call(
                  List<UserRestrictionResponse.UserRestrictionLink> userRestrictionLinks) {
                return Observable.from(userRestrictionLinks);
              }
            }
        )
        .map(new Func1<UserRestrictionResponse.UserRestrictionLink, Long>() {
          @Override
          public Long call(UserRestrictionResponse.UserRestrictionLink userRestrictionLink) {
            return userRestrictionLink.restrictId;
          }
        })
        .toList()
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(observer);
  }

  public Subscription deleteUserRestrictions(final User user, Observer<Response> observer) {
    // todo : notify observer!
    return myMenuApi.deleteUserRestrictions(
        String.format(MyMenuApi.DELETE_USER_RESTRICTIONS, user.email))
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(observer);
  }

  public Subscription updateUserRestrictions(final User user, Observer<List<Response>> observer) {
    return Observable.from(user.restrictions)
        .flatMap(new Func1<Long, Observable<Response>>() {
          @Override public Observable<Response> call(Long aLong) {
            return myMenuApi.putUserRestriction(user.email, aLong);
          }
        })
        .toList()
        .subscribeOn(Schedulers.io())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(observer);
  }
}
