package ca.mymenuapp.data.api.model;

import java.util.List;
import org.simpleframework.xml.ElementList;
import org.simpleframework.xml.Root;

@Root(name = "result")
public class EatenThisResponse {
  @ElementList(name = "result", required = false, inline = true) public List<EatenThis> eatenThis;

  @Override public String toString() {
    return "EatenThisResponse{" +
        "eatenThis=" + eatenThis +
        '}';
  }
}
