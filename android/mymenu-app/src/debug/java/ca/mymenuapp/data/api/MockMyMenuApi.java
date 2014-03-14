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
import ca.mymenuapp.data.api.model.MenuItemReviewResponse;
import ca.mymenuapp.data.api.model.MenuResponse;
import ca.mymenuapp.data.api.model.Restaurant;
import ca.mymenuapp.data.api.model.UserResponse;
import ca.mymenuapp.data.api.model.UserRestrictionResponse;
import java.util.ArrayList;
import javax.inject.Inject;
import javax.inject.Singleton;
import retrofit.client.Response;
import retrofit.http.Field;
import retrofit.http.Path;
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
    String email = null;
    String password = null;
    UserResponse userResponse = new UserResponse();
    userResponse.userList = new ArrayList<>();
    userResponse.userList.add(serverDatabase.getUser(email, password));
    return Observable.from(userResponse);
  }

  @Override
  public Observable<UserRestrictionResponse> getRestrictionsForUser(@Field("query") String query) {
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

  @Override public Observable<Restaurant> getRestaurant(@Path("id") long id) {
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
}
