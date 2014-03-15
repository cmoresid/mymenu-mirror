package ca.mymenuapp.ui.fragments;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.squareup.picasso.Picasso;

import java.util.List;

import javax.inject.Inject;

import butterknife.ButterKnife;
import butterknife.InjectView;
import ca.mymenuapp.R;
import ca.mymenuapp.data.MyMenuDatabase;
import ca.mymenuapp.data.api.model.Restaurant;
import ca.mymenuapp.data.rx.EndlessObserver;
import ca.mymenuapp.ui.misc.BindableAdapter;
import ca.mymenuapp.ui.widgets.BetterViewAnimator;

/**

 * <p/>
 * interface.
 */
public class RestaurantListFragment extends BaseFragment implements AdapterView.OnItemClickListener {


    @Inject Picasso picasso;
    @InjectView(R.id.root2) BetterViewAnimator root2;
    @Inject MyMenuDatabase myMenuDatabase;
    @InjectView(R.id.restaurant_list) ListView listofRestaurants;

    BaseAdapter restListAdapter;

    public RestaurantListFragment() {
    }

    public static RestaurantListFragment newInstance() {
        return new RestaurantListFragment();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        return inflater.inflate(R.layout.fragment_restaurant_list, container, false);
    }


    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
    }

    @Override
    public void onStart() {
        super.onStart();
        getRestaurantList();
    }

    /* Need create an intent to go to restaurant page when clicked */
    @Override
    public void onItemClick(AdapterView<?> adapterView, View view, int i, long l) {

    }
    private void getRestaurantList() {
        /* Change this to get all restaurants and then initialize the list. */
        myMenuDatabase.getAllRestaurants(new EndlessObserver<List<Restaurant>>() {
                                             @Override
                                             public void onNext(
                                                     List<Restaurant> Restaurants) {
                                                 initList(Restaurants);
                                             }
                                         }
        );
    }

    private void initList(List<Restaurant> restList) {
        root2.setDisplayedChildId(R.id.restaurant_list);
        restListAdapter = new RestaurantListAdapter(activityContext, restList);
        listofRestaurants.setAdapter(restListAdapter);
        listofRestaurants.setOnItemClickListener(this);
    }


    class RestaurantListAdapter extends BindableAdapter<Restaurant> {
        private final List<Restaurant> listOfRestaurants;
        public RestaurantListAdapter(Context context,
                                     List<Restaurant> restList) {
            super(context);
            this.listOfRestaurants = restList;
        }

        @Override
        public int getCount() {
            return listOfRestaurants.size();
        }

        @Override
        public Restaurant getItem(int position) {
            return listOfRestaurants.get(position);
        }

        @Override
        public long getItemId(int position) {
            return position + 1;
        }

        @Override
        public View newView(LayoutInflater inflater, int position, ViewGroup container) {
            View view = inflater.inflate(R.layout.adapter_restaurant_list, container, false);
            ViewHolder holder = new ViewHolder(view);
            view.setTag(holder);
            return view;
        }

        @Override
        public void bindView(Restaurant item, int position, View view) {
            ViewHolder holder = (ViewHolder) view.getTag();

            RestaurantListFragment.this.picasso.load(item.businessPicture)
                    .placeholder(R.drawable.ic_launcher)
                    .fit()
                    .centerCrop()
                    .into(holder.picture);
            holder.label.setText(item.businessName);
            holder.rating.setText(Double.toString(item.rating));
            holder.address.setText(item.address);
            /* Need to query db to find what this category means */
            holder.cuisine.setText("cuisine = " + item.categoryId);

        }

        class ViewHolder {
            @InjectView(R.id.restImage)
            ImageView picture;
            @InjectView(R.id.restName)
            TextView label;
            @InjectView(R.id.restRating)
            TextView rating;
            @InjectView(R.id.restCuisine)
            TextView cuisine;
            @InjectView(R.id.restAddress)
            TextView address;
            ViewHolder(View root) {
                ButterKnife.inject(this, root);
            }
        }
    }


}
