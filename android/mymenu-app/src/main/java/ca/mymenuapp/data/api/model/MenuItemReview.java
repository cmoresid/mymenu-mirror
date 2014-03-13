package ca.mymenuapp.data.api.model;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root(name = "result")
public class MenuItemReview {
  @Element(name = "id") public long id;
  @Element(name = "useremail") public String userEmail;
  @Element(name = "menuid") public long menuId;
  @Element(name = "merchid") public long merchId;
  @Element(name = "rating") public float rating;
  @Element(name = "ratingdescription") public String description;
  @Element(name = "ratingdate") public String date;
  // likeCount may be null, so keep it as a string!
  @Element(name = "likecount") public String likeCount;

  @Override public String toString() {
    return "MenuItemReview{" +
        "id=" + id +
        ", userEmail='" + userEmail + '\'' +
        ", menuId=" + menuId +
        ", merchId=" + merchId +
        ", rating=" + rating +
        ", description='" + description + '\'' +
        ", date='" + date + '\'' +
        ", likeCount=" + likeCount +
        '}';
  }
}