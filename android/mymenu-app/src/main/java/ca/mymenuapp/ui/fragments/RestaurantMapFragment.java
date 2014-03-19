package ca.mymenuapp.ui.fragments;

import android.app.FragmentTransaction;
import android.content.Intent;
import android.location.Location;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import butterknife.InjectView;
import butterknife.OnClick;
import ca.mymenuapp.R;
import ca.mymenuapp.data.MyMenuDatabase;
import ca.mymenuapp.data.api.model.Restaurant;
import ca.mymenuapp.data.rx.EndlessObserver;
import ca.mymenuapp.ui.activities.RestaurantActivity;
import com.f2prateek.dart.InjectExtra;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;
import com.squareup.picasso.Picasso;
import javax.inject.Inject;

/**
 * Created by chrismoulds on 2014-03-19.
 */
public class RestaurantMapFragment extends BaseFragment {

  private GoogleMap googleMap;
  /**
   * Returns a new instance of this fragment for the map
   */
  public static RestaurantMapFragment newInstance() {
    return new RestaurantMapFragment();
  }
  public RestaurantMapFragment(){}

  @Override
  public View onCreateView(LayoutInflater inflater, ViewGroup container,
      Bundle savedInstanceState) {
    return inflater.inflate(R.layout.fragment_restaurant_map, container, false);
  }

  @Override
  public void onViewCreated(View view, Bundle savedInstanceState) {
    super.onViewCreated(view, savedInstanceState);
  }

  @Override public void onStart() {
    super.onStart();
    initializeMap();
  }

  private void initializeMap() {
    MapFragment firstFragment = new MapFragment();
    FragmentTransaction transaction = getChildFragmentManager().beginTransaction();
    transaction.add(R.id.map, firstFragment).commit();
    if (googleMap == null) {
      googleMap = firstFragment.getMap();
      // check if map is created successfully or not
      if (googleMap != null) {
        googleMap.setMyLocationEnabled(true);
        googleMap.addMarker(new MarkerOptions().position(new LatLng(53.5, -113.5)).title("test"));
      }
    }
  }
}
