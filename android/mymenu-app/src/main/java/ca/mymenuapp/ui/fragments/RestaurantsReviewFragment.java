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
import ca.mymenuapp.data.api.model.MenuItemReview;
import ca.mymenuapp.ui.misc.BindableAdapter;
import com.f2prateek.dart.InjectExtra;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;

/**
 * Fragment to display a list of reviews for a restaurant.
 */
public class RestaurantsReviewFragment extends BaseFragment {

  static final String ARGS_REVIEWS = "reviews";
  @InjectExtra(ARGS_REVIEWS) ArrayList<MenuItemReview> menuItemReviews;
  @InjectView(R.id.menu_review_list) ListView listView;
  private AbsListView.OnScrollListener scrollListener;

  /**
   * Returns a new instance of this fragment for the given section number.
   */
  public static RestaurantsReviewFragment newInstance(List<MenuItemReview> reviews) {
    RestaurantsReviewFragment fragment = new RestaurantsReviewFragment();
    Bundle args = new Bundle();
    ArrayList<MenuItemReview> arrayList = new ArrayList<>(reviews);
    args.putParcelableArrayList(ARGS_REVIEWS, arrayList);
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
    View placeholder = LayoutInflater.from(activityContext)
        .inflate(R.layout.restaurant_header_placeholder, listView, false);
    listView.addHeaderView(placeholder);
    listView.setTag(placeholder);
    listView.setAdapter(new MenuItemAdapter(activityContext, menuItemReviews));
    listView.setOnScrollListener(scrollListener);
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
      View view = inflater.inflate(R.layout.adapter_review_menu_item, container, false);
      ViewHolder viewHolder = new ViewHolder(view);
      view.setTag(viewHolder);
      return view;
    }

    @Override public void bindView(MenuItemReview review, int position, View view) {
      ViewHolder holder = (ViewHolder) view.getTag();
      holder.email.setText(review.userEmail);
      holder.review.setText(review.description);
      if (review.rating < 5f) {
        setLeftDrawable(R.drawable.ic_action_emo_shame, holder.email);
      } else {
        setLeftDrawable(R.drawable.ic_action_emo_basic, holder.email);
      }
      holder.rating.setText(NumberFormat.getInstance().format(review.rating));
    }

    void setLeftDrawable(int drawable, TextView target) {
      target.setCompoundDrawablesWithIntrinsicBounds(drawable, 0, 0, 0);
    }

    class ViewHolder {
      @InjectView(R.id.email) TextView email;
      @InjectView(R.id.review) TextView review;
      @InjectView(R.id.like) View like;
      @InjectView(R.id.dislike) View dislike;
      @InjectView(R.id.rating) TextView rating;

      ViewHolder(View root) {
        ButterKnife.inject(this, root);
      }
    }
  }
}
