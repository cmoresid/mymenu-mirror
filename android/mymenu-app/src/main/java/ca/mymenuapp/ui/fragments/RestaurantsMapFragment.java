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
import ca.mymenuapp.R;
import ca.mymenuapp.data.api.model.Restaurant;
import ca.mymenuapp.ui.activities.MainActivity;
import ca.mymenuapp.util.CollectionUtils;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.maps.android.clustering.ClusterManager;
import com.google.maps.android.clustering.view.DefaultClusterRenderer;
import com.squareup.otto.Subscribe;
import java.util.List;
import javax.inject.Inject;
import pl.charmas.android.reactivelocation.ReactiveLocationProvider;
import rx.util.functions.Action1;

public class RestaurantsMapFragment extends BaseMapFragment
    implements ClusterManager.OnClusterItemClickListener<Restaurant> {

  @Inject ReactiveLocationProvider locationProvider;

  ClusterManager<Restaurant> clusterManager;

  @Override public void onStart() {
    super.onStart();

    getMap().setMyLocationEnabled(true);
    getMap().setIndoorEnabled(true);
    getMap().getUiSettings().setAllGesturesEnabled(true);

    locationProvider.getLastKnownLocation().subscribe(new Action1<Location>() {
      @Override
      public void call(Location location) {
        centerMap(location);
      }
    });
  }

  @Subscribe
  public void onRestaurantsAvailableEvent(MainActivity.OnRestaurantListAvailableEvent event) {
    initMap(event.restaurants);
  }

  private void initMap(List<Restaurant> restaurants) {
    if (!CollectionUtils.isNullOrEmpty(restaurants)) {
      if (clusterManager != null) {
        clusterManager.clearItems();
      } else {
        clusterManager = new ClusterManager<>(activityContext, getMap());
        // Point the map's listeners at the listeners implemented by the cluster manager.
        getMap().setOnCameraChangeListener(clusterManager);
        getMap().setOnMarkerClickListener(clusterManager);
        clusterManager.setOnClusterItemClickListener(this);
        clusterManager.setRenderer(new RestaurantRenderer());
      }

      clusterManager.addItems(restaurants);
      clusterManager.cluster();
    }
  }

  private void centerMap(Location location) {
    LatLng moveTo = new LatLng(location.getLatitude(), location.getLongitude());
    getMap().animateCamera(CameraUpdateFactory.newLatLngZoom(moveTo, 10));
  }

  @Override public boolean onClusterItemClick(Restaurant restaurant) {
    bus.post(new MainActivity.OnRestaurantClickEvent(restaurant));
    return false;
  }

  /**
   * Draws profile photos inside markers (using IconGenerator).
   * When there are multiple people in the cluster, draw multiple photos (using MultiDrawable).
   */
  private class RestaurantRenderer extends DefaultClusterRenderer<Restaurant> {

    public RestaurantRenderer() {
      super(activityContext, getMap(), clusterManager);
    }

    @Override
    protected void onBeforeClusterItemRendered(Restaurant r, MarkerOptions markerOptions) {
      markerOptions.icon(BitmapDescriptorFactory.fromResource(R.drawable.locationmarker));
    }
  }
}