package ca.mymenuapp.ui.fragments;

import android.app.FragmentTransaction;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;
import ca.mymenuapp.R;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapFragment;

public class RestaurantTwoPaneFragment extends BaseFragment {

  private GoogleMap googleMap;

  public static RestaurantTwoPaneFragment newInstance() {
    return new RestaurantTwoPaneFragment();
  }
  @Override
  public View onCreateView(LayoutInflater inflater, ViewGroup container,
      Bundle savedInstanceState) {

    RestaurantListFragment firstFragment = new RestaurantListFragment();
    FragmentTransaction transaction = getChildFragmentManager().beginTransaction();
    transaction.add(R.id.restaurant_list_placeholder, firstFragment).commit();
    return inflater.inflate(R.layout.fragment_restaurant_twopane, container, false);
  }
  @Override public void onResume() {
    super.onResume();
    initializeMap();

  }

  private void initializeMap() {

    if (googleMap == null) {
      MapFragment mapFrag=(MapFragment)getFragmentManager().findFragmentById(R.id.map);
      googleMap = mapFrag.getMap();
      // check if map is created successfully or not
      if (googleMap == null) {


      }
    }
  }

}
