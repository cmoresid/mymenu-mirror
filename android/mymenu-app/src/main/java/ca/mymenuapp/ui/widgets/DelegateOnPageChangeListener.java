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

import android.support.v4.view.ViewPager;
import ca.mymenuapp.util.CollectionUtils;
import java.util.ArrayList;
import java.util.List;

/**
 * A {@link ViewPager.OnPageChangeListener} that can notify multiple listeners.
 *
 * Used in MainActivity, since we have one listener to enable/disable menu items
 * based on the page (from our SlidingPanel), and one for swiping between tabs (that updates
 * the action bar indicator)
 */
public class DelegateOnPageChangeListener implements ViewPager.OnPageChangeListener {

  private List<ViewPager.OnPageChangeListener> pageChangeListeners;

  public DelegateOnPageChangeListener() {
    pageChangeListeners = new ArrayList<>();
  }

  public void addOnPageChangeListener(ViewPager.OnPageChangeListener listener) {
    pageChangeListeners.add(listener);
  }

  @Override
  public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
    if (!CollectionUtils.isNullOrEmpty(pageChangeListeners)) {
      for (ViewPager.OnPageChangeListener listener : pageChangeListeners) {
        listener.onPageScrolled(position, positionOffset, positionOffsetPixels);
      }
    }
  }

  @Override public void onPageSelected(int position) {
    if (!CollectionUtils.isNullOrEmpty(pageChangeListeners)) {
      for (ViewPager.OnPageChangeListener listener : pageChangeListeners) {
        listener.onPageSelected(position);
      }
    }
  }

  @Override public void onPageScrollStateChanged(int state) {
    if (!CollectionUtils.isNullOrEmpty(pageChangeListeners)) {
      for (ViewPager.OnPageChangeListener listener : pageChangeListeners) {
        listener.onPageScrollStateChanged(state);
      }
    }
  }
}
