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

package ca.mymenuapp.ui.activities;

import android.app.ActionBar;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import butterknife.InjectView;
import ca.mymenuapp.R;
import ca.mymenuapp.ui.fragments.PlaceholderFragment;
import ca.mymenuapp.ui.widgets.SwipeableActionBarTabsAdapter;
import ca.mymenuapp.util.Bundler;

/** The top level activity that is shown first to the user. */
public class MainActivity extends BaseActivity {

  @InjectView(R.id.pager) ViewPager viewPager;

  private SwipeableActionBarTabsAdapter tabsAdapter;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.activity_main);
    setupTabs(savedInstanceState != null ? savedInstanceState.getInt("tab", 0) : 0);
  }

  /** Setup the tabs two display our fragments. */
  private void setupTabs(int tab) {
    ActionBar actionBar = getActionBar();
    actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);

    tabsAdapter = new SwipeableActionBarTabsAdapter(this, viewPager);
    tabsAdapter.addTab(actionBar.newTab().setText("0"), PlaceholderFragment.class,
        new Bundler().put(PlaceholderFragment.ARG_SECTION_NUMBER, 0).get());
    tabsAdapter.addTab(actionBar.newTab().setText("1"), PlaceholderFragment.class,
        new Bundler().put(PlaceholderFragment.ARG_SECTION_NUMBER, 1).get());
    tabsAdapter.addTab(actionBar.newTab().setText("2"), PlaceholderFragment.class,
        new Bundler().put(PlaceholderFragment.ARG_SECTION_NUMBER, 2).get());
    actionBar.setSelectedNavigationItem(tab);
  }

  @Override
  public boolean onCreateOptionsMenu(Menu menu) {
    MenuInflater inflater = getMenuInflater();
    inflater.inflate(R.menu.main_activity, menu);
    return true;
  }

  @Override public boolean onOptionsItemSelected(MenuItem item) {
    switch (item.getItemId()) {
      case R.id.action_settings:
        return true;
      default:
        return super.onOptionsItemSelected(item);
    }
  }
}
