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

package ca.mymenuapp.ui.misc;

import android.content.Context;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/**
 * A {@link ca.mymenuapp.ui.misc.BindableAdapter} that displays a list of items.
 */
public abstract class BindableListAdapter<T> extends BindableAdapter<T> {

  final List<T> list;

  public BindableListAdapter(Context context, List<T> list) {
    super(context);
    this.list = list;
  }

  @Override public int getCount() {
    return list.size();
  }

  @Override public T getItem(int position) {
    return list.get(position);
  }

  @Override public long getItemId(int position) {
    return position;
  }

  /**
   * Sort the backing list with the given comparator.
   */
  public void sort(Comparator<T> comparator) {
    Collections.sort(list, comparator);
    notifyDataSetChanged();
  }
}
