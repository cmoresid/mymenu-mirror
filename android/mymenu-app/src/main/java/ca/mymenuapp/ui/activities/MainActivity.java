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
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.Menu;
import android.view.MenuItem;
import butterknife.InjectView;
import butterknife.Optional;
import ca.mymenuapp.R;
import ca.mymenuapp.data.api.model.Restaurant;
import ca.mymenuapp.data.api.model.User;
import ca.mymenuapp.data.prefs.ObjectPreference;
import ca.mymenuapp.ui.fragments.RestaurantGridFragment;
import ca.mymenuapp.ui.fragments.RestaurantsMapFragment;
import ca.mymenuapp.ui.widgets.SwipeableActionBarTabsAdapter;
import com.squareup.otto.Subscribe;
import javax.inject.Inject;
import javax.inject.Named;

import static ca.mymenuapp.data.DataModule.USER_PREFERENCE;

/** The top level activity that is shown first to the user. */
public class MainActivity extends BaseActivity {

  @Inject @Named(USER_PREFERENCE) ObjectPreference<User> userPreference;
  @InjectView(R.id.pager) @Optional ViewPager viewPager;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    inflateView(R.layout.activity_main);

    if (savedInstanceState == null) {
      if (viewPager != null) {
        // we're on a phone
        setupTabs(savedInstanceState != null ? savedInstanceState.getInt("tab", 0) : 0);
      } else {
        // we're on a tablet layout
        setupPanes();
      }
    }
  }

  /** Setup the tabs to display our fragments. */
  private void setupTabs(int tab) {
    ActionBar actionBar = getActionBar();
    actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);
    SwipeableActionBarTabsAdapter tabsAdapter = new SwipeableActionBarTabsAdapter(this, viewPager);
    tabsAdapter.addTab(actionBar.newTab().setText(getString(R.string.restaurants)),
        RestaurantGridFragment.class, null);
    tabsAdapter.addTab(actionBar.newTab().setText(getString(R.string.map)),
        RestaurantsMapFragment.class, null);
    actionBar.setSelectedNavigationItem(tab);
  }

  /** Setup the panes to display our fragments. */
  private void setupPanes() {
    FragmentTransaction transaction = getFragmentManager().beginTransaction();
    transaction.add(R.id.restaurant_list_container, new RestaurantGridFragment());
    transaction.add(R.id.restaurant_map_container, new RestaurantsMapFragment());
    transaction.commit();
  }

  @Subscribe public void onRestaurantClicked(OnRestaurantClickEvent event) {
    Intent intent = new Intent(this, RestaurantActivity.class);
    intent.putExtra(RestaurantActivity.ARGS_RESTAURANT_ID, event.restaurant.id);
    startActivity(intent);
  }

  @Override
  protected void onSaveInstanceState(Bundle outState) {
    super.onSaveInstanceState(outState);
    if (viewPager != null) {
      outState.putInt("tab", getActionBar().getSelectedNavigationIndex());
    }
  }

  @Override public boolean onCreateOptionsMenu(Menu menu) {
    getMenuInflater().inflate(R.menu.activity_main, menu);
    return true;
  }

  @Override public boolean onOptionsItemSelected(MenuItem item) {
    switch (item.getItemId()) {
      case R.id.dietary_preferences:
        Intent dietaryPreferencesIntent = new Intent(this, DietaryPreferencesActivity.class);
        startActivity(dietaryPreferencesIntent);
        return true;
      case R.id.logout:
        userPreference.delete();
        Intent loginIntent = new Intent(this, LoginActivity.class);
        loginIntent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        startActivity(loginIntent);
        finish();
        return true;
      default:
        return super.onOptionsItemSelected(item);
    }
  }

  public static class OnRestaurantClickEvent {
    public final Restaurant restaurant;

    public OnRestaurantClickEvent(Restaurant restaurant) {
      this.restaurant = restaurant;
    }
  }
}
