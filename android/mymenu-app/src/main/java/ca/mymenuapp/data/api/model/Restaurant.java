package ca.mymenuapp.data.api.model;

import android.os.Parcel;
import android.os.Parcelable;
import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root(name = "result")
public class Restaurant implements Parcelable {
  @Element(name = "id") public long id;
  @Element(name = "email") public String email;
  @Element(name = "password") public String password;
  @Element(name = "firstname") public String firstName;
  @Element(name = "lastname") public String lastName;
  @Element(name = "contact_phone") public String phone;
  @Element(name = "business_name") public String businessName;
  @Element(name = "business_number") public String businessNumber;
  @Element(name = "business_description") public String businessDescription;
  @Element(name = "business_picture") public String businessPicture;
  @Element(name = "business_address1") public String address;
  @Element(name = "business_city") public String city;
  @Element(name = "business_locality") public String locality;
  @Element(name = "business_postalcode") public String postalCode;
  @Element(name = "business_country") public String country;
  @Element(name = "lat") public double lat;
  @Element(name = "longa") public double lng;
  @Element(name = "facebook") public String facebook;
  @Element(name = "twitter") public String twitter;
  @Element(name = "website") public String website;
  @Element(name = "rating") public double rating;
  @Element(name = "ratingcount") public String ratingCount;
  @Element(name = "categoryid") public String categoryId;
  @Element(name = "pricelow") public String priceLow;
  @Element(name = "pricehigh") public String priceHigh;
  @Element(name = "opentime") public String openTime;
  @Element(name = "closetime") public String closeTime;

  public Restaurant() {
    // default constructor
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

  static class Builder {
    final Restaurant restaurant;

    Builder(long id) {
      // skip personal info
      restaurant = new Restaurant();
      restaurant.id = id;
      // canned data
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
