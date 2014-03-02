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

package ca.mymenuapp.ui.debug;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import butterknife.ButterKnife;
import ca.mymenuapp.ui.misc.BindableAdapter;

/**
 * A {@link ca.mymenuapp.ui.misc.BindableAdapter} that displays all values for the given enum.
 */
class EnumAdapter<T extends Enum<T>> extends BindableAdapter<T> {
  private final T[] enumConstants;
  private final boolean showNull;
  private final int nullOffset;

  EnumAdapter(Context context, Class<T> enumType) {
    this(context, enumType, false);
  }

  EnumAdapter(Context context, Class<T> enumType, boolean showNull) {
    super(context);
    this.enumConstants = enumType.getEnumConstants();
    this.showNull = showNull;
    this.nullOffset = showNull ? 1 : 0;
  }

  @Override public final int getCount() {
    return enumConstants.length + nullOffset;
  }

  @Override public final T getItem(int position) {
    if (showNull && position == 0) {
      return null;
    }

    return enumConstants[position - nullOffset];
  }

  @Override public final long getItemId(int position) {
    return position;
  }

  @Override public final View newView(LayoutInflater inflater, int position, ViewGroup container) {
    return inflater.inflate(android.R.layout.simple_spinner_item, container, false);
  }

  @Override public final void bindView(T item, int position, View view) {
    TextView tv = ButterKnife.findById(view, android.R.id.text1);
    tv.setText(getName(item));
  }

  @Override
  public final View newDropDownView(LayoutInflater inflater, int position, ViewGroup container) {
    return inflater.inflate(android.R.layout.simple_spinner_dropdown_item, container, false);
  }

  protected String getName(T item) {
    return String.valueOf(item);
  }
}
