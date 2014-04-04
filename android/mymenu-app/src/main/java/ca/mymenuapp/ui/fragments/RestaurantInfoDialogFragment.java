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

import android.app.DialogFragment;
import android.os.Bundle;
import android.text.util.Linkify;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import butterknife.ButterKnife;
import butterknife.InjectView;
import ca.mymenuapp.R;
import ca.mymenuapp.data.api.model.Restaurant;
import ca.mymenuapp.ui.activities.BaseActivity;
import com.f2prateek.dart.Dart;
import com.f2prateek.dart.InjectExtra;
import com.squareup.picasso.Picasso;
import javax.inject.Inject;

public class RestaurantInfoDialogFragment extends DialogFragment {

  private static final String ARGS_RESTAURANT = "restaurant";

  @InjectExtra(ARGS_RESTAURANT) Restaurant restaurant;

  @Inject Picasso picasso;

  @InjectView(R.id.restaurant_info_description) TextView description;
  @InjectView(R.id.restaurant_info_address) TextView address;
  @InjectView(R.id.restaurant_info_map) ImageView map;
  @InjectView(R.id.restaurant_info_hours) TextView hours;
  @InjectView(R.id.restaurant_info_number) TextView number;
  @InjectView(R.id.restaurant_info_avg_rating) TextView rating;

  public static RestaurantInfoDialogFragment newInstance(Restaurant restaurant) {
    RestaurantInfoDialogFragment f = new RestaurantInfoDialogFragment();
    Bundle args = new Bundle();
    args.putParcelable(ARGS_RESTAURANT, restaurant);
    f.setArguments(args);
    f.setRetainInstance(true);
    return f;
  }

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setStyle(STYLE_NO_TITLE, getTheme());
    Dart.inject(this);
    ((BaseActivity) getActivity()).getActivityGraph().inject(this);
  }

  @Override
  public View onCreateView(LayoutInflater inflater, ViewGroup container,
      Bundle savedInstanceState) {
    return inflater.inflate(R.layout.fragment_restaurant_info_dialog, container, false);
  }

  @Override public void onViewCreated(View view, Bundle savedInstanceState) {
    super.onViewCreated(view, savedInstanceState);
    ButterKnife.inject(this, view);
  }

  @Override public void onStart() {
    super.onStart();

    // getDialog().setTitle(restaurant.businessName);
    description.setText(restaurant.businessDescription);
    address.setText(restaurant.address);
    hours.setText(
        getString(R.string.restaurant_address_hours, restaurant.getTime(restaurant.openTime),
            restaurant.getTime(restaurant.closeTime))
    );
    number.setText(getString(R.string.restaurant_phone, restaurant.businessNumber));
    Linkify.addLinks(number, Linkify.PHONE_NUMBERS);
    rating.setText(String.valueOf(restaurant.rating / Double.parseDouble(restaurant.ratingCount)));
    picasso.load(buildMapUrl(restaurant.lat, restaurant.lng)).fit().centerInside().into(map);
  }

  private String buildMapUrl(double lat, double lng) {
    return "http://maps.googleapis.com/maps/api/staticmap?"
        + "markers=color:0x46c8af%7c"
        + lat
        + ","
        + lng
        + "&"
        + "size=1024x1024&"
        + "zoom=13&"
        + "key=AIzaSyB5rAy1gQWGYOWm_zf8drIzaqVISMTn75o";
  }
}