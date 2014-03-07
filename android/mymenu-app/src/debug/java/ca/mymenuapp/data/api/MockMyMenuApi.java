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
import ca.mymenuapp.data.api.model.Menu;
import ca.mymenuapp.data.api.model.UserResponse;
import ca.mymenuapp.data.api.model.UserRestrictionResponse;
import javax.inject.Inject;
import javax.inject.Singleton;
import retrofit.Callback;
import retrofit.client.Response;
import retrofit.http.Field;
import retrofit.http.Path;

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

  @Override public void getMenu(@Path("id") long id, Callback<Menu> cb) {

  }

  @Override public void getAllDietaryRestrictions(@Field("query") String query,
      Callback<DietaryRestrictionResponse> cb) {

  }

  @Override public void getUser(@Field("query") String query, Callback<UserResponse> cb) {

  }

  @Override public void getRestrictionsForUser(@Field("query") String query,
      Callback<UserRestrictionResponse> cb) {

  }

  @Override
  public void createUser(@Field("email") String email, @Field("firstname") String firstname,
      @Field("lastname") String lastname, @Field("password") String password,
      @Field("city") String city, @Field("locality") String locality,
      @Field("country") String country, @Field("gender") char gender,
      @Field("birthday") int birthday, @Field("birthmonth") int birthmonth,
      @Field("birthyear") int birthyear, Callback<Response> cb) {

  }

  @Override
  public void deleteUserRestrictions(@Field("email") String email, Callback<Response> cb) {

  }

  @Override
  public void putUserRestriction(@Field("email") String email, @Field("restrictid") long restrictId,
      Callback<Response> cb) {

  }
}
