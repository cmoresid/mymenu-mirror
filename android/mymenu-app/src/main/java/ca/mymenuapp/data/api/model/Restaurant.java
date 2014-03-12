package ca.mymenuapp.data.api.model;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root(name = "row")
public class Restaurant {
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
  @Element(name = "ratingcount") public long ratingCount;
  @Element(name = "categoryid") public long categoryId;
  @Element(name = "pricelow") public long priceLow;
  @Element(name = "pricehigh") public long priceHigh;
  @Element(name = "opentime") public String openTime;
  @Element(name = "closetime") public String closeTime;

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
