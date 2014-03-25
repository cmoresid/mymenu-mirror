package ca.mymenuapp.data.api.model;

import java.util.List;
import org.simpleframework.xml.ElementList;
import org.simpleframework.xml.Root;

@Root(name = "results")
public class RestrictedMenuResponse {
  @ElementList(name = "result", required = false, inline = true) public List<MenuItem> menuItems;

  @Override public String toString() {
    return "RestrictedMenuResponse{" +
        "menuItems=" + menuItems +
        '}';
  }
}
