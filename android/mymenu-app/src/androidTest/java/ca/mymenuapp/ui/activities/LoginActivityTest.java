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
