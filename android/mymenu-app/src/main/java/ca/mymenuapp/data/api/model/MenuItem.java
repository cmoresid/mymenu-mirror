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

import android.os.Parcel;
import android.os.Parcelable;
import android.text.TextUtils;
import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root(name = "result")
public class MenuItem implements Parcelable {
  private static final String NULL_STRING = "null";
  private static final String NOT_EDIBLE = "notedible";

  @Element(name = "id", required = false) public long id;
  @Element(name = "merchid", required = false) public long merchantId;
  @Element(name = "name", required = false) public String name;
  @Element(name = "cost", required = false) public float cost;
  @Element(name = "picture", required = false) public String picture;
  @Element(name = "description", required = false) public String description;
  @Element(name = "rating", required = false) public float rating;
  // ratingCount may be null or "null", so keep it as a string!
  @Element(name = "ratingcount", required = false) public String ratingCount;
  @Element(name = "categoryid", required = false) public long categoryId;
  @Element(name = "category", required = false) public String category;
  // flag to mark whether this item is edible by the current user
  @Element(name = "edible") public String edible;

  public MenuItem() {
    // default constructor
  }

  public boolean isNotEdible() {
    return edible.compareTo(NOT_EDIBLE) == 0;
  }

  /**
   * API might return null, or "null", safe way to check for this boundary condition.
   *
   * @return 0 if likeCount is null or "null", else likeCount
   */
  public long getRatingCount() {
    if (TextUtils.isEmpty(ratingCount)) {
      return 0;
    } else if (ratingCount.compareTo(NULL_STRING) == 0) {
      return 0;
    } else {
      return Long.parseLong(ratingCount);
    }
  }

  protected MenuItem(Parcel in) {
    id = in.readLong();
    merchantId = in.readLong();
    name = in.readString();
    cost = in.readFloat();
    picture = in.readString();
    description = in.readString();
    rating = in.readFloat();
    ratingCount = in.readString();
    categoryId = in.readLong();
    category = in.readString();
    edible = in.readString();
  }

  @Override
  public int describeContents() {
    return 0;
  }

  @Override
  public void writeToParcel(Parcel dest, int flags) {
    dest.writeLong(id);
    dest.writeLong(merchantId);
    dest.writeString(name);
    dest.writeFloat(cost);
    dest.writeString(picture);
    dest.writeString(description);
    dest.writeFloat(rating);
    dest.writeString(ratingCount);
    dest.writeLong(categoryId);
    dest.writeString(category);
    dest.writeString(edible);
  }

  @SuppressWarnings("unused")
  public static final Parcelable.Creator<MenuItem> CREATOR = new Parcelable.Creator<MenuItem>() {
    @Override
    public MenuItem createFromParcel(Parcel in) {
      return new MenuItem(in);
    }

    @Override
    public MenuItem[] newArray(int size) {
      return new MenuItem[size];
    }
  };

  @Override public String toString() {
    return "MenuItem{" +
        "id=" + id +
        ", merchantId=" + merchantId +
        ", name='" + name + '\'' +
        ", cost=" + cost +
        ", picture='" + picture + '\'' +
        ", description='" + description + '\'' +
        ", rating=" + rating +
        ", ratingCount='" + ratingCount + '\'' +
        ", categoryId=" + categoryId +
        ", category='" + category + '\'' +
        ", edible=" + edible +
        '}';
  }
}
