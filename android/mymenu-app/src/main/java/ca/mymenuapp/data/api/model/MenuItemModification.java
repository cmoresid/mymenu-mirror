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