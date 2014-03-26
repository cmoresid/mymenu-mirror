package ca.mymenuapp.data.api.model;

import android.os.Parcel;
import android.os.Parcelable;
import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root(name = "result")
public class MenuItemModification implements Parcelable {

  @Element(name = "id", required = false) public long id;
  @Element(name = "restrictid", required = false) public long restrictId;
  @Element(name = "menuid", required = false) public long menuId;
  @Element(name = "modification", required = false) public String modification;

  public MenuItemModification() {
    // default constructor
  }

  protected MenuItemModification(Parcel in) {
    id = in.readLong();
    restrictId = in.readLong();
    menuId = in.readLong();
    modification = in.readString();
  }

  @Override
  public int describeContents() {
    return 0;
  }

  @Override
  public void writeToParcel(Parcel dest, int flags) {
    dest.writeLong(id);
    dest.writeLong(restrictId);
    dest.writeLong(menuId);
    dest.writeString(modification);
  }

  @SuppressWarnings("unused")
  public static final Parcelable.Creator<MenuItemModification> CREATOR =
      new Parcelable.Creator<MenuItemModification>() {
        @Override
        public MenuItemModification createFromParcel(Parcel in) {
          return new MenuItemModification(in);
        }

        @Override
        public MenuItemModification[] newArray(int size) {
          return new MenuItemModification[size];
        }
      };
}
