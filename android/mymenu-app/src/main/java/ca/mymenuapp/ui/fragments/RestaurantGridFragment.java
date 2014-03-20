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
import com.squareup.otto.Subscribe;
import com.squareup.picasso.Picasso;
import hugo.weaving.DebugLog;
import java.util.ArrayList;
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
  Location lastKnownLocation;

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
            lastKnownLocation = location;
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

  @Subscribe @DebugLog
  public void onRestaurantsAvailableEvent(MainActivity.OnRestaurantListAvailableEvent event) {
    initGrid(event.restaurants);
  }

  private void initGrid(ArrayList<Restaurant> restaurants) {
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
      holder.name.setText(item.businessName);
      holder.address.setText(item.address);
    }

    class ViewHolder {
      @InjectView(R.id.restaurant_picture) ImageView picture;
      @InjectView(R.id.restaurant_name) TextView name;
      @InjectView(R.id.restaurant_address) TextView address;

      ViewHolder(View root) {
        ButterKnife.inject(this, root);
      }
    }
  }
}
