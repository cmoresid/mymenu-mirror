package ca.mymenuapp.data.api.model;

import java.util.Random;

import static org.fest.assertions.api.Assertions.assertThat;

public class RestaurantParcelableTest extends ParcelableTestCase<Restaurant> {
  public void testSimpleRestaurant() throws Exception {
    Restaurant restaurant = new Restaurant.Builder(10).name("businessName").get();

    restaurant.writeToParcel(parcel, 0);
    parcel.setDataPosition(0);

    Restaurant restaurantFromParcelable = Restaurant.CREATOR.createFromParcel(parcel);
    assertThat(restaurantFromParcelable).isEqualsToByComparingFields(restaurant);
  }

  public void testFullRestaurant() throws Exception {
    Restaurant restaurant =
        new Restaurant.Builder(new Random().nextLong()).email("boston@pizza.com")
            .name("Boston Pizza")
            .picture("http://lorempixel.com/400/200/")
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