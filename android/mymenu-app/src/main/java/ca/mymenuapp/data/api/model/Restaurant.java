package ca.mymenuapp.data.api.model;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root(name = "result")
public class Restaurant {
  @Element(name = "id") public long id;
  @Element(name = "email",required = false) public String email;
  @Element(name = "password",required = false) public String password;
  @Element(name = "firstname",required = false) public String firstName;
  @Element(name = "lastname",required = false) public String lastName;
  @Element(name = "contact_phone",required = false) public String phone;
  @Element(name = "business_name",required = false) public String businessName;
  @Element(name = "business_number",required = false) public String businessNumber;
  @Element(name = "business_description",required = false) public String businessDescription;
  @Element(name = "business_picture",required = false) public String businessPicture;
  @Element(name = "business_address1",required = false) public String address;
  @Element(name = "business_city",required = false) public String city;
  @Element(name = "business_locality",required = false) public String locality;
  @Element(name = "business_postalcode",required = false) public String postalCode;
  @Element(name = "business_country",required = false) public String country;
  @Element(name = "lat",required = false) public double lat;
  @Element(name = "longa",required = false) public double lng;
  @Element(name = "facebook",required = false) public String facebook;
  @Element(name = "twitter",required = false) public String twitter;
  @Element(name = "website",required = false) public String website;
  @Element(name = "rating",required = false) public double rating;
  @Element(name = "ratingcount",required = false) public String ratingCount;
  @Element(name = "category",required = false) public String category;
  @Element(name = "pricelow",required = false) public String priceLow;
  @Element(name = "pricehigh",required = false) public String priceHigh;
  @Element(name = "opentime",required = false) public String openTime;
  @Element(name = "closetime",required = false) public String closeTime;
  @Element(name = "distance",required = false) public String distance;
  @Element(name = "categoryid",required = false) public String categoryid;

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
        ", ratingCount='" + ratingCount + '\'' +
        ", category='" + category + '\'' +
        ", priceLow='" + priceLow + '\'' +
        ", priceHigh='" + priceHigh + '\'' +
        ", openTime='" + openTime + '\'' +
        ", closeTime='" + closeTime + '\'' +
        ", distance='" + distance + '\'' +
        '}';
  }
}
