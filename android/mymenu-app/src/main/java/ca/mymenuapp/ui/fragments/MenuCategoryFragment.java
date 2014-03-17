package ca.mymenuapp.ui.fragments;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Parcelable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;
import butterknife.ButterKnife;
import butterknife.InjectView;
import ca.mymenuapp.R;
import ca.mymenuapp.data.api.model.MenuItem;
import ca.mymenuapp.data.api.model.MenuItemReview;
import ca.mymenuapp.data.api.model.Restaurant;
import ca.mymenuapp.ui.activities.MenuItemActivity;
import ca.mymenuapp.ui.misc.BindableAdapter;
import ca.mymenuapp.ui.widgets.HeaderGridView;
import com.f2prateek.dart.InjectExtra;
import com.squareup.picasso.Picasso;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import javax.inject.Inject;

public class MenuCategoryFragment extends BaseFragment implements AdapterView.OnItemClickListener {
  private static final String ARGS_ITEMS = "items";
  private static final String ARGS_RESTAURANT = "restaurant";
  private static final String ARGS_REVIEWS = "reviews";

  @InjectExtra(ARGS_RESTAURANT) Restaurant restaurant;
  @InjectExtra(ARGS_ITEMS) ArrayList<MenuItem> items;
  @InjectExtra(ARGS_REVIEWS) ArrayList<MenuItemReview> reviews;

  @InjectView(R.id.menu_grid) HeaderGridView gridView;

  @Inject Picasso picasso;

  AbsListView.OnScrollListener scrollListener;
  BaseAdapter gridAdapter;

  /**
   * Returns a new instance of this fragment for the given section number.
   */
  public static MenuCategoryFragment newInstance(final List<MenuItem> menuItems,
      final Restaurant restaurant, final List<MenuItemReview> reviews) {
    MenuCategoryFragment fragment = new MenuCategoryFragment();
    Bundle args = new Bundle();
    ArrayList<MenuItem> menuItemArrayList = new ArrayList<>(menuItems);
    Collections.shuffle(menuItemArrayList); // todo, evaluate usefullness?
    args.putParcelableArrayList(ARGS_ITEMS, menuItemArrayList);
    args.putParcelable(ARGS_RESTAURANT, restaurant);
    args.putParcelableArrayList(ARGS_REVIEWS, new ArrayList<Parcelable>(reviews));
    fragment.setArguments(args);
    return fragment;
  }

  @Override public View onCreateView(LayoutInflater inflater, ViewGroup container,
      Bundle savedInstanceState) {
    return inflater.inflate(R.layout.fragment_menu_category, container, false);
  }

  @Override public void onStart() {
    super.onStart();
    View placeholder = LayoutInflater.from(activityContext)
        .inflate(R.layout.restaurant_header_placeholder, gridView, false);
    gridView.addHeaderView(placeholder);
    gridView.setTag(placeholder);
    gridAdapter = new MenuItemAdapter(activityContext, items);
    gridView.setAdapter(gridAdapter);
    gridView.setOnScrollListener(scrollListener);
    gridView.setOnItemClickListener(this);
  }

  @Override public void onAttach(Activity activity) {
    super.onAttach(activity);
    scrollListener = (AbsListView.OnScrollListener) activity;
  }

  @Override
  public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
    // headers are added to position!
    // position is indexed by one but list is by zero
    int index = position - 1 - ((HeaderGridView) parent).getHeaderViewCount();
    MenuItem menuItem = items.get(index);
    Intent intent = new Intent(activityContext, MenuItemActivity.class);
    intent.putExtra(MenuItemActivity.ARGS_MENU_ITEM, menuItem);
    intent.putExtra(MenuItemActivity.ARGS_RESTAURANT, restaurant);
    // todo : optimize in a background thread?
    ArrayList<MenuItemReview> menuItemReviews = new ArrayList<>();
    for (MenuItemReview review : reviews) {
      if (review.menuId == menuItem.id) menuItemReviews.add(review);
    }
    intent.putExtra(MenuItemActivity.ARGS_REVIEWS, menuItemReviews);
    startActivity(intent);
  }

  class MenuItemAdapter extends BindableAdapter<MenuItem> {
    final List<MenuItem> menuItems;

    public MenuItemAdapter(Context context, List<MenuItem> menuItems) {
      super(context);
      this.menuItems = menuItems;
    }

    @Override public int getCount() {
      return menuItems.size();
    }

    @Override public MenuItem getItem(int position) {
      return menuItems.get(position);
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
    }

    class ViewHolder {
      @InjectView(R.id.menu_item_picture) ImageView picture;
      @InjectView(R.id.menu_item_label) TextView label;

      ViewHolder(View root) {
        ButterKnife.inject(this, root);
      }
    }
  }
}