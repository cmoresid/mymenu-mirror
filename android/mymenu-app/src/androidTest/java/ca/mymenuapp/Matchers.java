package ca.mymenuapp;

import android.view.View;
import android.widget.EditText;
import org.hamcrest.Description;
import org.hamcrest.Matcher;
import org.hamcrest.TypeSafeMatcher;

public class Matchers {
  private Matchers() {
    // no instances.
  }

  public static Matcher<View> withError(final String expectedError) {
    return new TypeSafeMatcher<View>() {
      @Override
      public boolean matchesSafely(View view) {
        if (!(view instanceof EditText)) {
          return false;
        }

        CharSequence error = ((EditText) view).getError();
        return error == null && expectedError == null || error != null && expectedError.equals(
            error.toString());
      }

      @Override
      public void describeTo(Description description) {
      }
    };
  }
}
