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

import android.app.Instrumentation;
import android.content.IntentFilter;
import android.test.suitebuilder.annotation.LargeTest;
import ca.mymenuapp.R;
import com.squareup.spoon.Spoon;

import static ca.mymenuapp.Matchers.withError;
import static com.google.android.apps.common.testing.ui.espresso.Espresso.onView;
import static com.google.android.apps.common.testing.ui.espresso.action.ViewActions.click;
import static com.google.android.apps.common.testing.ui.espresso.action.ViewActions.closeSoftKeyboard;
import static com.google.android.apps.common.testing.ui.espresso.action.ViewActions.scrollTo;
import static com.google.android.apps.common.testing.ui.espresso.action.ViewActions.typeText;
import static com.google.android.apps.common.testing.ui.espresso.assertion.ViewAssertions.matches;
import static com.google.android.apps.common.testing.ui.espresso.matcher.ViewMatchers.withId;
import static org.fest.assertions.api.ANDROID.assertThat;

@LargeTest
public class LoginActivityTest extends BaseActivityTest<LoginActivity> {

  public LoginActivityTest() {
    super(LoginActivity.class);
  }

  public void testEmptyEmailAndPassword() {
    Spoon.screenshot(activity, "initial_state");

    onView(withId(R.id.login)).perform(scrollTo(), click());

    onView(withId(R.id.email)).check(matches(withError(getString(R.string.required))));
    onView(withId(R.id.password)).check(matches(withError(getString(R.string.required))));
    Spoon.screenshot(activity, "error");
  }

  public void testEmptyPassword() {
    Spoon.screenshot(activity, "initial_state");

    // use one that is not on the device, otherwise espresso clicks the selection and not login
    onView(withId(R.id.email)).perform(scrollTo(), typeText("test@gmail.com"), closeSoftKeyboard());
    Spoon.screenshot(activity, "entered_input");

    onView(withId(R.id.login)).perform(scrollTo(), click());

    onView(withId(R.id.email)).check(matches(withError(null)));
    onView(withId(R.id.password)).check(matches(withError(getString(R.string.required))));
    Spoon.screenshot(activity, "error");
  }

  public void testInvalidEmail() {
    Spoon.screenshot(activity, "initial_state");

    onView(withId(R.id.email)).perform(scrollTo(), typeText("inValidEmail"), closeSoftKeyboard());
    onView(withId(R.id.password)).perform(scrollTo(), typeText("someValidPassword"),
        closeSoftKeyboard());
    Spoon.screenshot(activity, "entered_input");

    onView(withId(R.id.login)).perform(scrollTo(), click());

    onView(withId(R.id.email)).check(matches(withError(getString(R.string.invalid))));
    onView(withId(R.id.password)).check(matches(withError(null)));
    Spoon.screenshot(activity, "error");
  }

  public void testEmptyEmail() {
    Spoon.screenshot(activity, "initial_state");

    onView(withId(R.id.password)).perform(scrollTo(), typeText("aValidPassword"),
        closeSoftKeyboard());
    Spoon.screenshot(activity, "entered_input");

    onView(withId(R.id.login)).perform(scrollTo(), click());

    onView(withId(R.id.email)).check(matches(withError(getString(R.string.required))));
    onView(withId(R.id.password)).check(matches(withError(null)));
    Spoon.screenshot(activity, "error");
  }

  public void testValidLogin() {
    IntentFilter filter = new IntentFilter();
    Instrumentation.ActivityMonitor monitor = getInstrumentation().addMonitor(filter, null, false);
    Spoon.screenshot(activity, "initial_state");

    onView(withId(R.id.email)).perform(scrollTo(), typeText("spiderman@avengers.com"));
    onView(withId(R.id.password)).perform(scrollTo(), typeText("spiderman"), closeSoftKeyboard());
    Spoon.screenshot(activity, "entered_input");
    onView(withId(R.id.login)).perform(scrollTo(), click());

    // Verify new activity was shown.
    getInstrumentation().waitForMonitor(monitor);
    assertThat(monitor).hasHits(1);
    Spoon.screenshot(getActivity(), "next_activity_shown");

    // clear the user that may have been set
    activity.userPreference.set(null);
  }
}
