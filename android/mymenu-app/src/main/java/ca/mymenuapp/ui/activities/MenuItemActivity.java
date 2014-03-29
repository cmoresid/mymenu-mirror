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

package ca.mymenuapp.ui.activities;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.view.Menu;
import android.view.View;
import android.widget.ImageView;
import android.widget.ScrollView;
import android.widget.ShareActionProvider;
import android.widget.TextView;
import butterknife.InjectView;
import butterknife.OnClick;
import ca.mymenuapp.R;
import ca.mymenuapp.data.MyMenuDatabase;
import ca.mymenuapp.data.api.model.MenuItem;
import ca.mymenuapp.data.api.model.MenuItemModification;
import ca.mymenuapp.data.api.model.MenuItemReview;
import ca.mymenuapp.data.api.model.Restaurant;
import ca.mymenuapp.data.api.model.User;
import ca.mymenuapp.data.prefs.ObjectPreference;
import ca.mymenuapp.data.rx.EndlessObserver;
import ca.mymenuapp.ui.fragments.ReviewsFragment;
import ca.mymenuapp.ui.fragments.WriteReviewFragment;
import ca.mymenuapp.ui.widgets.NotifyingScrollView;
import ca.mymenuapp.ui.widgets.SlidingUpPanelLayout;
import ca.mymenuapp.util.CollectionUtils;
import com.f2prateek.dart.InjectExtra;
import com.squareup.picasso.Picasso;
import com.squareup.picasso.Target;
import java.util.ArrayList;
import java.util.List;
import javax.inject.Inject;
import javax.inject.Named;

import static ca.mymenuapp.data.DataModule.USER_PREFERENCE;

/**
 * An activity to display a single menu item.
 * It displays the reviews for the menu item, and allows the user to rate the menu item.
 */
public class MenuItemActivity extends BaseActivity {
  public static final String ARGS_MENU_ITEM = "menu_item";
  public static final String ARGS_RESTAURANT = "restaurant";
  public static final String ARGS_REVIEWS = "reviews";

  @Inject @Named(USER_PREFERENCE) ObjectPreference<User> userPreferences;
  @InjectExtra(ARGS_MENU_ITEM) MenuItem menuItem;
  @InjectExtra(ARGS_RESTAURANT) Restaurant restaurant;
  @InjectExtra(ARGS_REVIEWS) ArrayList<MenuItemReview> reviews;

  @InjectView(R.id.menu_item_image_header) ImageView header;
  @InjectView(R.id.menu_item_description) TextView description;
  @InjectView(R.id.menu_item_reviews_summary) TextView reviewSummary;
  @InjectView(R.id.menu_item_modifications_text) TextView modificationsText;

  @InjectView(R.id.sliding_pane) View slidingPane;
  @InjectView(R.id.sliding_layout) SlidingUpPanelLayout slidingLayout;

  @Inject Picasso picasso;
  @Inject MyMenuDatabase myMenuDatabase;

  private Drawable actionBarBackgroundDrawable;
  private ShareActionProvider shareActionProvider;

  private NotifyingScrollView.OnScrollChangedListener onScrollChangedListener =
      new NotifyingScrollView.OnScrollChangedListener() {
        public void onScrollChanged(ScrollView who, int l, int t, int oldl, int oldt) {
          final int headerHeight = header.getHeight() - getActionBar().getHeight();
          final float ratio = (float) Math.min(Math.max(t, 0), headerHeight) / headerHeight;
          updateActionBarBackgroundDrawable(ratio);
        }
      };
  /**
   * A custom {@link com.squareup.picasso.Target} for updating the action bar icon.
   */
  private Target actionBarTarget = new Target() {
    @Override public void onBitmapLoaded(Bitmap bitmap, Picasso.LoadedFrom from) {
      getActionBar().setIcon(new BitmapDrawable(getResources(), bitmap));
    }

    @Override public void onBitmapFailed(Drawable errorDrawable) {

    }

    @Override public void onPrepareLoad(Drawable placeHolderDrawable) {

    }
  };

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    inflateView(R.layout.activity_menu_item);
    getActionBar().setDisplayHomeAsUpEnabled(true);

    // fancy scrolling
    actionBarBackgroundDrawable = new ColorDrawable(getResources().getColor(R.color.turqoise));
    actionBarBackgroundDrawable.setAlpha(0);
    getActionBar().setBackgroundDrawable(actionBarBackgroundDrawable);
    ((NotifyingScrollView) findViewById(R.id.scroll_view)).setOnScrollChangedListener(
        onScrollChangedListener);

    // setup the sliding layout
    slidingLayout.setDragView(reviewSummary);
    slidingLayout.setPanelSlideListener(new SlidingUpPanelLayout.PanelSlideListener() {
      @Override public void onPanelSlide(View panel, float slideOffset) {
        updateActionBarBackgroundDrawable(1 - slideOffset);
      }

      @Override public void onPanelCollapsed(View panel) {
        // todo: animate this change
        slidingPane.setPadding(0, 0, 0, 0);
      }

      @Override public void onPanelExpanded(View panel) {
        // todo: animate this change
        slidingPane.setPadding(0, getActionBar().getHeight(), 0, 0);
      }

      @Override public void onPanelAnchored(View panel) {
      }
    });

    bindView(savedInstanceState);
  }

  @Override public boolean onCreateOptionsMenu(Menu menu) {
    super.onCreateOptionsMenu(menu);

    getMenuInflater().inflate(R.menu.activity_menu_item, menu);

    android.view.MenuItem item = menu.findItem(R.id.menu_item_share);
    shareActionProvider = (ShareActionProvider) item.getActionProvider();
    setShareIntent();

    return true;
  }

  /**
   * Update tha actionBar's background drawable.
   * The ratio is a value between 0 and 1, where 0 means fully transparent and 1 is fully opaque.
   */
  void updateActionBarBackgroundDrawable(final float ratio) {
    final int newAlpha = (int) (ratio * 255);
    actionBarBackgroundDrawable.setAlpha(newAlpha);
  }

  /**
   * Update view with our menu item data.
   */
  private void bindView(Bundle savedInstanceState) {

    getModifications();
    picasso.load(restaurant.businessPicture).into(actionBarTarget);
    picasso.load(menuItem.picture).fit().centerCrop().into(header);
    getActionBar().setTitle(menuItem.name);
    description.setText(menuItem.description);
    if (savedInstanceState == null) {
      getFragmentManager().beginTransaction()
          .add(R.id.menu_item_reviews, ReviewsFragment.newInstance(reviews, false))
          .commit();
    }
  }

  private void getModifications() {
    myMenuDatabase.getModifications(userPreferences.get(), menuItem,
        new EndlessObserver<List<MenuItemModification>>() {
          @Override public void onNext(List<MenuItemModification> modifications) {
            if (CollectionUtils.isNullOrEmpty(modifications)) {
              return;
            }

            StringBuilder modificationText = new StringBuilder();
            for (MenuItemModification modification : modifications) {
              modificationText.append("• ").append(modification.modification).append("\n\n");
            }
            modificationsText.setText(modificationText.toString());
          }
        }
    );
  }

  @Override public void onBackPressed() {
    if (slidingLayout.isExpanded()) {
      slidingLayout.collapsePane();
    } else {
      super.onBackPressed();
    }
  }

  private void setShareIntent() {
    Intent shareIntent = new Intent();
    shareIntent.setAction(Intent.ACTION_SEND);
    // todo check if this item has a picture
    shareIntent.putExtra(Intent.EXTRA_TEXT,
        getString(R.string.share_menu_item, menuItem.name, restaurant.businessName,
            menuItem.picture)
    );
    shareIntent.setType("text/plain");
    shareActionProvider.setShareIntent(shareIntent);
  }

  @OnClick(R.id.write_review_button) void onWriteReviewClicked() {
    WriteReviewFragment wrf = new WriteReviewFragment(menuItem);
    //FragmentTransaction ft = getFragmentManager().beginTransaction();
    wrf.show(getFragmentManager(), "write_review_fragment");
  }
}