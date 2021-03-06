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

import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root(name = "result")
public class DietaryRestriction {

  @Element(name = "id") public long id;
  @Element(name = "user_label", required = false) public String userLabel;
  @Element(name = "merchant_label", required = false) public String merchantLabel;
  @Element(name = "user_description", required = false) public String userDescription;
  @Element(name = "merchant_description", required = false) public String merchantDescription;
  @Element(name = "picture", required = false) public String picture;

  @Override public String toString() {
    return "DietaryRestriction{" +
        "id=" + id +
        ", userLabel=" + userLabel +
        ", merchantLabel='" + merchantLabel + '\'' +
        ", userDescription=" + userDescription +
        ", merchantDescription='" + merchantDescription + '\'' +
        ", picture='" + picture + '\'' +
        '}';
  }
}
