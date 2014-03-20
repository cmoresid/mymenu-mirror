package ca.mymenuapp.data.api.model;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root(name = "result")
public class UserRestrictionLink {
  @Element(name = "id") public long id;
  @Element(name = "restrictid") public long restrictId;
  @Element(name = "email") public String email;

  @Override public String toString() {
    return "UserRestrictionLink{" +
        "id=" + id +
        ", restrictId=" + restrictId +
        ", email='" + email + '\'' +
        '}';
  }
}
