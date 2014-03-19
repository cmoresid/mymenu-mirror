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

package ca.mymenuapp.ui.widgets;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.ScrollView;

public class NotifyingScrollView extends ScrollView {

  public interface OnScrollChangedListener {
    void onScrollChanged(ScrollView who, int l, int t, int oldl, int oldt);
  }

  private OnScrollChangedListener onScrollChangedListener;

  public NotifyingScrollView(Context context) {
    super(context);
  }

  public NotifyingScrollView(Context context, AttributeSet attrs) {
    super(context, attrs);
  }

  public NotifyingScrollView(Context context, AttributeSet attrs, int defStyle) {
    super(context, attrs, defStyle);
  }

  @Override
  protected void onScrollChanged(int l, int t, int oldl, int oldt) {
    super.onScrollChanged(l, t, oldl, oldt);
    if (onScrollChangedListener != null) {
      onScrollChangedListener.onScrollChanged(this, l, t, oldl, oldt);
    }
  }

  public void setOnScrollChangedListener(OnScrollChangedListener listener) {
    onScrollChangedListener = listener;
  }
}