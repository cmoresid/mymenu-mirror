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
import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root(name = "result")
public class MenuItem implements Parcelable {
  @Element(name = "id") public long id;
  @Element(name = "merchid") public long merchantId;
  @Element(name = "name") public String name;
  @Element(name = "cost") public float cost;
  @Element(name = "picture", required = false) public String picture;
  @Element(name = "description") public String description;
  @Element(name = "rating") public float rating;
  @Element(name = "ratingcount") public long ratingCount;
  @Element(name = "categoryid") public long categoryId;

  // flag to mark whether this item is edible by the current user
  @Element(required = false) public boolean edible;

  public MenuItem() {
    // default constructor
  }

  protected MenuItem(Parcel in) {
    id = in.readLong();
    merchantId = in.readLong();
    name = in.readString();
    cost = in.readFloat();
    picture = in.readString();
    description = in.readString();
    rating = in.readFloat();
    ratingCount = in.readLong();
    categoryId = in.readLong();
    edible = in.readByte() != 0x00;
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
    dest.writeLong(ratingCount);
    dest.writeLong(categoryId);
    dest.writeByte((byte) (edible ? 0x01 : 0x00));
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
