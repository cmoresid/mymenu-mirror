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
        return (error == null && expectedError == null) || (error != null && error.toString()
            .equals(expectedError));
      }

      @Override
      public void describeTo(Description description) {
      }
    };
  }
}
