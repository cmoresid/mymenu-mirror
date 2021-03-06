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
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Parcelable;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ImageView;
import android.widget.ShareActionProvider;
import android.widget.TextView;
import butterknife.ButterKnife;
import butterknife.InjectView;
import ca.mymenuapp.R;
import ca.mymenuapp.data.MyMenuDatabase;
import ca.mymenuapp.data.api.model.MenuItem;
import ca.mymenuapp.data.api.model.MenuItemReview;
import ca.mymenuapp.data.api.model.MenuItemReviewResponse;
import ca.mymenuapp.data.api.model.Restaurant;
import ca.mymenuapp.data.rx.EndlessObserver;
import ca.mymenuapp.ui.activities.MenuItemActivity;
import ca.mymenuapp.ui.misc.BindableListAdapter;
import ca.mymenuapp.ui.widgets.HeaderGridView;
import ca.mymenuapp.util.CollectionUtils;
import com.f2prateek.dart.InjectExtra;
import com.squareup.picasso.Picasso;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import javax.inject.Inject;

/**
 * A fragment that displays a grid of menu items.
 * Parent activity must implement {@link android.widget.AdapterView.OnItemClickListener}
 * for fancy scrolling effects.
 * THe menu items can be arbitrary, and the user can sort them.
 * This is typically used to display a categorized page of the menu, or specials.
 */
public class MenuItemsGridFragment extends BaseFragment implements AdapterView.OnItemClickListener {
  private static final String ARGS_ITEMS = "items";
  private static final String ARGS_RESTAURANT = "restaurant";
  private static final String ARGS_REVIEWS = "reviews";

  @InjectExtra(ARGS_RESTAURANT) Restaurant restaurant;
  @InjectExtra(ARGS_ITEMS) ArrayList<MenuItem> items;
  @InjectExtra(ARGS_REVIEWS) ArrayList<MenuItemReview> reviews;

  @InjectView(R.id.menu_grid) HeaderGridView gridView;

  @Inject Picasso picasso;
  @Inject MyMenuDatabase myMenuDatabase;

  AbsListView.OnScrollListener scrollListener;
  MenuItemAdapter gridAdapter;
  ShareActionProvider shareActionProvider;
  Intent ourIntent;
  List<MenuItemReview> menuItemReviews;

  /**
   * Returns a new instance of this fragment for the given section number.
   */
  public static MenuItemsGridFragment newInstance(final List<MenuItem> menuItems,
      final Restaurant restaurant, final List<MenuItemReview> reviews) {
    MenuItemsGridFragment fragment = new MenuItemsGridFragment();
    Bundle args = new Bundle();
    ArrayList<MenuItem> menuItemArrayList = new ArrayList<>(menuItems);
    //Collections.shuffle(menuItemArrayList); // todo, evaluate usefullness?
    args.putParcelableArrayList(ARGS_ITEMS, menuItemArrayList);
    args.putParcelable(ARGS_RESTAURANT, restaurant);
    args.putParcelableArrayList(ARGS_REVIEWS, new ArrayList<Parcelable>(reviews));
    fragment.setArguments(args);
    return fragment;
  }

  @Override public void onAttach(Activity activity) {
    super.onAttach(activity);
    scrollListener = (AbsListView.OnScrollListener) activity;
  }

  @Override public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setHasOptionsMenu(true);
  }

  @Override public View onCreateView(LayoutInflater inflater, ViewGroup container,
      Bundle savedInstanceState) {
    View root = inflater.inflate(R.layout.fragment_menu_items_grid, container, false);
    HeaderGridView gridView = ButterKnife.findById(root, R.id.menu_grid);
    View placeholder = inflater.inflate(R.layout.restaurant_header_placeholder, gridView, false);
    gridView.addHeaderView(placeholder);
    return root;
  }

  @Override public void onActivityCreated(Bundle savedInstanceState) {
    super.onActivityCreated(savedInstanceState);
    gridAdapter = new MenuItemAdapter(activityContext, items, picasso);
    gridView.setAdapter(gridAdapter);
    gridView.setOnScrollListener(scrollListener);
    gridView.setOnItemClickListener(this);
  }

  @Override public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
    super.onCreateOptionsMenu(menu, inflater);
    inflater.inflate(R.menu.fragment_menu_item_grid, menu);
  }

  @Override public boolean onOptionsItemSelected(android.view.MenuItem item) {
    switch (item.getItemId()) {
      // all the comparators sort in descending order
      case R.id.sort_rating:
        gridAdapter.sort(new Comparator<MenuItem>() {
          // sort reviews by rating, highest going first
          @Override public int compare(MenuItem lhs, MenuItem rhs) {
            return Float.compare(rhs.rating, lhs.rating);
          }
        });
        break;
      default:
        return super.onOptionsItemSelected(item);
    }
    return true;
  }

  @Override
  public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
    final MenuItem menuItem = (MenuItem) parent.getAdapter().getItem(position);
    ourIntent = new Intent(activityContext, MenuItemActivity.class);
    ourIntent.putExtra(MenuItemActivity.ARGS_MENU_ITEM, menuItem);
    ourIntent.putExtra(MenuItemActivity.ARGS_RESTAURANT, restaurant);

    /* Retrieves reviews for the selected menu item */
    if (menuItem != null) {
      myMenuDatabase.getReviews(menuItem, new EndlessObserver<MenuItemReviewResponse>() {
        @Override public void onNext(MenuItemReviewResponse args) {
          ArrayList<MenuItemReview> mIr = new ArrayList<>();
          if (!CollectionUtils.isNullOrEmpty(args.reviews)) {
            mIr = (ArrayList) args.reviews;
          }
          ourIntent.putExtra(MenuItemActivity.ARGS_REVIEWS, mIr);
          startActivity(ourIntent);
        }
      });
    }
  }

  static class MenuItemAdapter extends BindableListAdapter<MenuItem> {

    final Picasso picasso;

    public MenuItemAdapter(Context context, List<MenuItem> menuItems, Picasso picasso) {
      super(context, menuItems);
      this.picasso = picasso;
    }

    @Override public long getItemId(int position) {
      return getItem(position).id;
    }

    @Override public View newView(LayoutInflater inflater, int position, ViewGroup container) {
      View view = inflater.inflate(R.layout.adapter_menu_item, container, false);
      ViewHolder viewHolder = new ViewHolder(view);
      view.setTag(viewHolder);
      return view;
    }

    @Override public void bindView(MenuItem item, int position, View view) {
      ViewHolder holder = (ViewHolder) view.getTag();
      holder.label.setText(item.name);
      picasso.load(item.picture).fit().centerCrop().into(holder.picture);
      if (item.isNotEdible()) {
        holder.restriction.setVisibility(View.VISIBLE);
      } else {
        holder.restriction.setVisibility(View.GONE);
      }
    }

    static class ViewHolder {
      @InjectView(R.id.menu_item_picture) ImageView picture;
      @InjectView(R.id.menu_item_label) TextView label;
      @InjectView(R.id.menu_item_restriction_icon) ImageView restriction;

      ViewHolder(View root) {
        ButterKnife.inject(this, root);
      }
    }
  }
}