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

import android.app.Activity;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.ListView;
import butterknife.InjectView;
import ca.mymenuapp.R;
import ca.mymenuapp.data.api.model.MenuItemReview;
import ca.mymenuapp.ui.adapters.MenuItemReviewAdapter;
import com.f2prateek.dart.InjectExtra;
import com.f2prateek.ln.Ln;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/**
 * Fragment to display a list of reviews for a restaurant.
 */
public class ReviewsFragment extends BaseFragment {
  private static final String ARGS_REVIEWS = "reviews";

  @InjectExtra(ARGS_REVIEWS) ArrayList<MenuItemReview> menuItemReviews;
  @InjectView(R.id.menu_review_list) ListView listView;
  private AbsListView.OnScrollListener scrollListener;

  /**
   * Returns a new instance of this fragment for the given section number.
   */
  public static ReviewsFragment newInstance(List<MenuItemReview> reviews) {
    ReviewsFragment fragment = new ReviewsFragment();
    Bundle args = new Bundle();
    ArrayList<MenuItemReview> arrayList = new ArrayList<>(reviews);
    args.putParcelableArrayList(ARGS_REVIEWS, arrayList);
    fragment.setArguments(args);
    return fragment;
  }

  @Override public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setHasOptionsMenu(true);
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
    listView.setAdapter(new MenuItemReviewAdapter(activityContext, menuItemReviews));
    listView.setOnScrollListener(scrollListener);
  }

  @Override public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
    super.onCreateOptionsMenu(menu, inflater);
    inflater.inflate(R.menu.fragment_reviews, menu);
  }

  @Override public boolean onOptionsItemSelected(MenuItem item) {
    switch (item.getItemId()) {
      case R.id.sort_date:
        sortListView(new Comparator<MenuItemReview>() {
          SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
          @Override public int compare(MenuItemReview lhs, MenuItemReview rhs) {
            try {
              return formatter.parse(lhs.date).compareTo(formatter.parse(rhs.date));
            } catch (ParseException e) {
              Ln.e(e);
              e.printStackTrace();
              return 0;
            }
          }
        });
        break;
      case R.id.sort_rating:
        sortListView(new Comparator<MenuItemReview>() {
          @Override public int compare(MenuItemReview lhs, MenuItemReview rhs) {
            return Float.compare(lhs.rating, rhs.rating);
          }
        });
        break;
      case R.id.sort_like_count:
        sortListView(new Comparator<MenuItemReview>() {
          @Override public int compare(MenuItemReview l, MenuItemReview r) {
            int lhs = Integer.parseInt(l.getLikeCount());
            int rhs = Integer.parseInt(r.getLikeCount());
            // Copied from {@link Integer#compare(int, int)} - original only API 17+
            return lhs < rhs ? -1 : (lhs == rhs ? 0 : 1);
          }
        });
        break;
      default:
        return super.onOptionsItemSelected(item);
    }
    return true;
  }

  private void sortListView(Comparator<MenuItemReview> comparator) {
    Collections.sort(menuItemReviews, comparator);
    Collections.reverse(menuItemReviews);
    listView.setAdapter(new MenuItemReviewAdapter(activityContext, menuItemReviews));
  }
}
