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
import ca.mymenuapp.data.api.model.MenuCategoryResponse;
import ca.mymenuapp.data.api.model.MenuItemReviewResponse;
import ca.mymenuapp.data.api.model.MenuResponse;
import ca.mymenuapp.data.api.model.Restaurant;
import ca.mymenuapp.data.api.model.RestaurantResponse;
import ca.mymenuapp.data.api.model.UserResponse;
import ca.mymenuapp.data.api.model.UserRestrictionResponse;
import retrofit.client.Response;
import retrofit.http.Field;
import retrofit.http.FormUrlEncoded;
import retrofit.http.GET;
import retrofit.http.POST;
import retrofit.http.Path;
import rx.Observable;

/** RESTful interface to talk to the MyMenu backend. */
public interface MyMenuApi {
  String GET_ALL_RESTRICTIONS_QUERY = "SELECT * FROM restrictions";
  String GET_USER_QUERY = "SELECT * FROM users WHERE email='%s' AND password='%s'";
  String GET_USER_RESTRICTIONS = "SELECT * FROM restrictionuserlink where email='%s'";
  String DELETE_USER_RESTRICTIONS = "DELETE from restrictionuserlink WHERE email='%s'";
  String GET_RESTAURANT_MENU = "SELECT * from menu where merchid = %d";
  String GET_MENU_CATEGORIES = "SELECT * from menucategories";
  String GET_NEARBY_RESTAURANTS = "SELECT id, business_name, category, business_number, business_address1, "
      + "rating, business_picture, business_description, distance, lat, longa FROM(SELECT id, business_name, "
      + "category, business_number, business_address1, rating, business_picture, lat, longa, business_description, "
      + "SQRT(longadiff - -latdiff)*111.12 AS distance FROM (SELECT m.id, m.business_name, mc.name AS category, "
      + "m.business_number, m.business_address1, m.rating, m.business_picture, m.business_description, "
      + "m.lat, m.longa, POW(m.longa - %s, 2) AS longadiff, POW(m.lat - %s, 2) AS latdiff FROM merchusers m, "
      + "merchcategories mc WHERE m.categoryid=mc.id) AS temp) AS distances ORDER BY distance ASC LIMIT 50";
  String GET_RESTAURANT_REVIEWS = "SELECT * from ratings where merchid = %d";

  @FormUrlEncoded @POST("/php/users/custom.php")
  Observable<DietaryRestrictionResponse> getAllDietaryRestrictions(@Field("query") String query);

  @FormUrlEncoded @POST("/php/users/custom.php")
  Observable<UserResponse> getUser(@Field("query") String query);

  @FormUrlEncoded @POST("/php/users/custom.php")
  Observable<UserRestrictionResponse> getRestrictionsForUser(@Field("query") String query);

  @FormUrlEncoded @POST("/php/users/custom.php")
  Observable<RestaurantResponse> getNearbyRestaurants(@Field("query") String query);

  @FormUrlEncoded @POST("/php/users/put.php")
  Observable<Response> createUser(@Field("email") String email,
      @Field("firstname") String firstname, @Field("lastname") String lastname,
      @Field("password") String password, @Field("city") String city,
      @Field("locality") String locality, @Field("country") String country,
      @Field("gender") char gender, @Field("birthday") int birthday,
      @Field("birthmonth") int birthmonth, @Field("birthyear") int birthyear);

  @FormUrlEncoded @POST("/php/restrictionuserlink/custom.php")
  Observable<Response> deleteUserRestrictions(@Field("query") String query);

  @FormUrlEncoded @POST("/php/restrictionuserlink/put.php")
  Observable<Response> putUserRestriction(@Field("email") String email,
      @Field("restrictid") long restrictId);

  @GET("/rest/merchusers/{id}.xml") Observable<Restaurant> getRestaurant(@Path("id") long id);

  @FormUrlEncoded @POST("/php/menu/custom.php")
  Observable<MenuResponse> getMenu(@Field("query") String query);

  @FormUrlEncoded @POST("/php/menu/custom.php")
  Observable<MenuCategoryResponse> getMenuCategories(@Field("query") String query);

  @FormUrlEncoded @POST("/php/menu/custom.php")
  Observable<MenuItemReviewResponse> getReviewsForRestaurant(@Field("query") String query);
}