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

package ca.mymenuapp;

import ca.mymenuapp.data.api.model.DietaryRestrictionResponse;
import ca.mymenuapp.data.api.model.Menu;
import ca.mymenuapp.data.api.model.UserResponse;
import ca.mymenuapp.data.api.model.UserRestrictionResponse;
import retrofit.Callback;
import retrofit.client.Response;
import retrofit.http.Field;
import retrofit.http.FormUrlEncoded;
import retrofit.http.GET;
import retrofit.http.POST;
import retrofit.http.Path;

/** RESTful interface to talk to the MyMenu backend. */
public interface MyMenuApi {
  String GET_ALL_RESTRICTIONS_QUERY = "SELECT * FROM restrictions";
  String GET_USER_QUERY = "SELECT * FROM users WHERE email='%s' AND password='%s'";
  String GET_USER_RESTRICTIONS = "SELECT * FROM restrictionuserlink where email='%s'";
  String DELETE_USER_RESTRICTIONS = "DELETE * FROM restrictionuserlink where email='%s'";

  @GET("/rest/menu/{id}") void getMenu(@Path("id") long id, Callback<Menu> cb);

  @FormUrlEncoded @POST("/php/users/custom.php")
  void getAllDietaryRestrictions(@Field("query") String query,
      Callback<DietaryRestrictionResponse> cb);

  @FormUrlEncoded @POST("/php/users/custom.php")
  void getUser(@Field("query") String query, Callback<UserResponse> cb);

  @FormUrlEncoded @POST("/php/users/custom.php")
  void getRestrictionsForUser(@Field("query") String query, Callback<UserRestrictionResponse> cb);

  @FormUrlEncoded @POST("/php/users/put.php")
  void createUser(@Field("email") String email, @Field("firstname") String firstname,
      @Field("lastname") String lastname, @Field("password") String password,
      @Field("city") String city, @Field("locality") String locality,
      @Field("country") String country, @Field("gender") char gender,
      @Field("birthday") int birthday, @Field("birthmonth") int birthmonth,
      @Field("birthyear") int birthyear, Callback<Response> cb);

  @FormUrlEncoded @POST("/php/users/put.php")
  void deleteExistingRestrictions(@Field("email") String email, Callback<Response> cb);

  @FormUrlEncoded @POST("/php/restrictionuserlink/put.php")
  void putUserRestriction(@Field("email") String email, @Field("restrictid") long restrictId,
      Callback<Response> cb);
}