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

public class RestaurantTwoPaneFragment extends BaseFragment
    implements GooglePlayServicesClient.ConnectionCallbacks,
    GooglePlayServicesClient.OnConnectionFailedListener {

  private GoogleMap googleMap;
  private Location userLoc;
  private LocationClient locClient;

  public static RestaurantTwoPaneFragment newInstance() {
    return new RestaurantTwoPaneFragment();
  }

  @Override
  public View onCreateView(LayoutInflater inflater, ViewGroup container,
      Bundle savedInstanceState) {
    int resultCode = GooglePlayServicesUtil.isGooglePlayServicesAvailable(getActivity());

    if (ConnectionResult.SUCCESS == resultCode) {
      locClient = new LocationClient(getActivity(), this, this);
      locClient.connect();

    } else {
      Ln.e("Cant connect to GooglePlay");
    }

    return inflater.inflate(R.layout.fragment_restaurant_twopane, container, false);
  }

  private void initializeMap() {
    if (googleMap == null) {
      MapFragment mapFrag = (MapFragment) getFragmentManager().findFragmentById(R.id.map);
      googleMap = mapFrag.getMap();
      // check if map is created successfully or not
      if (googleMap != null) {
        googleMap.setMyLocationEnabled(true);
        googleMap.addMarker(
            new MarkerOptions().position(new LatLng(53.5, -113.4)).title("HardCodedUserLoc"));

      }
    }
  }

  @Override public void onConnected(Bundle bundle) {
    userLoc = locClient.getLastLocation();
    initializeMap();
    RestaurantListFragment firstFragment = new RestaurantListFragment(googleMap, userLoc);
    FragmentTransaction transaction = getChildFragmentManager().beginTransaction();
    transaction.add(R.id.restaurant_list_placeholder, firstFragment).commit();
  }

  @Override public void onDisconnected() {

  }

  @Override public void onConnectionFailed(ConnectionResult connectionResult) {
    if (connectionResult.hasResolution()) {
      try {
        connectionResult.startResolutionForResult(getActivity(), 9000);
      } catch (IntentSender.SendIntentException e) {
        e.printStackTrace();
      }
    } else {
      showErrorDialog(connectionResult.getErrorCode());
    }
  }

  private void showErrorDialog(int errorCode) {
    Ln.e("Error Code:" + errorCode);
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

