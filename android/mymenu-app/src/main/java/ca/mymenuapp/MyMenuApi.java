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
import ca.mymenuapp.data.api.model.MenuItemModificationResponse;
import ca.mymenuapp.data.api.model.MenuItemReviewResponse;
import ca.mymenuapp.data.api.model.MenuResponse;
import ca.mymenuapp.data.api.model.MenuSpecialResponse;
import ca.mymenuapp.data.api.model.RestaurantListResponse;
import ca.mymenuapp.data.api.model.UserResponse;
import ca.mymenuapp.data.api.model.UserRestrictionResponse;
import retrofit.client.Response;
import retrofit.http.Field;
import retrofit.http.FormUrlEncoded;
import retrofit.http.POST;
import rx.Observable;

/** RESTful interface to talk to the MyMenu backend. */
public interface MyMenuApi {
  String GET_MODIFICATIONS = "SELECT modification FROM modificationmenulink WHERE menuid = %s "
      + "AND restrictid IN(SELECT restrictid FROM restrictionuserlink WHERE email = '%s')";
  String GET_ALL_RESTRICTIONS_QUERY = "SELECT * FROM restrictions";
  String GET_USER_QUERY = "SELECT * FROM users WHERE email='%s' AND password='%s'";
  String GET_USER_RESTRICTIONS = "SELECT * FROM restrictionuserlink where email='%s'";
  String DELETE_USER_RESTRICTIONS = "DELETE from restrictionuserlink WHERE email='%s'";
  String GET_RESTAURANT_MENU = "SELECT m.id, m.merchid, m.name, m.cost, m.picture, m.description, "
      + "m.rating, mc.name AS category, 'edible' AS edible, m.categoryid FROM"
      + " menu m, menucategories mc "
      + "WHERE m.id "
      + "not IN(SELECT Distinct rml.menuid FROM restrictionmenulink rml WHERE rml.restrictid "
      + "IN(SELECT rul.restrictid FROM restrictionuserlink rul WHERE rul.email='%s')) AND "
      + "m.merchid = %s AND m.categoryid = mc.id UNION "
      + "SELECT m.id, m.merchid, m.name, m.cost, m.picture, m.description, "
      + "m.rating, mc.name AS category, 'notedible' AS edible, m.categoryid FROM"
      + " menu m, menucategories mc "
      + "WHERE "
      + "m.id IN(SELECT rml.menuid FROM restrictionmenulink rml WHERE rml.restrictid IN("
      + "SELECT rul.restrictid FROM restrictionuserlink rul WHERE rul.email='%s')) "
      + "AND m.merchid = %s AND m.categoryid = mc.id";
  String GET_MENU_CATEGORIES = "SELECT * from menucategories";
  String GET_NEARBY_RESTAURANTS = "SELECT id, business_name, category, "
      + "business_number, business_address1, "
      + "rating, business_picture, business_description, distance, lat, longa "
      + "FROM(SELECT id, business_name, "
      + "category, business_number, business_address1, rating, business_picture, lat, longa, "
      + "business_description, "
      + "SQRT(longadiff - -latdiff)*111.12 AS distance "
      + "FROM (SELECT m.id, m.business_name, mc.name AS category, "
      + "m.business_number, m.business_address1, m.rating, m.business_picture, "
      + "m.business_description, "
      + "m.lat, m.longa, POW(m.longa - %s, 2) AS longadiff, POW(m.lat - %s, 2) "
      + "AS latdiff FROM merchusers m, "
      + "merchcategories mc WHERE m.categoryid=mc.id) AS temp) AS distances "
      + "ORDER BY distance ASC LIMIT 50";

  String GET_RESTAURANT_REVIEWS = "SELECT * from ratings where merchid = %d";
  String POST_LIKE_REVIEW =
      "insert into ratinglikes (useremail, ratingid, merchid, menuid, adddate)"
          + " values('%s', %d, %d, %d, sysdate())";
  String POST_INSERT_REVIEW = "insert into ratings (useremail, menuid, merchid, rating, "
      + "ratingdescription, ratingdate) values ('%s', %d, %d, %s, '%s', sysdate())";

  String POST_SPAM_REVIEW = "insert into ratingreport (useremail, ratingid, merchid, menuid, "
      + "adddate) values ('%s', %d, %d, %d, sysdate())";
  String GET_RESTAURANT = "SELECT * FROM merchusers WHERE id = %d";
  String EDIT_USER = "UPDATE users SET firstname='%s',lastname='%s',password='%s', city='%s',"
      + "locality='%s',gender='%s' WHERE email = '%s'";
  String GET_NEARBY_RESTAURANTS_BY_NAME =
      "SELECT id, business_name, category, business_number, business_address1, rating, "
          + "business_picture, business_description, distance, lat, longa "
          + "FROM(SELECT id, business_name, category, business_number, business_address1, rating, "
          + "business_picture, lat, longa, business_description, SQRT(longadiff - -latdiff)*111.12 "
          + "AS distance FROM (SELECT m.id, m.business_name, mc.name AS category, "
          + "m.business_number, m.business_address1, m.rating, m.business_picture,"
          + " m.business_description, m.lat, m.longa, POW(m.longa - %s, 2) AS longadiff, "
          + "POW(m.lat - %s, 2) AS latdiff FROM merchusers m, merchcategories mc WHERE"
          + " m.categoryid=mc.id) AS temp) AS distances WHERE UPPER(business_name)"
          + " LIKE UPPER('%%%s%%') ORDER BY distance ASC LIMIT 25";

  String GET_SPECIALS_FOR_DATE =
      "SELECT DISTINCT specials.id, specials.merchid, merchusers.business_name "
          + "AS business, specials.name, specials.description, specials.picture, "
          + "specials.startdate, specials.enddate, specials.categoryid, specials.weekday, "
          + "specials.occurType FROM specials INNER JOIN merchusers "
          + "ON specials.merchid=merchusers.id "
          + "WHERE (specials.weekday IN (%s) "
          // ('friday','saturday')
          + "OR (datediff(specials.startdate, '%s')<= 0 "
          // enddate
          + "AND datediff('%s', specials.enddate)<=0))"; // startdate

  @FormUrlEncoded @POST("/php/users/custom.php")
  Observable<DietaryRestrictionResponse> getAllDietaryRestrictions(@Field("query") String query);

  @FormUrlEncoded @POST("/php/users/custom.php")
  Observable<UserResponse> getUser(@Field("query") String query);

  @FormUrlEncoded @POST("/php/users/custom.php")
  Observable<MenuItemModificationResponse> getModifications(@Field("query") String query);

  @FormUrlEncoded @POST("/php/users/custom.php")
  Observable<UserRestrictionResponse> getRestrictionsForUser(@Field("query") String query);

  @FormUrlEncoded @POST("/php/users/custom.php")
  Observable<RestaurantListResponse> getNearbyRestaurants(@Field("query") String query);

  @FormUrlEncoded @POST("/php/users/custom.php")
  Observable<RestaurantListResponse> getNearbyRestaurantsByName(@Field("query") String query);

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

  @FormUrlEncoded @POST("/php/merchusers/custom.php")
  Observable<RestaurantListResponse> getRestaurant(@Field("query") String query);

  @FormUrlEncoded @POST("/php/menu/custom.php")
  Observable<MenuResponse> getMenu(@Field("query") String query);

  @FormUrlEncoded @POST("/php/menu/custom.php")
  Observable<MenuCategoryResponse> getMenuCategories(@Field("query") String query);

  @FormUrlEncoded @POST("/php/menu/custom.php")
  Observable<MenuItemReviewResponse> getReviewsForRestaurant(@Field("query") String query);

  @FormUrlEncoded @POST("/php/users/custom.php")
  Observable<Response> likeReview(@Field("query") String query);

  @FormUrlEncoded @POST("/php/users/custom.php")
  Observable<Response> editUser(@Field("query") String query);

  @FormUrlEncoded @POST("/php/ratings/custom.php")
  Observable<Response> addRating(@Field("query") String query);

  @FormUrlEncoded @POST("/php/ratings/custom.php")
  Observable<Response> addReport(@Field("query") String query);

  @FormUrlEncoded @POST("/php/specials/custom.php")
  Observable<MenuSpecialResponse> getSpecialsForDateRange(@Field("query") String query);
}