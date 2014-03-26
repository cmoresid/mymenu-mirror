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
import android.app.SearchManager;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.location.Location;
import android.os.Bundle;
import android.support.v4.app.ActionBarDrawerToggle;
import android.support.v4.view.ViewPager;
import android.support.v4.widget.DrawerLayout;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.SearchView;
import butterknife.InjectView;
import ca.mymenuapp.R;
import ca.mymenuapp.data.MyMenuDatabase;
import ca.mymenuapp.data.api.model.Restaurant;
import ca.mymenuapp.data.api.model.User;
import ca.mymenuapp.data.prefs.ObjectPreference;
import ca.mymenuapp.data.rx.EndlessObserver;
import ca.mymenuapp.ui.fragments.DietaryPreferencesFragment;
import ca.mymenuapp.ui.fragments.RestaurantGridFragment;
import ca.mymenuapp.ui.fragments.RestaurantsMapFragment;
import ca.mymenuapp.ui.fragments.SettingsFragment;
import ca.mymenuapp.ui.widgets.SwipeableActionBarTabsAdapter;
import com.f2prateek.ln.Ln;
import com.squareup.otto.Produce;
import com.squareup.otto.Subscribe;
import java.util.Collections;
import java.util.List;
import javax.inject.Inject;
import javax.inject.Named;
import pl.charmas.android.reactivelocation.ReactiveLocationProvider;
import rx.Observable;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;
import rx.util.functions.Action1;
import rx.util.functions.Func1;

import static ca.mymenuapp.data.DataModule.USER_PREFERENCE;

/**
 * The top level activity that is shown first to the user.
 */
public class MainActivity extends BaseActivity {

  @Inject @Named(USER_PREFERENCE) ObjectPreference<User> userPreference;
  @Inject MyMenuDatabase myMenuDatabase;
  @Inject ReactiveLocationProvider locationProvider;

  @InjectView(R.id.pager) ViewPager viewPager;
  @InjectView(R.id.drawer_layout) DrawerLayout drawerLayout;
  @InjectView(R.id.restaraunt_grid_container) FrameLayout restaurantGridContainer;

  ActionBarDrawerToggle drawerToggle;
  List<Restaurant> restaurants = Collections.emptyList();

  @Override
  protected void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    inflateView(R.layout.activity_main);

    locationProvider.getLastKnownLocation().subscribe(new Action1<Location>() {
      @Override
      public void call(Location location) {
        myMenuDatabase.getNearbyRestaurants(location.getLatitude(), location.getLongitude(),
            new EndlessObserver<List<Restaurant>>() {
              @Override public void onNext(List<Restaurant> restaurantList) {
                restaurants = restaurantList;
                bus.post(new OnRestaurantListAvailableEvent(restaurantList));
              }
            }
        );
      }
    });

    setupTabs(savedInstanceState != null ? savedInstanceState.getInt("tab", 0) : 0);
    if (savedInstanceState == null) {
      getFragmentManager().beginTransaction()
          .add(R.id.restaraunt_grid_container, new RestaurantGridFragment())
          .commit();
    }

    // start drawer in open state
    drawerLayout.openDrawer(restaurantGridContainer);

    // allow user to toggle drawer with the action bar
    drawerToggle =
        new ActionBarDrawerToggle(this, drawerLayout, R.drawable.ic_drawer, R.string.drawer_open,
            R.string.drawer_close) {

          @Override public void onDrawerOpened(View drawerView) {
            super.onDrawerOpened(drawerView);
            invalidateOptionsMenu(); // creates call to onPrepareOptionsMenu()
          }

          @Override public void onDrawerClosed(View drawerView) {
            super.onDrawerClosed(drawerView);
            invalidateOptionsMenu(); // creates call to onPrepareOptionsMenu()
          }
        };
    drawerLayout.setDrawerListener(drawerToggle);
    getActionBar().setDisplayHomeAsUpEnabled(true);
    getActionBar().setHomeButtonEnabled(true);
  }

  /** Setup the tabs to display our fragments. */
  private void setupTabs(int tab) {
    final ActionBar actionBar = getActionBar();
    actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);
    SwipeableActionBarTabsAdapter tabsAdapter = new SwipeableActionBarTabsAdapter(this, viewPager);
    tabsAdapter.addTab(actionBar.newTab().setText(getString(R.string.map)),
        RestaurantsMapFragment.class, null);
    tabsAdapter.addTab(actionBar.newTab().setText(getString(R.string.dietary_preferences)),
        DietaryPreferencesFragment.class, null);
    tabsAdapter.addTab(actionBar.newTab().setText(getString(R.string.settings)),
        SettingsFragment.class, null);
    actionBar.setSelectedNavigationItem(tab);

    viewPager.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
      @Override public void onPageScrolled(int position, float positionOffset,
          int positionOffsetPixels) {
        if (position == 0) {
          // Enable user to slide the drawer layout
          drawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_UNLOCKED);
          drawerToggle.setDrawerIndicatorEnabled(true);
          getActionBar().setDisplayHomeAsUpEnabled(true);
          getActionBar().setHomeButtonEnabled(true);
        } else {
          // Disable user from sliding the drawer layout
          drawerLayout.setDrawerLockMode(DrawerLayout.LOCK_MODE_LOCKED_CLOSED);
          drawerToggle.setDrawerIndicatorEnabled(false);
          getActionBar().setDisplayHomeAsUpEnabled(false);
          getActionBar().setHomeButtonEnabled(false);
        }
      }

      @Override public void onPageSelected(int position) {
        // ignore
      }

      @Override public void onPageScrollStateChanged(int state) {
        // ignore
      }
    });
  }

  @Override
  protected void onPostCreate(Bundle savedInstanceState) {
    super.onPostCreate(savedInstanceState);
    // Sync the toggle state after onRestoreInstanceState has occurred.
    drawerToggle.syncState();
  }

  @Override
  public void onConfigurationChanged(Configuration newConfig) {
    super.onConfigurationChanged(newConfig);
    drawerToggle.onConfigurationChanged(newConfig);
  }

  @Subscribe public void onRestaurantClicked(OnRestaurantClickEvent event) {
    Intent intent = new Intent(this, RestaurantActivity.class);
    intent.putExtra(RestaurantActivity.ARGS_RESTAURANT_ID, event.restaurant.id);
    startActivity(intent);
  }

  @Override
  protected void onSaveInstanceState(Bundle outState) {
    super.onSaveInstanceState(outState);
    outState.putInt("tab", getActionBar().getSelectedNavigationIndex());
  }

  @Override public boolean onCreateOptionsMenu(Menu menu) {
    getMenuInflater().inflate(R.menu.activity_main, menu);

    // Associate searchable configuration with the SearchView
    SearchManager searchManager = (SearchManager) getSystemService(Context.SEARCH_SERVICE);
    MenuItem searchMenuItem = menu.findItem(R.id.search);
    SearchView searchView = (SearchView) searchMenuItem.getActionView();
    searchView.setSearchableInfo(searchManager.getSearchableInfo(getComponentName()));
    searchMenuItem.setOnActionExpandListener(new MenuItem.OnActionExpandListener() {
      @Override public boolean onMenuItemActionExpand(MenuItem item) {
        return true;
      }

      @Override public boolean onMenuItemActionCollapse(MenuItem item) {
        bus.post(new OnRestaurantListAvailableEvent(restaurants));
        return true;
      }
    });

    return true;
  }

  @Override public boolean onOptionsItemSelected(MenuItem item) {
    // Pass the event to ActionBarDrawerToggle, if it returns
    // true, then it has handled the app icon touch event
    if (drawerToggle.onOptionsItemSelected(item)) {
      return true;
    }
    // Handle other action bar items...
    switch (item.getItemId()) {
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

  @Override
  protected void onNewIntent(Intent intent) {
    handleIntent(intent);
  }

  private void handleIntent(Intent intent) {
    if (Intent.ACTION_SEARCH.equals(intent.getAction())) {
      final String query = intent.getStringExtra(SearchManager.QUERY);
      Ln.d(query);
      // Filter ones in memory quickly
      Observable.from(restaurants)
          .filter(new Func1<Restaurant, Boolean>() {
            @Override public Boolean call(Restaurant restaurant) {
              return restaurant.businessName.toLowerCase().contains(query.toLowerCase());
            }
          })
          .toList()
          .subscribeOn(Schedulers.computation())
          .observeOn(AndroidSchedulers.mainThread())
          .subscribe(new EndlessObserver<List<Restaurant>>() {
            @Override public void onNext(List<Restaurant> restaurantList) {
              bus.post(new OnRestaurantListAvailableEvent(restaurantList));
              // filtered ones in memory, now fetch a search from the network and notify any
              // observers
              // todo: show a progress bar in the action bar
            }
          });
    }
  }

  public static class OnRestaurantClickEvent {
    public final Restaurant restaurant;

    public OnRestaurantClickEvent(Restaurant restaurant) {
      this.restaurant = restaurant;
    }
  }

  public static class OnRestaurantListAvailableEvent {
    public final List<Restaurant> restaurants;

    public OnRestaurantListAvailableEvent(List<Restaurant> restaurants) {
      this.restaurants = restaurants;
    }
  }

  @Produce public OnRestaurantListAvailableEvent produceRestaurants() {
    Ln.d("Producing %d restaurants.", restaurants.size());
    return new OnRestaurantListAvailableEvent(restaurants);
  }
}
