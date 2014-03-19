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
import android.content.IntentSender;
import android.content.res.Configuration;
import android.location.Location;
import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.Menu;
import android.view.MenuItem;
import butterknife.InjectView;
import ca.mymenuapp.R;
import ca.mymenuapp.data.api.model.User;
import ca.mymenuapp.data.prefs.ObjectPreference;
import ca.mymenuapp.ui.fragments.DietaryPreferencesFragment;
import ca.mymenuapp.ui.fragments.PlaceholderFragment;
import ca.mymenuapp.ui.fragments.RestaurantListFragment;
import ca.mymenuapp.ui.fragments.RestaurantMapFragment;
import ca.mymenuapp.ui.fragments.RestaurantTwoPaneFragment;
import ca.mymenuapp.ui.widgets.SwipeableActionBarTabsAdapter;
import ca.mymenuapp.util.Bundler;
import com.f2prateek.ln.Ln;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesClient;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.location.LocationClient;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;
import javax.inject.Inject;
import javax.inject.Named;

import static ca.mymenuapp.data.DataModule.USER_LOCATION;
import static ca.mymenuapp.data.DataModule.USER_PREFERENCE;

/** The top level activity that is shown first to the user. */
public class MainActivity extends BaseActivity
    implements GooglePlayServicesClient.ConnectionCallbacks,
    GooglePlayServicesClient.OnConnectionFailedListener {

  @Inject @Named(USER_PREFERENCE) ObjectPreference<User> userPreference;
  @Inject @Named(USER_LOCATION) ObjectPreference<Location> userLoc;

  @InjectView(R.id.pager) ViewPager viewPager;


  private LocationClient locClient;
  private int lastTab;

  private SwipeableActionBarTabsAdapter tabsAdapter;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    inflateView(R.layout.activity_main);

    if(savedInstanceState != null){
      lastTab = savedInstanceState.getInt("tab", 0);
    }
    else{
      lastTab = 0;
    }
    initializeGooglePlay();

    //setupTabs(savedInstanceState != null ? savedInstanceState.getInt("tab", 0) : 0);
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
      tabsAdapter.addTab(actionBar.newTab().setText("Restaurants"), RestaurantListFragment.class,
          null);
      tabsAdapter.addTab(actionBar.newTab().setText("Map"), RestaurantMapFragment.class, null);
    }

    tabsAdapter.addTab(actionBar.newTab().setText("Restaurant"), PlaceholderFragment.class,
        new Bundler().put(PlaceholderFragment.ARG_SECTION_NUMBER, 1).get());
    tabsAdapter.addTab(actionBar.newTab().setText("Preferences"), DietaryPreferencesFragment.class,
        null);

    actionBar.setSelectedNavigationItem(tab);
  }

  public void initializeGooglePlay() {

    int resultCode = GooglePlayServicesUtil.isGooglePlayServicesAvailable(this);

    if (ConnectionResult.SUCCESS == resultCode) {
      locClient = new LocationClient(this, this, this);
      locClient.connect();
    } else {
      Ln.e("Cant connect to GooglePlay");
    }
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

  @Override public void onConnected(Bundle bundle) {
    userLoc.set(locClient.getLastLocation());
    userLoc.save();
    setupTabs(lastTab);
  }

  @Override public void onDisconnected() {
  }

  @Override public void onConnectionFailed(ConnectionResult connectionResult) {
    if (connectionResult.hasResolution()) {
      try {
        connectionResult.startResolutionForResult(this, 9000);
      } catch (IntentSender.SendIntentException e) {
        e.printStackTrace();
      }
    } else {
      showErrorDialog(connectionResult.getErrorCode());
    }
  }

  private void showErrorDialog(int errorCode) {
    Ln.e("Error Code:" + errorCode);
  }

}