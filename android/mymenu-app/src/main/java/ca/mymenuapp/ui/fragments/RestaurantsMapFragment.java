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

import ca.mymenuapp.data.MyMenuDatabase;
import ca.mymenuapp.data.api.model.Restaurant;
import ca.mymenuapp.data.rx.EndlessObserver;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.LatLng;
import com.google.maps.android.clustering.ClusterItem;
import com.google.maps.android.clustering.ClusterManager;
import java.util.List;
import javax.inject.Inject;

public class RestaurantsMapFragment extends BaseMapFragment {

  @Inject MyMenuDatabase myMenuDatabase;

  private GoogleMap map;
  private ClusterManager<RestaurantClusterAdapter> clusterManager;

  @Override public void onStart() {
    super.onStart();

    map = getMap();
    map.setMyLocationEnabled(true);
    map.setIndoorEnabled(true);
    map.getUiSettings().setMyLocationButtonEnabled(true);
    map.getUiSettings().setAllGesturesEnabled(true);

    clusterManager = new ClusterManager<>(activityContext, map);

    myMenuDatabase.getAllRestaurants(new EndlessObserver<List<Restaurant>>() {
      @Override public void onNext(List<Restaurant> restaurants) {
        initMap(restaurants);
      }
    });
  }

  private void initMap(List<Restaurant> restaurants) {
    // Point the map's listeners at the listeners implemented by the cluster manager.
    getMap().setOnCameraChangeListener(clusterManager);
    getMap().setOnMarkerClickListener(clusterManager);

    for (Restaurant restaurant : restaurants) {
      clusterManager.addItem(new RestaurantClusterAdapter(restaurant));
    }
  }

  class RestaurantClusterAdapter implements ClusterItem {
    private final Restaurant restaurant;

    RestaurantClusterAdapter(Restaurant restaurant) {
      this.restaurant = restaurant;
    }

    @Override public LatLng getPosition() {
      return new LatLng(restaurant.lat, restaurant.lng);
    }
  }
}