package ca.mymenuapp.data.api.model;

import java.util.List;
import org.simpleframework.xml.ElementList;
import org.simpleframework.xml.Root;

@Root(name = "result")
public class MenuItemReviewResponse {
  @ElementList(name = "result", required = false, inline = true) public List<MenuItemReview>
      reviews;

  @Override public String toString() {
    return "MenuItemReviewResponse{" +
        "reviews=" + reviews +
        '}';
  }
}