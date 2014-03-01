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

package ca.mymenuapp.model;

import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root(name = "row")
public class Menu {

  @Element(name = "id") public long id;
  @Element(name = "merchid") public long merchantId;
  @Element(name = "name") public String name;
  @Element(name = "cost") public float cost;
  @Element(name = "picture", required = false) public String picture;
  @Element(name = "description") public String description;
  @Element(name = "rating") public float rating;
  @Element(name = "ratingcount") public long ratingCount;
  @Element(name = "categoryid") public int categoryId;

  @Override public String toString() {
    return "Menu{" +
        "id=" + id +
        ", merchantId=" + merchantId +
        ", name='" + name + '\'' +
        ", cost=" + cost +
        ", picture='" + picture + '\'' +
        ", description='" + description + '\'' +
        ", rating=" + rating +
        ", ratingCount=" + ratingCount +
        ", categoryId=" + categoryId +
        '}';
  }
}
