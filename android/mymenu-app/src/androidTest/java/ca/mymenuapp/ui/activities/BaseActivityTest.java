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

package ca.mymenuapp.ui.activities;

import android.app.Activity;
import android.test.ActivityInstrumentationTestCase2;

import static com.google.android.apps.common.testing.ui.espresso.Espresso.onView;
import static com.google.android.apps.common.testing.ui.espresso.action.ViewActions.closeSoftKeyboard;
import static com.google.android.apps.common.testing.ui.espresso.action.ViewActions.scrollTo;
import static com.google.android.apps.common.testing.ui.espresso.action.ViewActions.typeText;
import static com.google.android.apps.common.testing.ui.espresso.matcher.ViewMatchers.withId;

/**
 * A base activity for tests.
 *
 * For views that are in a scroll view, be sure to call
 * {@link com.google.android.apps.common.testing.ui.espresso.action.ViewActions#scrollTo}.
 * For typing text, call
 * {@link com.google.android.apps.common.testing.ui.espresso.action.ViewActions#closeSoftKeyboard}
 */
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

  /**
   * Type in an {@link android.widget.EditText} that may be in a scrollview.
   */
  static void performScrollingType(int id, String text) {
    onView(withId(id)).perform(scrollTo(), typeText(text), closeSoftKeyboard());
  }
}
