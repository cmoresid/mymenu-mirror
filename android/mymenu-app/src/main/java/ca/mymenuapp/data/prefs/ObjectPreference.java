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
import com.google.gson.Gson;
import java.lang.reflect.Type;

/**
 * A wrapper for working with generic object preferences.
 */
public class ObjectPreference<T> {
  private final SharedPreferences preferences;
  private final String key;
  private final Gson gson;
  private final Type type;
  private final T defaultValue;
  private T value;

  /**
   * Initialize a ObjectPreference preference with the given key and no default value.
   */
  public ObjectPreference(SharedPreferences preferences, Gson gson, Class<T> type, String key) {
    this(preferences, gson, type, key, null);
  }

  /**
   * Initialize a ObjectPreference preference with the given key and the provided default value.
   */
  public ObjectPreference(SharedPreferences preferences, Gson gson, Class<T> type, String key,
      T defaultValue) {
    this.preferences = preferences;
    this.key = key;
    this.gson = gson;
    this.type = type;
    this.defaultValue = defaultValue;
  }

  public T get() {
    if (value == null) {
      String stringValue = preferences.getString(key, null);
      if (stringValue == null) {
        return defaultValue;
      }
      value = gson.fromJson(stringValue, type);
    }
    return value;
  }

  public void save() {
    set(value);
  }

  public boolean isSet() {
    return preferences.contains(key);
  }

  public void set(T value) {
    String stringValue = gson.toJson(value, type);
    preferences.edit().putString(key, stringValue).apply();
    this.value = value;
  }

  public void delete() {
    value = null;
    preferences.edit().remove(key).apply();
  }
}
