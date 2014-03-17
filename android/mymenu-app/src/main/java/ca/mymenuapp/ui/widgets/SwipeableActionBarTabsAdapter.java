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

import android.app.ActionBar;
import android.app.Activity;
import android.app.Fragment;
import android.app.FragmentTransaction;
import android.content.Context;
import android.os.Bundle;
import android.support.v13.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import java.util.ArrayList;

/**
 * This is a helper class that implements the management of tabs and all
 * details of connecting a ViewPager with associated TabHost.  It relies on a
 * trick.  Normally a tab host has a simple API for supplying a View or
 * Intent that each tab will show.  This is not sufficient for switching
 * between pages.  So instead we make the content part of the tab host
 * 0dp high (it is not shown) and the TabsAdapter supplies its own dummy
 * view to show as the tab content.  It listens to changes in tabs, and takes
 * care of switch to the correct paged in the ViewPager whenever the selected
 * tab changes.
 */
public class SwipeableActionBarTabsAdapter extends FragmentPagerAdapter
    implements ActionBar.TabListener, ViewPager.OnPageChangeListener {
  private final Context context;
  private final ActionBar actionBar;
  private final ViewPager viewPager;
  private final ArrayList<TabInfo> tabs = new ArrayList<TabInfo>();

  public SwipeableActionBarTabsAdapter(Activity activity, ViewPager pager) {
    super(activity.getFragmentManager());
    context = activity;
    actionBar = activity.getActionBar();
    viewPager = pager;
    viewPager.setAdapter(this);
    viewPager.setOnPageChangeListener(this);
  }

  public void addTab(ActionBar.Tab tab, Class<?> clss, Bundle args) {
    TabInfo info = new TabInfo(clss, args);
    tab.setTag(info);
    tab.setTabListener(this);
    tabs.add(info);
    actionBar.addTab(tab);
    notifyDataSetChanged();
  }

  @Override
  public int getCount() {
    return tabs.size();
  }

  @Override
  public Fragment getItem(int position) {
    TabInfo info = tabs.get(position);
    return Fragment.instantiate(context, info.clss.getName(), info.args);
  }

  @Override
  public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
  }

  @Override
  public void onPageSelected(int position) {
    actionBar.setSelectedNavigationItem(position);
  }

  @Override
  public void onPageScrollStateChanged(int state) {
  }

  @Override
  public void onTabSelected(ActionBar.Tab tab, FragmentTransaction ft) {
    Object tag = tab.getTag();
    for (int i = 0; i < tabs.size(); i++) {
      if (tabs.get(i) == tag) {
        viewPager.setCurrentItem(i);
      }
    }
  }

  @Override
  public void onTabUnselected(ActionBar.Tab tab, FragmentTransaction ft) {
  }

  @Override
  public void onTabReselected(ActionBar.Tab tab, FragmentTransaction ft) {
  }

  static final class TabInfo {
    private final Class<?> clss;
    private final Bundle args;

    TabInfo(Class<?> clss, Bundle args) {
      this.clss = clss;
      this.args = args;
    }
  }
}


