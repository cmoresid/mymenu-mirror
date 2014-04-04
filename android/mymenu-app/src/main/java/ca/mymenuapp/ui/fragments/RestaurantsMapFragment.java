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

package ca.mymenuapp.ui.fragments;

import android.content.Context;
import android.location.Location;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import butterknife.ButterKnife;
import butterknife.InjectView;
import ca.mymenuapp.R;
import ca.mymenuapp.data.api.model.Restaurant;
import ca.mymenuapp.ui.activities.MainActivity;
import ca.mymenuapp.util.CollectionUtils;
import com.f2prateek.ln.Ln;
import com.google.android.gms.maps.CameraUpdateFactory;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.Marker;
import com.google.android.gms.maps.model.MarkerOptions;
import com.google.maps.android.clustering.ClusterManager;
import com.google.maps.android.clustering.view.DefaultClusterRenderer;
import com.squareup.otto.Subscribe;
import com.squareup.picasso.Callback;
import com.squareup.picasso.Picasso;
import java.util.List;
import javax.inject.Inject;
import pl.charmas.android.reactivelocation.ReactiveLocationProvider;
import rx.util.functions.Action1;

public class RestaurantsMapFragment extends BaseMapFragment
    implements ClusterManager.OnClusterItemClickListener<Restaurant> {

  @Inject ReactiveLocationProvider locationProvider;
  @Inject Picasso picasso;

  ClusterManager<Restaurant> clusterManager;
  private Restaurant selectedRestaurant;

  @Override public void onStart() {
    super.onStart();
    getMap().setMyLocationEnabled(true);
    getMap().setIndoorEnabled(true);
    getMap().getUiSettings().setAllGesturesEnabled(true);
    getMap().setOnInfoWindowClickListener(new GoogleMap.OnInfoWindowClickListener() {
      @Override
      public void onInfoWindowClick(Marker marker) {
        bus.post(new MainActivity.OnRestaurantClickEvent(selectedRestaurant));
      }
    });

    locationProvider.getLastKnownLocation().

        subscribe(new Action1<Location>() {
                    @Override public void call(Location location) {
                      centerMap(location);
                    }
                  }
        );
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
        /* Custom info window adapter */
        getMap().setInfoWindowAdapter(clusterManager.getMarkerManager());
        clusterManager.getClusterMarkerCollection()
            .setOnInfoWindowAdapter(new CustomInfoAdapter(activityContext));
        clusterManager.getMarkerCollection()
            .setOnInfoWindowAdapter(new CustomInfoAdapter(activityContext));
        /* Renderer for custom icons */
        clusterManager.setRenderer(
            new RestaurantRenderer(activityContext, getMap(), clusterManager));
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
    this.selectedRestaurant = restaurant;
    return false;
  }

  /**
   * Changes the marker icon.
   */
  static class RestaurantRenderer extends DefaultClusterRenderer<Restaurant> {

    public RestaurantRenderer(Context activityContext, GoogleMap googleMap, ClusterManager cM) {
      super(activityContext, googleMap, cM);
    }

    @Override
    protected void onBeforeClusterItemRendered(Restaurant r, MarkerOptions markerOptions) {
      markerOptions.icon(BitmapDescriptorFactory.fromResource(R.drawable.locationmarker));
    }
  }

  /*
   * Provides an adapter to show custom info windows when you click a marker.
   */
  class CustomInfoAdapter implements GoogleMap.InfoWindowAdapter {
    private final LayoutInflater inflater;

    CustomInfoAdapter(Context activityContext) {
      inflater = LayoutInflater.from(activityContext);
    }

    @Override
    public View getInfoContents(Marker marker) {
      return null;
    }

    @Override public View getInfoWindow(final Marker marker) {
      final View view = inflater.inflate(R.layout.custom_info_window, null);
      ViewHolder viewHolder = new ViewHolder(view);
      viewHolder.phone.setText(selectedRestaurant.businessNumber);
      viewHolder.title.setText(selectedRestaurant.businessName);
      viewHolder.time.setText(selectedRestaurant.getTime(selectedRestaurant.openTime)
          + "-"
          + selectedRestaurant.getTime(selectedRestaurant.closeTime));
      picasso.load(selectedRestaurant.businessPicture).into(viewHolder.restImgView, new Callback() {
        @Override public void onSuccess() {
          if (marker != null && marker.isInfoWindowShown()) {
            marker.hideInfoWindow();
            marker.showInfoWindow();
          }
        }

        @Override public void onError() {
          Ln.e("Failed loading");
        }
      });
      return view;
    }

    class ViewHolder {
      @InjectView(R.id.info_rest_image) ImageView restImgView;
      @InjectView(R.id.info_time) TextView time;
      @InjectView(R.id.info_rest_phone) TextView phone;
      @InjectView(R.id.info_rest_title) TextView title;

      ViewHolder(View root) {
        ButterKnife.inject(this, root);
      }
    }
  }
}