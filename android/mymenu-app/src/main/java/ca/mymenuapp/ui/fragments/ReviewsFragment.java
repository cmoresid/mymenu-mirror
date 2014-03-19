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
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.ListView;
import butterknife.InjectView;
import ca.mymenuapp.R;
import ca.mymenuapp.data.api.model.MenuItemReview;
import ca.mymenuapp.ui.adapters.MenuItemReviewAdapter;
import com.f2prateek.dart.InjectExtra;
import java.util.ArrayList;
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
}
