package ca.mymenuapp.ui.fragments;


import android.app.FragmentTransaction;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import ca.mymenuapp.R;


public class RestaurantTwoPaneFragment extends BaseFragment {


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

}
