/*
 * Copyright 2014 Prateek Srivastava (@f2prateek)
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

package ca.mymenuapp.ui.fragments;

import android.location.Location;
import ca.mymenuapp.data.api.model.Restaurant;
import ca.mymenuapp.ui.activities.MainActivity;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.LatLng;
import com.google.maps.android.clustering.ClusterManager;
import com.squareup.otto.Subscribe;
import hugo.weaving.DebugLog;
import java.util.ArrayList;
import javax.inject.Inject;
import pl.charmas.android.reactivelocation.ReactiveLocationProvider;
import rx.util.functions.Action1;

public class RestaurantsMapFragment extends BaseMapFragment
    implements ClusterManager.OnClusterItemClickListener<Restaurant> {

  @Inject ReactiveLocationProvider locationProvider;

  GoogleMap map;
  ClusterManager<Restaurant> clusterManager;

  @Override public void onStart() {
    super.onStart();

    map = getMap();

    map.setMyLocationEnabled(true);
    map.setIndoorEnabled(true);
    map.getUiSettings().setAllGesturesEnabled(true);

    locationProvider.getLastKnownLocation().subscribe(new Action1<Location>() {
      @Override
      public void call(Location location) {
        centerMap(location);
      }
    });
  }

  @Subscribe @DebugLog
  public void onRestaurantsAvailableEvent(MainActivity.OnRestaurantListAvailableEvent event) {
    initMap(event.restaurants);
  }

  private void initMap(ArrayList<Restaurant> restaurants) {
    // Point the map's listeners at the listeners implemented by the cluster manager.
    map.setOnCameraChangeListener(clusterManager);
    map.setOnMarkerClickListener(clusterManager);

    clusterManager = new ClusterManager<>(activityContext, map);
    clusterManager.addItems(restaurants);
    clusterManager.setOnClusterItemClickListener(this);
  }

  private void centerMap(Location location) {
    LatLng moveTo = new LatLng(location.getLatitude(), location.getLongitude());
    map.animateCamera(CameraUpdateFactory.newLatLngZoom(moveTo, 10));
  }

  @Override public boolean onClusterItemClick(Restaurant restaurant) {
    bus.post(new MainActivity.OnRestaurantClickEvent(restaurant));
    return false;
  }
}