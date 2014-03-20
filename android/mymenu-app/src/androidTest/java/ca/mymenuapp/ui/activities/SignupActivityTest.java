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

import android.test.suitebuilder.annotation.LargeTest;
import ca.mymenuapp.R;
import com.squareup.spoon.Spoon;

import static ca.mymenuapp.Matchers.withError;
import static com.google.android.apps.common.testing.ui.espresso.Espresso.onView;
import static com.google.android.apps.common.testing.ui.espresso.action.ViewActions.click;
import static com.google.android.apps.common.testing.ui.espresso.action.ViewActions.scrollTo;
import static com.google.android.apps.common.testing.ui.espresso.assertion.ViewAssertions.matches;
import static com.google.android.apps.common.testing.ui.espresso.matcher.ViewMatchers.withId;

@LargeTest
public class SignUpActivityTest extends BaseActivityTest<SignUpActivity> {

  public SignUpActivityTest() {
    super(SignUpActivity.class);
  }

  public void testEmptyFields() {
    Spoon.screenshot(activity, "initial_state");

    onView(withId(R.id.sign_up)).perform(scrollTo(), click());

    onView(withId(R.id.email)).check(matches(withError(getString(R.string.required))));
    onView(withId(R.id.password)).check(matches(withError(getString(R.string.required))));
    onView(withId(R.id.given_name)).check(matches(withError(getString(R.string.required))));
    onView(withId(R.id.surname)).check(matches(withError(getString(R.string.required))));
    Spoon.screenshot(activity, "error");
  }

  public void testEmptyPassword() {
    Spoon.screenshot(activity, "initial_state");

    // use one that is not on the device, otherwise espresso clicks the selection
    performScrollingType(R.id.email, "test@gmail.com");
    Spoon.screenshot(activity, "entered_email");

    onView(withId(R.id.sign_up)).perform(scrollTo(), click());

    onView(withId(R.id.email)).check(matches(withError(null)));
    onView(withId(R.id.password)).check(matches(withError(getString(R.string.required))));
    Spoon.screenshot(activity, "error");
  }

  public void testInvalidEmail() {
    Spoon.screenshot(activity, "initial_state");

    performScrollingType(R.id.email, "inValidEmail");
    Spoon.screenshot(activity, "entered_email");
    performScrollingType(R.id.password, "someValidPassword");
    Spoon.screenshot(activity, "entered_password");
    performScrollingType(R.id.confirm_password, "someValidPassword");
    Spoon.screenshot(activity, "confirmed_password");

    onView(withId(R.id.sign_up)).perform(scrollTo(), click());

    onView(withId(R.id.email)).check(matches(withError(getString(R.string.invalid))));
    onView(withId(R.id.password)).check(matches(withError(null)));
    onView(withId(R.id.confirm_password)).check(matches(withError(null)));
    Spoon.screenshot(activity, "error");
  }

  public void testEmptyEmail() {
    Spoon.screenshot(activity, "initial_state");

    performScrollingType(R.id.password, "aValidPassword");
    Spoon.screenshot(activity, "entered_password");
    performScrollingType(R.id.confirm_password, "aValidPassword");
    Spoon.screenshot(activity, "confirmed_password");

    onView(withId(R.id.sign_up)).perform(scrollTo(), click());

    onView(withId(R.id.email)).check(matches(withError(getString(R.string.required))));
    onView(withId(R.id.password)).check(matches(withError(null)));
    onView(withId(R.id.confirm_password)).check(matches(withError(null)));
    Spoon.screenshot(activity, "error");
  }

  public void testShortPassword() {
    Spoon.screenshot(activity, "initial_state");

    performScrollingType(R.id.email, "test@gmail.com");
    Spoon.screenshot(activity, "entered_email");
    performScrollingType(R.id.password, "abs");
    Spoon.screenshot(activity, "entered_password");
    performScrollingType(R.id.confirm_password, "abs");
    Spoon.screenshot(activity, "confirmed_password");

    onView(withId(R.id.sign_up)).perform(scrollTo(), click());

    onView(withId(R.id.email)).check(matches(withError(null)));
    onView(withId(R.id.password)).check(matches(withError(getString(R.string.password_length))));
    Spoon.screenshot(activity, "error");
  }

  public void testPasswordsDoNotMatch() {
    Spoon.screenshot(activity, "initial_state");

    performScrollingType(R.id.email, "test@gmail.com");
    Spoon.screenshot(activity, "entered_email");
    performScrollingType(R.id.password, "aValidPassword");
    Spoon.screenshot(activity, "entered_password");
    performScrollingType(R.id.confirm_password, "aValidButNotSamePassword");
    Spoon.screenshot(activity, "confirmed_password");

    onView(withId(R.id.sign_up)).perform(scrollTo(), click());

    onView(withId(R.id.email)).check(matches(withError(null)));
    onView(withId(R.id.password)).check(matches(withError(null)));
    onView(withId(R.id.confirm_password)).check(
        matches(withError(getString(R.string.passwords_do_not_match))));
    Spoon.screenshot(activity, "error");
  }
}
