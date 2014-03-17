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

import android.os.Bundle;
import android.os.IBinder;
import android.os.Parcelable;
import android.util.SparseArray;
import java.io.Serializable;
import java.util.ArrayList;

/**
 * Fluent API for {@link android.os.Bundle}
 * {@code Bundle bundle = new Bundler().put(....).put(....).get();}
 */
public class Bundler {

  private final Bundle bundle;

  // Construct a bundler
  public Bundler() {
    bundle = new Bundle();
  }

  /**
   * Use the provided bundle to back this Bundler.
   * The bundle that is passed will be modified directly.
   */
  public Bundler(Bundle bundle) {
    this.bundle = bundle;
  }

  /**
   * Initialize a Bundler that is copied form the given bundle. The bundle that is passed will not
   * be modified.
   */
  public static Bundler copyFrom(Bundle bundle) {
    Bundler bundler = new Bundler();
    bundler.putAll(bundle);
    return bundler;
  }

  public Bundler put(String key, boolean value) {
    bundle.putBoolean(key, value);
    return this;
  }

  public Bundler put(String key, boolean[] value) {
    bundle.putBooleanArray(key, value);
    return this;
  }

  public Bundler put(String key, IBinder value) {
    // Uncommment this line if your minimum sdk version is API level 18
    //bundle.putBinder(key, value);
    return this;
  }

  public Bundler put(String key, int value) {
    bundle.putInt(key, value);
    return this;
  }

  public Bundler put(String key, int[] value) {
    bundle.putIntArray(key, value);
    return this;
  }

  public Bundler putIntegerArrayList(String key, ArrayList<Integer> value) {
    bundle.putIntegerArrayList(key, value);
    return this;
  }

  public Bundler put(String key, Bundle value) {
    bundle.putBundle(key, value);
    return this;
  }

  public Bundler put(String key, byte value) {
    bundle.putByte(key, value);
    return this;
  }

  public Bundler put(String key, byte[] value) {
    bundle.putByteArray(key, value);
    return this;
  }

  public Bundler put(String key, String value) {
    bundle.putString(key, value);
    return this;
  }

  public Bundler put(String key, String[] value) {
    bundle.putStringArray(key, value);
    return this;
  }

  public Bundler putStringArrayList(String key, ArrayList<String> value) {
    bundle.putStringArrayList(key, value);
    return this;
  }

  public Bundler put(String key, long value) {
    bundle.putLong(key, value);
    return this;
  }

  public Bundler put(String key, long[] value) {
    bundle.putLongArray(key, value);
    return this;
  }

  public Bundler put(String key, float value) {
    bundle.putFloat(key, value);
    return this;
  }

  public Bundler put(String key, float[] value) {
    bundle.putFloatArray(key, value);
    return this;
  }

  public Bundler put(String key, char value) {
    bundle.putChar(key, value);
    return this;
  }

  public Bundler put(String key, char[] value) {
    bundle.putCharArray(key, value);
    return this;
  }

  public Bundler put(String key, CharSequence value) {
    bundle.putCharSequence(key, value);
    return this;
  }

  public Bundler put(String key, CharSequence[] value) {
    bundle.putCharSequenceArray(key, value);
    return this;
  }

  public Bundler putCharSequenceArrayList(String key, ArrayList<CharSequence> value) {
    bundle.putCharSequenceArrayList(key, value);
    return this;
  }

  public Bundler put(String key, double value) {
    bundle.putDouble(key, value);
    return this;
  }

  public Bundler put(String key, double[] value) {
    bundle.putDoubleArray(key, value);
    return this;
  }

  public Bundler put(String key, Parcelable value) {
    bundle.putParcelable(key, value);
    return this;
  }

  public Bundler put(String key, Parcelable[] value) {
    bundle.putParcelableArray(key, value);
    return this;
  }

  public Bundler putParcelableArrayList(String key, ArrayList<? extends Parcelable> value) {
    bundle.putParcelableArrayList(key, value);
    return this;
  }

  public Bundler putSparseParcelableArray(String key, SparseArray<? extends Parcelable> value) {
    bundle.putSparseParcelableArray(key, value);
    return this;
  }

  public Bundler put(String key, short value) {
    bundle.putShort(key, value);
    return this;
  }

  public Bundler put(String key, short[] value) {
    bundle.putShortArray(key, value);
    return this;
  }

  public Bundler put(String key, Serializable value) {
    bundle.putSerializable(key, value);
    return this;
  }

  public Bundler putAll(Bundle map) {
    bundle.putAll(map);
    return this;
  }

  /**
   * Get the underlying bundle.
   */
  public Bundle get() {
    return bundle;
  }

  /**
   * Copy the underlying bundle.
   */
  public Bundle copy() {
    return new Bundle(bundle);
  }
}
