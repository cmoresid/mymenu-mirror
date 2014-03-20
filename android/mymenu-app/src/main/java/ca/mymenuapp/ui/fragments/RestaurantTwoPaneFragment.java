package ca.mymenuapp.ui.fragments;

import android.app.Fragment;
import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.content.IntentSender;
import android.location.Location;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;
import ca.mymenuapp.R;
import com.f2prateek.dart.InjectExtra;
import com.f2prateek.ln.Ln;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesClient;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.location.LocationClient;
import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.MapFragment;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.MarkerOptions;

public class RestaurantTwoPaneFragment extends BaseFragment{


  public static RestaurantTwoPaneFragment newInstance() {
    return new RestaurantTwoPaneFragment();
  }

  @Override
  public View onCreateView(LayoutInflater inflater, ViewGroup container,
      Bundle savedInstanceState) {
    initializeFrames();
    return inflater.inflate(R.layout.fragment_restaurant_twopane, container, false);
  }

  private void initializeFrames(){
    RestaurantListFragment firstFragment = new RestaurantListFragment();
    FragmentTransaction transaction = getChildFragmentManager().beginTransaction();
    transaction.add(R.id.restaurant_list_placeholder, firstFragment);
    RestaurantMapFragment secondFragment = new RestaurantMapFragment();
    transaction.add(R.id.restaurant_map_placeholder, secondFragment).commit();
  }

  @Override
  public void onPause() {

    FragmentManager fm = getFragmentManager();

    Fragment xmlFragment = fm.findFragmentById(R.id.map);
    if (xmlFragment != null) {
      fm.beginTransaction().remove(xmlFragment).commit();
    }

    super.onPause();
  }
}

