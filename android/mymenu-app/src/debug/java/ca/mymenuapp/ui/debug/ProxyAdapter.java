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
import ca.mymenuapp.data.prefs.StringPreference;
import ca.mymenuapp.ui.misc.BindableAdapter;

import static butterknife.ButterKnife.findById;

/**
 * A {@link ca.mymenuapp.ui.misc.BindableAdapter} to display all {@link
 * ca.mymenuapp.data.DebugDataModule#DEBUG_NETWORK_PROXY} choices.
 */
class ProxyAdapter extends BindableAdapter<String> {
  public static final int NONE = 0;
  public static final int PROXY = 1;

  private final StringPreference proxy;

  ProxyAdapter(Context context, StringPreference proxy) {
    super(context);
    if (proxy == null) {
      throw new IllegalStateException("proxy == null");
    }
    this.proxy = proxy;
  }

  @Override public int getCount() {
    return 2 /* "None" and "Set" */ + (proxy.isSet() ? 1 : 0);
  }

  @Override public String getItem(int position) {
    if (position == 0) {
      return "None";
    }
    if (position == getCount() - 1) {
      return "Set...";
    }
    return proxy.get();
  }

  @Override public long getItemId(int position) {
    return position;
  }

  @Override public View newView(LayoutInflater inflater, int position, ViewGroup container) {
    return inflater.inflate(android.R.layout.simple_spinner_item, container, false);
  }

  @Override public void bindView(String item, int position, View view) {
    TextView tv = findById(view, android.R.id.text1);
    tv.setText(item);
  }

  @Override
  public View newDropDownView(LayoutInflater inflater, int position, ViewGroup container) {
    return inflater.inflate(android.R.layout.simple_spinner_dropdown_item, container, false);
  }
}
