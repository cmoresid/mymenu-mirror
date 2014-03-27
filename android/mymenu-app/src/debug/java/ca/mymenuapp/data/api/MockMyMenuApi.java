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

package ca.mymenuapp.data.api;

import ca.mymenuapp.MyMenuApi;
import ca.mymenuapp.data.api.model.DietaryRestrictionResponse;
import ca.mymenuapp.data.api.model.MenuCategoryResponse;
import ca.mymenuapp.data.api.model.MenuItemModificationResponse;
import ca.mymenuapp.data.api.model.MenuItemReviewResponse;
import ca.mymenuapp.data.api.model.MenuResponse;
import ca.mymenuapp.data.api.model.RestaurantListResponse;
import ca.mymenuapp.data.api.model.UserResponse;
import ca.mymenuapp.data.api.model.UserRestrictionResponse;
import com.f2prateek.ln.Ln;
import java.util.ArrayList;
import javax.inject.Inject;
import javax.inject.Singleton;
import retrofit.client.Response;
import retrofit.http.Field;
import rx.Observable;

/**
 * Mocks {@link ca.mymenuapp.MyMenuApi}.
 * TODO: doesn't actually do anything yet.
 */
@Singleton
final class MockMyMenuApi implements MyMenuApi {
  private final ServerDatabase serverDatabase;

  @Inject MockMyMenuApi(ServerDatabase serverDatabase) {
    this.serverDatabase = serverDatabase;
  }

  @Override public Observable<DietaryRestrictionResponse> getAllDietaryRestrictions(
      @Field("query") String query) {
    return null;
  }

  @Override public Observable<UserResponse> getUser(@Field("query") String query) {
    String emailToken = "email='";
    int emailStartIndex = query.indexOf(emailToken) + emailToken.length();
    int emailEndIndex = query.indexOf("'", emailStartIndex);

    String passwordToken = "password='";
    int passwordStartIndex = query.indexOf(passwordToken) + passwordToken.length();
    int passwordEndIndex = query.indexOf("'", passwordStartIndex);

    String email = query.substring(emailStartIndex, emailEndIndex);
    String password = query.substring(passwordStartIndex, passwordEndIndex);
    Ln.d("Looking up user with email %s and password %s", email, password);

    UserResponse userResponse = new UserResponse();
    userResponse.userList = new ArrayList<>();
    userResponse.userList.add(serverDatabase.getUser(email, password));
    return Observable.from(userResponse);
  }

  @Override
  public Observable<MenuItemModificationResponse> getModifications(@Field("query") String query) {
    return null;
  }

  @Override
  public Observable<UserRestrictionResponse> getRestrictionsForUser(@Field("query") String query) {
    return null;
  }

  @Override
  public Observable<RestaurantListResponse> getNearbyRestaurants(@Field("query") String query) {
    RestaurantListResponse restaurantListResponse = new RestaurantListResponse();
    restaurantListResponse.restList = serverDatabase.getRestaurants();
    return Observable.from(restaurantListResponse);
  }

  @Override public Observable<RestaurantListResponse> getNearbyRestaurantsByName(
      @Field("query") String query) {
    return null;
  }

  @Override public Observable<Response> editUser(@Field("query") String query) {
    return null;
  }

  @Override public Observable<Response> createUser(@Field("email") String email,
      @Field("firstname") String firstname, @Field("lastname") String lastname,
      @Field("password") String password, @Field("city") String city,
      @Field("locality") String locality, @Field("country") String country,
      @Field("gender") char gender, @Field("birthday") int birthday,
      @Field("birthmonth") int birthmonth, @Field("birthyear") int birthyear) {
    return null;
  }

  @Override public Observable<Response> deleteUserRestrictions(@Field("query") String query) {
    return null;
  }

  @Override public Observable<Response> putUserRestriction(@Field("email") String email,
      @Field("restrictid") long restrictId) {
    return null;
  }

  @Override public Observable<RestaurantListResponse> getRestaurant(@Field("query") String query) {
    return null;
  }

  @Override public Observable<MenuResponse> getMenu(@Field("query") String query) {
    return null;
  }

  @Override
  public Observable<MenuCategoryResponse> getMenuCategories(@Field("query") String query) {
    return null;
  }

  @Override
  public Observable<MenuItemReviewResponse> getReviewsForRestaurant(@Field("query") String query) {
    return null;
  }

  @Override public Observable<Response> likeReview(@Field("query") String query) {
    return null;
  }
}
