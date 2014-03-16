package ca.mymenuapp.ui.activities;

import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.os.Bundle;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.ScrollView;
import android.widget.TextView;
import butterknife.InjectView;
import ca.mymenuapp.R;
import ca.mymenuapp.data.api.model.MenuItem;
import ca.mymenuapp.data.api.model.MenuItemReview;
import ca.mymenuapp.data.api.model.Restaurant;
import ca.mymenuapp.ui.adapters.MenuItemReviewAdapter;
import ca.mymenuapp.ui.widgets.NotifyingScrollView;
import ca.mymenuapp.ui.widgets.SlidingUpPanelLayout;
import com.f2prateek.dart.InjectExtra;
import com.squareup.picasso.Picasso;
import com.squareup.picasso.Target;
import java.util.ArrayList;
import javax.inject.Inject;

/**
 * An activity to display a single menu item.
 */
public class MenuItemActivity extends BaseActivity {
  public static final String ARGS_MENU_ITEM = "menu_item";
  public static final String ARGS_RESTAURANT = "restaurant";
  public static final String ARGS_REVIEWS = "reviews";

  @InjectExtra(ARGS_MENU_ITEM) MenuItem menuItem;
  @InjectExtra(ARGS_RESTAURANT) Restaurant restaurant;
  @InjectExtra(ARGS_REVIEWS) ArrayList<MenuItemReview> reviews;

  @InjectView(R.id.menu_item_image_header) ImageView header;
  @InjectView(R.id.menu_item_description) TextView description;
  @InjectView(R.id.menu_item_reviews) ListView reviewListView;
  @InjectView(R.id.menu_item_reviews_summary) TextView reviewSummary;

  @InjectView(R.id.sliding_layout) SlidingUpPanelLayout slidingLayout;

  @Inject Picasso picasso;

  private Drawable actionBarBackgroundDrawable;

  private NotifyingScrollView.OnScrollChangedListener mOnScrollChangedListener =
      new NotifyingScrollView.OnScrollChangedListener() {
        public void onScrollChanged(ScrollView who, int l, int t, int oldl, int oldt) {
          final int headerHeight = header.getHeight() - getActionBar().getHeight();
          final float ratio = (float) Math.min(Math.max(t, 0), headerHeight) / headerHeight;
          final int newAlpha = (int) (ratio * 255);
          actionBarBackgroundDrawable.setAlpha(newAlpha);
        }
      };
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

    slidingLayout.setAnchorPoint(0.2f);
    slidingLayout.setDragView(reviewSummary);

    initFancyScroll();
  }

  @Override protected void onStart() {
    super.onStart();
    bindView();
  }

  private void initFancyScroll() {
    actionBarBackgroundDrawable = new ColorDrawable(getResources().getColor(R.color.turqoise));
    actionBarBackgroundDrawable.setAlpha(0);

    getActionBar().setBackgroundDrawable(actionBarBackgroundDrawable);

    ((NotifyingScrollView) findViewById(R.id.scroll_view)).setOnScrollChangedListener(
        mOnScrollChangedListener);
  }

  private void bindView() {
    picasso.load(restaurant.businessPicture).into(actionBarTarget);
    picasso.load(menuItem.picture).fit().centerCrop().into(header);
    getActionBar().setTitle(menuItem.name);
    description.setText(menuItem.description);
    reviewListView.setAdapter(new MenuItemReviewAdapter(this, reviews));
  }
}