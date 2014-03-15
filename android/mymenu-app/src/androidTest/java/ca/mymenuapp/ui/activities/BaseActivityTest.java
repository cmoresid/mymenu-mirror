package ca.mymenuapp.ui.activities;

import android.app.Activity;
import android.test.ActivityInstrumentationTestCase2;

public abstract class BaseActivityTest<T extends Activity>
    extends ActivityInstrumentationTestCase2<T> {

  T activity;

  public BaseActivityTest(Class<T> activityClass) {
    // This constructor was deprecated - but we want to support lower API levels.
    super("com.google.android.apps.common.testing.ui.testapp", activityClass);
  }

  @Override
  public void setUp() throws Exception {
    super.setUp();
    // Espresso will not launch our activity for us, we must launch it via getActivity().
    activity = getActivity();
  }

  String getString(int resourceId) {
    return activity.getString(resourceId);
  }
}
