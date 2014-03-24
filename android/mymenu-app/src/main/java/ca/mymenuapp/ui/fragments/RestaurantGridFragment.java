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
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.TextView;
import butterknife.ButterKnife;
import butterknife.InjectView;
import ca.mymenuapp.R;
import ca.mymenuapp.data.api.model.Restaurant;
import ca.mymenuapp.ui.activities.MainActivity;
import ca.mymenuapp.ui.misc.BindableListAdapter;
import ca.mymenuapp.ui.widgets.BetterViewAnimator;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.maps.model.LatLng;
import com.google.maps.android.SphericalUtil;
import com.squareup.otto.Subscribe;
import com.squareup.picasso.Picasso;
import java.util.List;
import javax.inject.Inject;
import pl.charmas.android.reactivelocation.ReactiveLocationProvider;
import rx.Subscription;
import rx.util.functions.Action1;

/**
 * Fragment to display restaurants in a grid.
 */
public class RestaurantGridFragment extends BaseFragment
    implements AdapterView.OnItemClickListener {

  @Inject Picasso picasso;
  @Inject ReactiveLocationProvider locationProvider;

  @InjectView(R.id.root) BetterViewAnimator root;
  @InjectView(R.id.restaurant_grid) GridView gridView;

  BaseAdapter adapter;
  Subscription locationSubscription;
  LocationRequest request = LocationRequest.create()
      .setPriority(LocationRequest.PRIORITY_BALANCED_POWER_ACCURACY)
      .setInterval(5000);
  LatLng lastLatLng;

  @Override
  public View onCreateView(LayoutInflater inflater, ViewGroup container,
      Bundle savedInstanceState) {
    return inflater.inflate(R.layout.fragment_restaurant_grid, container, false);
  }

  @Override
  public void onViewCreated(View view, Bundle savedInstanceState) {
    super.onViewCreated(view, savedInstanceState);
  }

  @Override
  public void onStart() {
    super.onStart();
    locationSubscription =
        locationProvider.getUpdatedLocation(request).subscribe(new Action1<Location>() {
          @Override
          public void call(Location location) {
            lastLatLng = new LatLng(location.getLatitude(), location.getLongitude());
          }
        });
  }

  @Override public void onStop() {
    super.onStop();
    locationSubscription.unsubscribe();
  }

  @Override
  public void onItemClick(AdapterView<?> adapterView, View view, int position, long id) {
    Restaurant restaurant = (Restaurant) adapterView.getAdapter().getItem(position);
    bus.post(new MainActivity.OnRestaurantClickEvent(restaurant));
  }

  @Subscribe
  public void onRestaurantsAvailableEvent(MainActivity.OnRestaurantListAvailableEvent event) {
    initGrid(event.restaurants);
  }

  private void initGrid(List<Restaurant> restaurants) {
    adapter = new RestaurantListAdapter(activityContext, restaurants);
    gridView.setAdapter(adapter);
    gridView.setOnItemClickListener(this);
    root.setDisplayedChildId(R.id.restaurant_grid);
  }

  class RestaurantListAdapter extends BindableListAdapter<Restaurant> {

    public RestaurantListAdapter(Context context, List<Restaurant> restaurants) {
      super(context, restaurants);
    }

    @Override
    public long getItemId(int position) {
      return getItem(position).id;
    }

    @Override
    public View newView(LayoutInflater inflater, int position, ViewGroup container) {
      View view = inflater.inflate(R.layout.adapter_restaurant_grid, container, false);
      ViewHolder holder = new ViewHolder(view);
      view.setTag(holder);
      return view;
    }

    @Override
    public void bindView(Restaurant item, int position, View view) {
      ViewHolder holder = (ViewHolder) view.getTag();

      RestaurantGridFragment.this.picasso.load(item.businessPicture)
          .placeholder(R.drawable.ic_launcher)
          .fit()
          .centerCrop()
          .into(holder.picture);
      holder.label.setText(item.businessName);
      holder.rating.setText(String.format("%.1f", item.rating));
      holder.address.setText(item.address);
      holder.cuisine.setText(item.category);

      double distance; // in metres
      if (lastLatLng != null) {
        distance = SphericalUtil.computeDistanceBetween(lastLatLng, item.getPosition());
      } else {
        distance = Double.parseDouble(item.distance) * 1000; // convert to metres
      }

      if (distance < 1000) {
        // show it in metres
        holder.distance.setText(getString(R.string.metres, distance));
      } else {
        // show it in km
        distance /= 1000;
        holder.distance.setText(getString(R.string.kilometres, distance));
      }
    }

    class ViewHolder {
      @InjectView(R.id.rest_image) ImageView picture;
      @InjectView(R.id.rest_name) TextView label;
      @InjectView(R.id.rest_rating) TextView rating;
      @InjectView(R.id.rest_cuisine) TextView cuisine;
      @InjectView(R.id.rest_address) TextView address;
      @InjectView(R.id.rest_distance) TextView distance;

      ViewHolder(View root) {
        ButterKnife.inject(this, root);
      }
    }
  }
}
