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

package ca.mymenuapp.data.api.model;

import java.util.Random;

import static org.fest.assertions.api.Assertions.assertThat;

public class RestaurantParcelableTest extends ParcelableTestCase<Restaurant> {
  public void testSimpleRestaurant() throws Exception {
    Restaurant restaurant = new RestaurantBuilder(10).businessName("businessName").get();

    restaurant.writeToParcel(parcel, 0);
    parcel.setDataPosition(0);

    Restaurant restaurantFromParcelable = Restaurant.CREATOR.createFromParcel(parcel);
    assertThat(restaurantFromParcelable).isEqualsToByComparingFields(restaurant);
  }

  public void testFullRestaurant() throws Exception {
    Restaurant restaurant = new RestaurantBuilder(new Random().nextLong()) //
        .businessName("Boston Pizza")
        .businessPicture("http://lorempixel.com/400/200/")
        .address("Whyte Ave")
        .city("Boston")
        .locality("NY")
        .country("USA")
        .postalCode("08844")
        .country("USA")
        .lat(271.8)
        .lng(-089.2)
        .openTime("8:00")
        .priceHigh("39")
        .priceLow("21")
        .get();

    restaurant.writeToParcel(parcel, 0);
    parcel.setDataPosition(0);

    Restaurant restaurantFromParcelable = Restaurant.CREATOR.createFromParcel(parcel);
    assertThat(restaurantFromParcelable).isEqualsToByComparingFields(restaurant);
  }
}