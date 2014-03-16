package ca.mymenuapp.data.api.model;

import android.os.Parcel;
import android.os.Parcelable;
import android.test.AndroidTestCase;

/**
 * Base class for testing {@link android.os.Parcelable} implementations.
 */
public class ParcelableTestCase<T extends Parcelable> extends AndroidTestCase {

  Parcel parcel;

  @Override public void setUp() throws Exception {
    super.setUp();
    parcel = Parcel.obtain();
  }
}
