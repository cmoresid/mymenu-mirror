package ca.mymenuapp.ui.activities;

import android.test.ActivityInstrumentationTestCase2;
import android.test.suitebuilder.annotation.LargeTest;
import ca.mymenuapp.R;
import com.squareup.spoon.Spoon;

import static com.google.android.apps.common.testing.ui.espresso.Espresso.onView;
import static com.google.android.apps.common.testing.ui.espresso.action.ViewActions.click;
import static com.google.android.apps.common.testing.ui.espresso.assertion.ViewAssertions.matches;
import static com.google.android.apps.common.testing.ui.espresso.matcher.ViewMatchers.withId;
import static com.google.android.apps.common.testing.ui.espresso.matcher.ViewMatchers.withText;

@LargeTest
public class LoginActivityTest extends ActivityInstrumentationTestCase2<LoginActivity> {
  @SuppressWarnings("deprecation")
  public LoginActivityTest() {
    // This constructor was deprecated - but we want to support lower API levels.
    super("com.google.android.apps.common.testing.ui.testapp", LoginActivity.class);
  }

  @Override
  public void setUp() throws Exception {
    super.setUp();
    // Espresso will not launch our activity for us, we must launch it via getActivity().
    getActivity();
  }

  @SuppressWarnings("unchecked")
  public void testClickLogin() {
    Spoon.screenshot(getActivity(), "initial_state");
    onView(withId(R.id.login)).perform(click());
    onView(withId(R.id.login)).check(matches(withText("Login")));
    Spoon.screenshot(getActivity(), "error");
  }
}
