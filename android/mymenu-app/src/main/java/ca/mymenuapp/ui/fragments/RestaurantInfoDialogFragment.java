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

import android.app.DialogFragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import butterknife.ButterKnife;
import butterknife.InjectView;
import ca.mymenuapp.MyMenuApp;
import ca.mymenuapp.R;
import ca.mymenuapp.data.api.model.Restaurant;
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
    ((MyMenuApp) getActivity().getApplication()).getApplicationGraph().inject(this);
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

    getDialog().setTitle(restaurant.businessName);
    description.setText(restaurant.businessDescription);
    address.setText(restaurant.address);
    hours.setText(
        getString(R.string.restaurant_address_hours, restaurant.getTime(restaurant.openTime),
            restaurant.getTime(restaurant.closeTime), restaurant.address)
    );
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