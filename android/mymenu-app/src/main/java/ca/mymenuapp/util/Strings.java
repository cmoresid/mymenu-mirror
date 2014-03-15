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

package ca.mymenuapp.util;

import android.text.TextUtils;
import android.util.Patterns;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * String utilities.
 */
public final class Strings {
  private Strings() {
    // No instances.
  }

  public static boolean isBlank(CharSequence string) {
    return (string == null || string.toString().trim().length() == 0);
  }

  /** Returns defaultString if string is blank, otherwise return string. */
  public static String valueOrDefault(String string, String defaultString) {
    return isBlank(string) ? defaultString : string;
  }

  /** Truncate the string at the given index. */
  public static String truncateAt(String string, int length) {
    return string.length() > length ? string.substring(0, length) : string;
  }

  /**
   * Returns true if the given string is an email.
   */
  public static boolean isEmail(String string) {
    if (TextUtils.isEmpty(string)) {
      return false;
    }

    final Pattern emailPattern = Patterns.EMAIL_ADDRESS;
    final Matcher matcher = emailPattern.matcher(string);
    return matcher.matches();
  }
}