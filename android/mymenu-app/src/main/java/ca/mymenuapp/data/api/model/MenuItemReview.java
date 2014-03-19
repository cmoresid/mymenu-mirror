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
public class MenuItemReview implements Parcelable {
  @Element(name = "id") public long id;
  @Element(name = "useremail") public String userEmail;
  @Element(name = "menuid") public long menuId;
  @Element(name = "merchid") public long merchId;
  @Element(name = "rating") public float rating;
  @Element(name = "ratingdescription") public String description;
  @Element(name = "ratingdate") public String date;
  // likeCount may be null, so keep it as a string!
  @Element(name = "likecount") public String likeCount;

  public MenuItemReview() {
    // default constructor
  }

  protected MenuItemReview(Parcel in) {
    id = in.readLong();
    userEmail = in.readString();
    menuId = in.readLong();
    merchId = in.readLong();
    rating = in.readFloat();
    description = in.readString();
    date = in.readString();
    likeCount = in.readString();
  }

  @Override
  public int describeContents() {
    return 0;
  }

  @Override
  public void writeToParcel(Parcel dest, int flags) {
    dest.writeLong(id);
    dest.writeString(userEmail);
    dest.writeLong(menuId);
    dest.writeLong(merchId);
    dest.writeFloat(rating);
    dest.writeString(description);
    dest.writeString(date);
    dest.writeString(likeCount);
  }

  @SuppressWarnings("unused")
  public static final Parcelable.Creator<MenuItemReview> CREATOR =
      new Parcelable.Creator<MenuItemReview>() {
        @Override
        public MenuItemReview createFromParcel(Parcel in) {
          return new MenuItemReview(in);
        }

        @Override
        public MenuItemReview[] newArray(int size) {
          return new MenuItemReview[size];
        }
      };

  @Override public String toString() {
    return "MenuItemReview{" +
        "id=" + id +
        ", userEmail='" + userEmail + '\'' +
        ", menuId=" + menuId +
        ", merchId=" + merchId +
        ", rating=" + rating +
        ", description='" + description + '\'' +
        ", date='" + date + '\'' +
        ", likeCount=" + likeCount +
        '}';
  }
}