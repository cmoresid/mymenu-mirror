/*
 * Copyright (C) 2014 MyMenu, Inc.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see [http://www.gnu.org/licenses/].
 */

package ca.mymenuapp.data.api.model;

import java.util.List;
import org.simpleframework.xml.Element;
import org.simpleframework.xml.ElementList;
import org.simpleframework.xml.Root;

@Root(name = "results")
public class UserRestrictionResponse {
  @ElementList(name = "result", required = false, inline = true) public List<UserRestrictionLink>
      links;

  @Override public String toString() {
    return "UserRestrictionResponse{" +
        "links=" + links +
        '}';
  }

  @Root(name = "result")
  public static class UserRestrictionLink {
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
}
