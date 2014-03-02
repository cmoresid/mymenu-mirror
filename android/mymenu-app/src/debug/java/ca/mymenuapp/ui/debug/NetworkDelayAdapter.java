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
import ca.mymenuapp.ui.misc.BindableAdapter;

import static butterknife.ButterKnife.findById;

/**
 * A {@link ca.mymenuapp.ui.misc.BindableAdapter} to displays choices for mocking network delay.
 */
class NetworkDelayAdapter extends BindableAdapter<Long> {
  private static final long[] VALUES = {
      250, 500, 1000, 2000, 3000
  };

  public static int getPositionForValue(long value) {
    for (int i = 0; i < VALUES.length; i++) {
      if (VALUES[i] == value) {
        return i;
      }
    }
    return 3; // Default to 2000 if something changes.
  }

  NetworkDelayAdapter(Context context) {
    super(context);
  }

  @Override public int getCount() {
    return VALUES.length;
  }

  @Override public Long getItem(int position) {
    return VALUES[position];
  }

  @Override public long getItemId(int position) {
    return position;
  }

  @Override public View newView(LayoutInflater inflater, int position, ViewGroup container) {
    return inflater.inflate(android.R.layout.simple_spinner_item, container, false);
  }

  @Override public void bindView(Long item, int position, View view) {
    TextView tv = findById(view, android.R.id.text1);
    tv.setText(item + "ms");
  }

  @Override
  public View newDropDownView(LayoutInflater inflater, int position, ViewGroup container) {
    return inflater.inflate(android.R.layout.simple_spinner_dropdown_item, container, false);
  }
}
