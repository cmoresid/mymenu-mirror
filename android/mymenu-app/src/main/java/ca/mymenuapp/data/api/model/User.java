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
import org.simpleframework.xml.Root;

@Root(name = "result")
public class User {

  private static final String IS_GUEST = "guest@mymenu.ca";

  @Element(name = "id") public long id;
  @Element(name = "email") public String email;
  @Element(name = "firstname") public String firstName;
  @Element(name = "lastname") public String lastName;
  @Element(name = "password") public String password;
  @Element(name = "city") public String city;
  @Element(name = "locality") public String locality;
  @Element(name = "country") public String country;
  @Element(name = "gender") public char gender;
  @Element(name = "birthday") public int birthday;
  @Element(name = "birthmonth") public int birthmonth;
  @Element(name = "birthyear") public int birthyear;
  @Element(name = "facebookid", required = false) public String facebookid;

  // List of restrictions for this user
  @Element(required = false) public List<Long> restrictions;

  public boolean isGuest() {
    if (this.email.compareTo(IS_GUEST) == 0) {
      return true;
    }
    return false;
  }

  @Override public String toString() {
    return "User{" +
        "id=" + id +
        ", email='" + email + '\'' +
        ", firstName='" + firstName + '\'' +
        ", lastName='" + lastName + '\'' +
        ", password='" + password + '\'' +
        ", city='" + city + '\'' +
        ", locality='" + locality + '\'' +
        ", country='" + country + '\'' +
        ", gender=" + gender +
        ", birthday=" + birthday +
        ", birthmonth=" + birthmonth +
        ", birthyear=" + birthyear +
        ", facebookid='" + facebookid + '\'' +
        ", restrictions=" + restrictions +
        '}';
  }
}
