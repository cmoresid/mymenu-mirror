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
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root(name = "result")
public class MenuItemReview implements Parcelable {
  private static final String NULL_STRING = "null";

  @SuppressWarnings("SimpleDateFormat")
  private static final SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

  @Element(name = "id") public long id;
  @Element(name = "useremail") public String userEmail;
  @Element(name = "menuid") public long menuId;
  @Element(name = "merchid") public long merchId;
  @Element(name = "rating") public float rating;
  @Element(name = "ratingdescription") public String description;
  @Element(name = "ratingdate") public String date;
  // likeCount may be null or "null", so keep it as a string!
  @Element(name = "likecount") public String likeCount;

  public MenuItemReview() {
    // default constructor
  }

  /**
   * API might return null, or "null", safe way to check for this boundary condition.
   *
   * @return 0 if likeCount is null or "null", else likeCount
   */
  public int getLikeCount() {
    if (TextUtils.isEmpty(likeCount)) {
      return 0;
    } else if (likeCount.compareTo(NULL_STRING) == 0) {
      return 0;
    } else {
      return Integer.parseInt(likeCount);
    }
  }

  /**
   * Safe way to get Date of this review. Returns current time if date cannot be parsed.
   */
  public Date getDate() {
    try {
      return formatter.parse(date);
    } catch (ParseException e) {
      return new Date();
    }
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