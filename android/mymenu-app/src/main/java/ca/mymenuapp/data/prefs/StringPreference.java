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

package ca.mymenuapp.data.prefs;

import android.content.SharedPreferences;

/**
 * A wrapper for working with String preferences.
 */
public class StringPreference {
  private final SharedPreferences preferences;
  private final String key;
  private final String defaultValue;

  public StringPreference(SharedPreferences preferences, String key) {
    this(preferences, key, null);
  }

  public StringPreference(SharedPreferences preferences, String key, String defaultValue) {
    this.preferences = preferences;
    this.key = key;
    this.defaultValue = defaultValue;
  }

  public String get() {
    return preferences.getString(key, defaultValue);
  }

  public boolean isSet() {
    return preferences.contains(key);
  }

  public void set(String value) {
    preferences.edit().putString(key, value).apply();
  }

  public void delete() {
    preferences.edit().remove(key).apply();
  }
}
