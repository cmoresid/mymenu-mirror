package ca.mymenuapp.ui.fragments;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.ListView;
import android.widget.TextView;
import butterknife.ButterKnife;
import butterknife.InjectView;
import ca.mymenuapp.R;
import ca.mymenuapp.data.MyMenuDatabase;
import ca.mymenuapp.data.api.model.MenuItemReview;
import ca.mymenuapp.data.rx.EndlessObserver;
import ca.mymenuapp.ui.misc.BindableAdapter;
import com.f2prateek.dart.InjectExtra;
import java.util.List;
import javax.inject.Inject;

public class RestaurantsReviewFragment extends BaseFragment {

  public static final String ARGS_RESTAURANT_ID = "restaurant_id";
  @InjectExtra(ARGS_RESTAURANT_ID) long restaurantId;
  @InjectView(R.id.menu_review_list) ListView listView;
  @Inject MyMenuDatabase myMenuDatabase;
  private AbsListView.OnScrollListener scrollListener;

  /**
   * Returns a new instance of this fragment for the given section number.
   */
  public static RestaurantsReviewFragment newInstance(long restaurantId) {
    RestaurantsReviewFragment fragment = new RestaurantsReviewFragment();
    Bundle args = new Bundle();
    args.putLong(ARGS_RESTAURANT_ID, restaurantId);
    fragment.setArguments(args);
    return fragment;
  }

  @Override public View onCreateView(LayoutInflater inflater, ViewGroup container,
      Bundle savedInstanceState) {
    return inflater.inflate(R.layout.fragment_menu_reviews, container, false);
  }

  @Override public void onAttach(Activity activity) {
    super.onAttach(activity);
    scrollListener = (AbsListView.OnScrollListener) activity;
  }

  @Override public void onStart() {
    super.onStart();
    myMenuDatabase.getRestaurantReviews(restaurantId, new EndlessObserver<List<MenuItemReview>>() {
      @Override public void onNext(List<MenuItemReview> menuItemReviews) {
        View placeholder = LayoutInflater.from(activityContext)
            .inflate(R.layout.restaurant_header_placeholder, listView, false);
        listView.addHeaderView(placeholder);
        listView.setTag(placeholder);
        listView.setAdapter(new MenuItemAdapter(activityContext, menuItemReviews));
        listView.setOnScrollListener(scrollListener);
      }
    });
  }

  class MenuItemAdapter extends BindableAdapter<MenuItemReview> {
    final List<MenuItemReview> reviews;

    public MenuItemAdapter(Context context, List<MenuItemReview> reviews) {
      super(context);
      this.reviews = reviews;
    }

    @Override public int getCount() {
      return reviews.size();
    }

    @Override public MenuItemReview getItem(int position) {
      return reviews.get(position);
    }

    @Override public long getItemId(int position) {
      return getItem(position).id;
    }

    @Override public View newView(LayoutInflater inflater, int position, ViewGroup container) {
      View view = inflater.inflate(android.R.layout.simple_list_item_2, container, false);
      ViewHolder viewHolder = new ViewHolder(view);
      view.setTag(viewHolder);
      return view;
    }

    @Override public void bindView(MenuItemReview review, int position, View view) {
      ViewHolder holder = (ViewHolder) view.getTag();
      holder.label.setText(review.description);
      holder.subLabel.setText(review.userEmail);
    }

    class ViewHolder {
      @InjectView(android.R.id.text1) TextView label;
      @InjectView(android.R.id.text2) TextView subLabel;

      ViewHolder(View root) {
        ButterKnife.inject(this, root);
      }
    }
  }
}
