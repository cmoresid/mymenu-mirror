package ca.mymenuapp.data.api.model;

import java.util.List;
import org.simpleframework.xml.ElementList;
import org.simpleframework.xml.Root;

@Root(name = "results")

public class RestaurantResponse {

  @ElementList(name = "result", inline = true) public List<Restaurant> restList;
  @ElementList(required = false) public long timestamp;

  @Override
  public String toString() {
    return "RestaurantResponse{" +
        "restList=" + restList +
        '}';
  }
}