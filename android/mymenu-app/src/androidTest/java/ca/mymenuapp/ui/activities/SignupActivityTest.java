package ca.mymenuapp.ui.activities;

import android.test.suitebuilder.annotation.LargeTest;
import ca.mymenuapp.R;
import com.squareup.spoon.Spoon;

import static ca.mymenuapp.Matchers.withError;
import static com.google.android.apps.common.testing.ui.espresso.Espresso.onView;
import static com.google.android.apps.common.testing.ui.espresso.action.ViewActions.click;
import static com.google.android.apps.common.testing.ui.espresso.action.ViewActions.closeSoftKeyboard;
import static com.google.android.apps.common.testing.ui.espresso.action.ViewActions.typeText;
import static com.google.android.apps.common.testing.ui.espresso.assertion.ViewAssertions.matches;
import static com.google.android.apps.common.testing.ui.espresso.matcher.ViewMatchers.withId;

@LargeTest
public class SignUpActivityTest extends BaseActivityTest<SignUpActivity> {

  public SignUpActivityTest() {
    super(SignUpActivity.class);
  }

  public void testEmptyFields() {
    Spoon.screenshot(activity, "initial_state");

    onView(withId(R.id.sign_up)).perform(click());

    onView(withId(R.id.email)).check(matches(withError(getString(R.string.required))));
    onView(withId(R.id.password)).check(matches(withError(getString(R.string.required))));
    onView(withId(R.id.given_name)).check(matches(withError(getString(R.string.required))));
    onView(withId(R.id.surname)).check(matches(withError(getString(R.string.required))));
    Spoon.screenshot(activity, "error");
  }

  public void testEmptyPassword() {
    Spoon.screenshot(activity, "initial_state");

    // use one that is not on the device, otherwise espresso clicks the selection
    onView(withId(R.id.email)).perform(typeText("test@gmail.com"), closeSoftKeyboard());
    Spoon.screenshot(activity, "entered_input");

    onView(withId(R.id.sign_up)).perform(click());

    onView(withId(R.id.email)).check(matches(withError(null)));
    onView(withId(R.id.password)).check(matches(withError(getString(R.string.required))));
    Spoon.screenshot(activity, "error");
  }

  public void testInvalidEmail() {
    Spoon.screenshot(activity, "initial_state");

    onView(withId(R.id.email)).perform(typeText("inValidEmail"), closeSoftKeyboard());
    onView(withId(R.id.password)).perform(typeText("someValidPassword"), closeSoftKeyboard());
    onView(withId(R.id.confirm_password)).perform(typeText("someValidPassword"),
        closeSoftKeyboard());
    Spoon.screenshot(activity, "entered_input");

    onView(withId(R.id.sign_up)).perform(click());

    onView(withId(R.id.email)).check(matches(withError(getString(R.string.invalid))));
    onView(withId(R.id.password)).check(matches(withError(null)));
    onView(withId(R.id.confirm_password)).check(matches(withError(null)));
    Spoon.screenshot(activity, "error");
  }

  public void testEmptyEmail() {
    Spoon.screenshot(activity, "initial_state");

    onView(withId(R.id.password)).perform(typeText("aValidPassword"), closeSoftKeyboard());
    onView(withId(R.id.confirm_password)).perform(typeText("aValidPassword"),
        closeSoftKeyboard());
    Spoon.screenshot(activity, "entered_input");

    onView(withId(R.id.sign_up)).perform(click());

    onView(withId(R.id.email)).check(matches(withError(getString(R.string.required))));
    onView(withId(R.id.password)).check(matches(withError(null)));
    onView(withId(R.id.confirm_password)).check(matches(withError(null)));
    Spoon.screenshot(activity, "error");
  }

  public void testShortPassword() {
    Spoon.screenshot(activity, "initial_state");

    onView(withId(R.id.email)).perform(typeText("test@gmail.com"), closeSoftKeyboard());
    onView(withId(R.id.password)).perform(typeText("abs"), closeSoftKeyboard());
    onView(withId(R.id.confirm_password)).perform(typeText("abs"), closeSoftKeyboard());
    Spoon.screenshot(activity, "entered_input");

    onView(withId(R.id.sign_up)).perform(click());

    onView(withId(R.id.email)).check(matches(withError(null)));
    onView(withId(R.id.password)).check(matches(withError(getString(R.string.password_length))));
    Spoon.screenshot(activity, "error");
  }

  public void testPasswordsDoNotMatch() {
    Spoon.screenshot(activity, "initial_state");

    onView(withId(R.id.email)).perform(typeText("test@gmail.com"), closeSoftKeyboard());
    onView(withId(R.id.password)).perform(typeText("aValidPassword"), closeSoftKeyboard());
    onView(withId(R.id.confirm_password)).perform(typeText("aValidButNotSamePassword"),
        closeSoftKeyboard());
    Spoon.screenshot(activity, "entered_input");

    onView(withId(R.id.sign_up)).perform(click());

    onView(withId(R.id.email)).check(matches(withError(null)));
    onView(withId(R.id.password)).check(matches(withError(null)));
    onView(withId(R.id.confirm_password)).check(matches(withError(getString(R.string.passwords_do_not_match))));
    Spoon.screenshot(activity, "error");
  }
}
