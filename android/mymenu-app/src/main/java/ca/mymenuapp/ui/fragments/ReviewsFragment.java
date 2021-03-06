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

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.ListView;
import android.widget.Toast;
import butterknife.InjectView;
import ca.mymenuapp.R;
import ca.mymenuapp.data.MyMenuDatabase;
import ca.mymenuapp.data.api.model.MenuItemReview;
import ca.mymenuapp.data.api.model.User;
import ca.mymenuapp.data.prefs.ObjectPreference;
import ca.mymenuapp.data.rx.EndlessObserver;
import ca.mymenuapp.ui.adapters.MenuItemReviewAdapter;
import ca.mymenuapp.ui.misc.BindableListAdapter;
import ca.mymenuapp.util.CollectionUtils;
import com.f2prateek.dart.InjectExtra;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import javax.inject.Inject;
import javax.inject.Named;
import retrofit.client.Response;

import static ca.mymenuapp.data.DataModule.USER_PREFERENCE;

/**
 * Fragment to display a list of reviews for a restaurant.
 */
public class ReviewsFragment extends BaseFragment
    implements MenuItemReviewAdapter.OnReviewActionClickedListener {
  private static final String ARGS_REVIEWS = "reviews";
  private static final String ARGS_SHOW_HEADER = "header";

  @Inject MyMenuDatabase myMenuDatabase;
  @Inject @Named(USER_PREFERENCE) ObjectPreference<User> userPreference;

  @InjectExtra(ARGS_REVIEWS) ArrayList<MenuItemReview> menuItemReviews;
  @InjectExtra(ARGS_SHOW_HEADER) boolean shouldHaveHeader;

  @InjectView(R.id.menu_review_list) ListView listView;

  private AbsListView.OnScrollListener scrollListener;
  private BindableListAdapter<MenuItemReview> adapter;

  /**
   * Returns a new instance of this fragment for the given section number.
   *
   * @param shouldHaveHeader true if parent activity wants to add a header and be notified for
   * scrolls
   */
  public static ReviewsFragment newInstance(List<MenuItemReview> reviews,
      boolean shouldHaveHeader) {
    ReviewsFragment fragment = new ReviewsFragment();
    Bundle args = new Bundle();
    ArrayList<MenuItemReview> arrayList = new ArrayList<>(reviews);
    args.putParcelableArrayList(ARGS_REVIEWS, arrayList);
    args.putBoolean(ARGS_SHOW_HEADER, shouldHaveHeader);
    fragment.setArguments(args);
    return fragment;
  }

  @Override public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setHasOptionsMenu(true);
  }

  @Override public View onCreateView(LayoutInflater inflater, ViewGroup container,
      Bundle savedInstanceState) {
    ListView root = (ListView) inflater.inflate(R.layout.fragment_menu_reviews, container, false);
    if (shouldHaveHeader) {
      View header = inflater.inflate(R.layout.restaurant_header_placeholder, root, false);
      root.addHeaderView(header);
    }
    return root;
  }

  @Override public void onActivityCreated(Bundle savedInstanceState) {
    super.onActivityCreated(savedInstanceState);
    if (shouldHaveHeader) {
      scrollListener = (AbsListView.OnScrollListener) getActivity();
      listView.setOnScrollListener(scrollListener);
    }
  }

  @Override public void onStart() {
    super.onStart();
    init();
  }

  @Override public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
    super.onCreateOptionsMenu(menu, inflater);
    inflater.inflate(R.menu.fragment_reviews, menu);
  }

  @Override public boolean onOptionsItemSelected(MenuItem item) {
    switch (item.getItemId()) {
      // all the comparators sort in descending order
      case R.id.sort_date:
        adapter.sort(new Comparator<MenuItemReview>() {
          // sort reviews by date, newest going first
          @Override public int compare(MenuItemReview lhs, MenuItemReview rhs) {
            return (rhs.getDate()).compareTo(lhs.getDate());
          }
        });
        break;
      case R.id.sort_rating:
        adapter.sort(new Comparator<MenuItemReview>() {
          // sort reviews by rating, highest going first
          @Override public int compare(MenuItemReview lhs, MenuItemReview rhs) {
            return Double.compare(rhs.rating, lhs.rating);
          }
        });
        break;
      case R.id.sort_like_count:
        adapter.sort(new Comparator<MenuItemReview>() {
          @Override public int compare(MenuItemReview l, MenuItemReview r) {
            // sort reviews by like count, highest going first
            int lhs = l.getLikeCount();
            int rhs = r.getLikeCount();
            // Copied from {@link Integer#compare(int, int)} - original is only API 17+
            return rhs < lhs ? -1 : (rhs == lhs ? 0 : 1);
          }
        });
        break;
      default:
        return super.onOptionsItemSelected(item);
    }
    return true;
  }

  @Override public void onReviewActionClicked(int action, MenuItemReview itemReview) {
    switch (action) {
      case R.id.like:
        if (!userPreference.get().isGuest()) {
          myMenuDatabase.likeReview(userPreference.get(), itemReview,
              new EndlessObserver<Response>() {
                @Override public void onNext(Response args) {
                  // ignore...
                }
              }
          );
          itemReview.likeCount = String.valueOf(itemReview.getLikeCount() + 1);
          adapter.notifyDataSetChanged();
          Toast.makeText(getActivity(), R.string.liked, Toast.LENGTH_LONG).show();
        } else {
          Toast.makeText(getActivity(), R.string.sign_up, Toast.LENGTH_LONG).show();
        }
        break;
      case R.id.spam:
        if (!userPreference.get().isGuest()) {
          myMenuDatabase.addReport(itemReview, userPreference.get(),
              new EndlessObserver<Response>() {
                @Override public void onNext(Response args) {
                  // ignore...
                }
              }
          );
          Toast.makeText(getActivity(), R.string.reported, Toast.LENGTH_LONG).show();
        } else {
          Toast.makeText(getActivity(), R.string.sign_up, Toast.LENGTH_LONG).show();
        }
        break;
      default:
        throw new RuntimeException("Invalid Action " + action);
    }
  }

  public void onReviewCreated(MenuItemReview review) {
    if (CollectionUtils.isNullOrEmpty(menuItemReviews)) {
      menuItemReviews = new ArrayList<>();
      init();
    }
    menuItemReviews.add(review);
    adapter.notifyDataSetChanged();
    adapter.notifyDataSetInvalidated();
  }

  private void init() {
    adapter = new MenuItemReviewAdapter(activityContext, menuItemReviews, this);
    listView.setAdapter(adapter);
  }
}
