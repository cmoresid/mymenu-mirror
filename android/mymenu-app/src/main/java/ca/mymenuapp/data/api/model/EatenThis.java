package ca.mymenuapp.data.api.model;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root(name = "result")
public class EatenThis {

  @Element(name = "id") public long id;
  @Element(name = "useremail") public String useremail;
  @Element(name = "menuid", required = false) public String menuId;
  @Element(name = "merchid", required = false) public String merchId;
  @Element(name = "adddate", required = false) public String addDate;

  @Override public String toString() {
    return "EatenThis{" +
        "id=" + id +
        ", useremail='" + useremail + '\'' +
        ", menuId='" + menuId + '\'' +
        ", merchId='" + merchId + '\'' +
        ", addDate='" + addDate + '\'' +
        '}';
  }
}
