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

import android.location.Location;
import android.os.Parcel;
import android.os.Parcelable;
import com.google.android.gms.maps.model.LatLng;
import com.google.maps.android.clustering.ClusterItem;
import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root(name = "result")
public class Restaurant implements Parcelable, ClusterItem {
  @Element(name = "id") public long id;
  @Element(name = "email", required = false) public String email;
  @Element(name = "password", required = false) public String password;
  @Element(name = "firstname", required = false) public String firstName;
  @Element(name = "lastname", required = false) public String lastName;
  @Element(name = "contact_phone", required = false) public String phone;
  @Element(name = "business_name", required = false) public String businessName;
  @Element(name = "business_number", required = false) public String businessNumber;
  @Element(name = "business_description", required = false) public String businessDescription;
  @Element(name = "business_picture", required = false) public String businessPicture;
  @Element(name = "business_address1", required = false) public String address;
  @Element(name = "business_city", required = false) public String city;
  @Element(name = "business_locality", required = false) public String locality;
  @Element(name = "business_postalcode", required = false) public String postalCode;
  @Element(name = "business_country", required = false) public String country;
  @Element(name = "lat", required = false) public double lat;
  @Element(name = "longa", required = false) public double lng;
  @Element(name = "facebook", required = false) public String facebook;
  @Element(name = "twitter", required = false) public String twitter;
  @Element(name = "website", required = false) public String website;
  @Element(name = "rating", required = false) public double rating;
  @Element(name = "ratingcount", required = false) public String ratingCount;
  @Element(name = "category", required = false) public String category;
  @Element(name = "pricelow", required = false) public String priceLow;
  @Element(name = "pricehigh", required = false) public String priceHigh;
  @Element(name = "opentime", required = false) public String openTime;
  @Element(name = "closetime", required = false) public String closeTime;
  @Element(name = "distance", required = false) public String distance;
  @Element(name = "categoryid", required = false) public String categoryId;

  @Element(required = false) Location location;

  public Restaurant() {
    // default constructor
  }

  public Location getLocation() {
    if (location == null) {
      location = new Location("");
      location.setLatitude(lat);
      location.setLongitude(lng);
    }
    return location;
  }

  protected Restaurant(Parcel in) {
    id = in.readLong();
    email = in.readString();
    password = in.readString();
    firstName = in.readString();
    lastName = in.readString();
    phone = in.readString();
    businessName = in.readString();
    businessNumber = in.readString();
    businessDescription = in.readString();
    businessPicture = in.readString();
    address = in.readString();
    city = in.readString();
    locality = in.readString();
    postalCode = in.readString();
    country = in.readString();
    lat = in.readDouble();
    lng = in.readDouble();
    facebook = in.readString();
    twitter = in.readString();
    website = in.readString();
    rating = in.readDouble();
    ratingCount = in.readString();
    categoryId = in.readString();
    priceLow = in.readString();
    priceHigh = in.readString();
    openTime = in.readString();
    closeTime = in.readString();
  }

  @Override
  public int describeContents() {
    return 0;
  }

  @Override
  public void writeToParcel(Parcel dest, int flags) {
    dest.writeLong(id);
    dest.writeString(email);
    dest.writeString(password);
    dest.writeString(firstName);
    dest.writeString(lastName);
    dest.writeString(phone);
    dest.writeString(businessName);
    dest.writeString(businessNumber);
    dest.writeString(businessDescription);
    dest.writeString(businessPicture);
    dest.writeString(address);
    dest.writeString(city);
    dest.writeString(locality);
    dest.writeString(postalCode);
    dest.writeString(country);
    dest.writeDouble(lat);
    dest.writeDouble(lng);
    dest.writeString(facebook);
    dest.writeString(twitter);
    dest.writeString(website);
    dest.writeDouble(rating);
    dest.writeString(ratingCount);
    dest.writeString(categoryId);
    dest.writeString(priceLow);
    dest.writeString(priceHigh);
    dest.writeString(openTime);
    dest.writeString(closeTime);
  }

  @SuppressWarnings("unused")
  public static final Parcelable.Creator<Restaurant> CREATOR =
      new Parcelable.Creator<Restaurant>() {
        @Override
        public Restaurant createFromParcel(Parcel in) {
          return new Restaurant(in);
        }

        @Override
        public Restaurant[] newArray(int size) {
          return new Restaurant[size];
        }
      };

  @Override public LatLng getPosition() {
    return new LatLng(lat, lng);
  }

  static class Builder {
    final Restaurant restaurant;

    Builder(long id) {
      // skip personal info
      restaurant = new Restaurant();
      restaurant.id = id;
      // canned data
      // firstName
      // lastName
      restaurant.businessNumber = "780-318-1058";
    }

    Builder email(String email) {
      restaurant.email = email;
      return this;
    }

    Builder name(String businessName) {
      restaurant.businessName = businessName;
      return this;
    }

    Builder picture(String businessPicture) {
      restaurant.businessPicture = businessPicture;
      return this;
    }

    Builder address(String address) {
      restaurant.address = address;
      return this;
    }

    Builder city(String city) {
      restaurant.city = city;
      return this;
    }

    Builder locality(String locality) {
      restaurant.locality = locality;
      return this;
    }

    Builder postalCode(String postalCode) {
      restaurant.postalCode = postalCode;
      return this;
    }

    Builder country(String country) {
      restaurant.country = country;
      return this;
    }

    Builder lat(double lat) {
      restaurant.lat = lat;
      return this;
    }

    Builder lng(double lng) {
      restaurant.lng = lng;
      return this;
    }

    Builder facebook(String facebook) {
      restaurant.facebook = facebook;
      return this;
    }

    Builder twitter(String twitter) {
      restaurant.twitter = twitter;
      return this;
    }

    Builder website(String website) {
      restaurant.website = website;
      return this;
    }

    Builder rating(double rating) {
      restaurant.rating = rating;
      return this;
    }

    Builder ratingCount(String ratingCount) {
      restaurant.ratingCount = ratingCount;
      return this;
    }

    Builder categoryId(String categoryId) {
      restaurant.categoryId = categoryId;
      return this;
    }

    Builder priceLow(String priceLow) {
      restaurant.priceLow = priceLow;
      return this;
    }

    Builder priceHigh(String priceHigh) {
      restaurant.priceHigh = priceHigh;
      return this;
    }

    Builder openTime(String openTime) {
      restaurant.openTime = openTime;
      return this;
    }

    Builder closeTime(String closeTime) {
      restaurant.closeTime = closeTime;
      return this;
    }

    Restaurant get() {
      return restaurant;
    }
  }

  @Override public String toString() {
    return "Restaurant{" +
        "id=" + id +
        ", email='" + email + '\'' +
        ", password='" + password + '\'' +
        ", firstName='" + firstName + '\'' +
        ", lastName='" + lastName + '\'' +
        ", phone='" + phone + '\'' +
        ", businessName='" + businessName + '\'' +
        ", businessNumber='" + businessNumber + '\'' +
        ", businessDescription='" + businessDescription + '\'' +
        ", businessPicture='" + businessPicture + '\'' +
        ", address='" + address + '\'' +
        ", city='" + city + '\'' +
        ", locality='" + locality + '\'' +
        ", postalCode='" + postalCode + '\'' +
        ", country='" + country + '\'' +
        ", lat=" + lat +
        ", lng=" + lng +
        ", facebook='" + facebook + '\'' +
        ", twitter='" + twitter + '\'' +
        ", website='" + website + '\'' +
        ", rating=" + rating +
        ", ratingCount=" + ratingCount +
        ", categoryId=" + categoryId +
        ", priceLow=" + priceLow +
        ", priceHigh=" + priceHigh +
        ", openTime='" + openTime + '\'' +
        ", closeTime='" + closeTime + '\'' +
        '}';
  }
}