/*
 * Copyright 2014 Prateek Srivastava (@f2prateek)
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

package ca.mymenuapp.data.api.model;

class RestaurantBuilder {
  final Restaurant restaurant;

  RestaurantBuilder(long id) {
    restaurant = new Restaurant();
    restaurant.id = id;
    // Skip Personal Info
    // email
    // password
    // firstName
    // lastName
    // phone
    // Any Canned Data
  }

  RestaurantBuilder businessName(String businessName) {
    restaurant.businessName = businessName;
    return this;
  }

  RestaurantBuilder businessNumber(String businessNumber) {
    restaurant.businessNumber = businessNumber;
    return this;
  }

  RestaurantBuilder businessDescription(String businessDescription) {
    restaurant.businessDescription = businessDescription;
    return this;
  }

  RestaurantBuilder businessPicture(String businessPicture) {
    restaurant.businessPicture = businessPicture;
    return this;
  }

  RestaurantBuilder address(String address) {
    restaurant.address = address;
    return this;
  }

  RestaurantBuilder city(String city) {
    restaurant.city = city;
    return this;
  }

  RestaurantBuilder locality(String locality) {
    restaurant.locality = locality;
    return this;
  }

  RestaurantBuilder postalCode(String postalCode) {
    restaurant.postalCode = postalCode;
    return this;
  }

  RestaurantBuilder country(String country) {
    restaurant.country = country;
    return this;
  }

  RestaurantBuilder lat(double lat) {
    restaurant.lat = lat;
    return this;
  }

  RestaurantBuilder lng(double lng) {
    restaurant.lng = lng;
    return this;
  }

  RestaurantBuilder facebook(String facebook) {
    restaurant.facebook = facebook;
    return this;
  }

  RestaurantBuilder twitter(String twitter) {
    restaurant.twitter = twitter;
    return this;
  }

  RestaurantBuilder website(String website) {
    restaurant.website = website;
    return this;
  }

  RestaurantBuilder rating(double rating) {
    restaurant.rating = rating;
    return this;
  }

  RestaurantBuilder ratingCount(String ratingCount) {
    restaurant.ratingCount = ratingCount;
    return this;
  }

  RestaurantBuilder category(String category) {
    restaurant.category = category;
    return this;
  }

  RestaurantBuilder priceLow(String priceLow) {
    restaurant.priceLow = priceLow;
    return this;
  }

  RestaurantBuilder priceHigh(String priceHigh) {
    restaurant.priceHigh = priceHigh;
    return this;
  }

  RestaurantBuilder openTime(String openTime) {
    restaurant.openTime = openTime;
    return this;
  }

  RestaurantBuilder closeTime(String closeTime) {
    restaurant.closeTime = closeTime;
    return this;
  }

  RestaurantBuilder distance(String distance) {
    restaurant.distance = distance;
    return this;
  }

  RestaurantBuilder categoryId(String categoryId) {
    restaurant.categoryId = categoryId;
    return this;
  }

  Restaurant get() {
    return restaurant;
  }
}
