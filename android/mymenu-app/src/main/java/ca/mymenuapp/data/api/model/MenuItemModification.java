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
public class MenuItemModification implements Parcelable {

  @Element(name = "id", required = false) public long id;

  /* The id of the restriction this modification is for.  */
  @Element(name = "restrictid", required = false) public long restrictId;

  /* The id of the menu item this modification is for.  */
  @Element(name = "menuid", required = false) public long menuId;
  @Element(name = "modification", required = false) public String modification;

  @Override public int describeContents() {
    return 0;
  }

  protected MenuItemModification() {

  }

  @SuppressWarnings("unused")
  public static final Parcelable.Creator<MenuItemModification> CREATOR =
      new Parcelable.Creator<MenuItemModification>() {

        @Override public MenuItemModification createFromParcel(Parcel parcel) {
          return null;
        }

        @Override public MenuItemModification[] newArray(int i) {
          return new MenuItemModification[0];
        }
      };

  protected MenuItemModification(Parcel in) {
    id = in.readLong();
    restrictId = in.readLong();
    menuId = in.readLong();
    modification = in.readString();
  }

  @Override public void writeToParcel(Parcel parcel, int i) {
    parcel.writeLong(id);
    parcel.writeLong(restrictId);
    parcel.writeLong(menuId);
    parcel.writeString(modification);
  }

  @Override public String toString() {
    return "MenuItemModification{" +
        "id=" + id +
        ", restrictId=" + restrictId +
        ", menuId=" + menuId +
        ", modification='" + modification + '\'' +
        '}';
  }
}