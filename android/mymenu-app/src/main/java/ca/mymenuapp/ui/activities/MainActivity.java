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
import android.app.FragmentTransaction;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.Toast;
import butterknife.InjectView;
import ca.mymenuapp.R;
import ca.mymenuapp.data.api.model.User;
import ca.mymenuapp.data.prefs.ObjectPreference;
import ca.mymenuapp.ui.fragments.DietaryPreferencesFragment;
import ca.mymenuapp.ui.fragments.PlaceholderFragment;
import ca.mymenuapp.ui.fragments.RestaurantListFragment;
import ca.mymenuapp.ui.fragments.RestaurantTwoPaneFragment;
import ca.mymenuapp.ui.widgets.SwipeableActionBarTabsAdapter;
import ca.mymenuapp.util.Bundler;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapFragment;
import javax.inject.Inject;
import javax.inject.Named;

import static ca.mymenuapp.data.DataModule.USER_PREFERENCE;

/** The top level activity that is shown first to the user. */
public class MainActivity extends BaseActivity {

  @Inject @Named(USER_PREFERENCE) ObjectPreference<User> userPreference;
  @InjectView(R.id.pager) ViewPager viewPager;


  private SwipeableActionBarTabsAdapter tabsAdapter;



  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    inflateView(R.layout.activity_main);
    setupTabs(savedInstanceState != null ? savedInstanceState.getInt("tab", 0) : 0);
  }

  /** Setup the tabs two display our fragments. */
  private void setupTabs(int tab) {
    ActionBar actionBar = getActionBar();
    actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);

    tabsAdapter = new SwipeableActionBarTabsAdapter(this, viewPager);
      /* Need to check size here */
    if ((getResources().getConfiguration().screenLayout & Configuration.SCREENLAYOUT_SIZE_MASK)
        == Configuration.SCREENLAYOUT_SIZE_LARGE) {
      tabsAdapter.addTab(actionBar.newTab().setText("Restaurants"), RestaurantTwoPaneFragment.class,
          null);
        /*Large device, should have restaurant list and map view on one page."*/
    } else {
      tabsAdapter.addTab(actionBar.newTab().setText("Restaurants"), RestaurantTwoPaneFragment.class,
          null);
    }

    tabsAdapter.addTab(actionBar.newTab().setText("Restaurant"), PlaceholderFragment.class,
        new Bundler().put(PlaceholderFragment.ARG_SECTION_NUMBER, 1).get());
    tabsAdapter.addTab(actionBar.newTab().setText("Preferences"), DietaryPreferencesFragment.class,
        null);



    //initializeMap();
    actionBar.setSelectedNavigationItem(tab);
  }



  @Override public boolean onCreateOptionsMenu(Menu menu) {
    getMenuInflater().inflate(R.menu.activity_main, menu);
    return true;
  }

  @Override public boolean onOptionsItemSelected(MenuItem item) {
    switch (item.getItemId()) {
      case R.id.logout:
        userPreference.delete();
        Intent intent = new Intent(this, LoginActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        startActivity(intent);
        finish();
        return true;
      default:
        return super.onOptionsItemSelected(item);
    }
  }
}
