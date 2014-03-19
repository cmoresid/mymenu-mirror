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

import android.app.Fragment;
import android.app.FragmentManager;
import android.content.Intent;
import android.graphics.RectF;
import android.os.Bundle;
import android.support.v13.app.FragmentPagerAdapter;
import android.support.v4.app.NavUtils;
import android.support.v4.app.TaskStackBuilder;
import android.support.v4.view.ViewPager;
import android.text.Spannable;
import android.text.SpannableString;
import android.util.TypedValue;
import android.view.MenuItem;
import android.view.View;
import android.view.animation.AccelerateDecelerateInterpolator;
import android.widget.AbsListView;
import android.widget.ImageView;
import butterknife.InjectView;
import ca.mymenuapp.R;
import ca.mymenuapp.data.MyMenuDatabase;
import ca.mymenuapp.data.api.model.RestaurantMenu;
import ca.mymenuapp.data.api.model.User;
import ca.mymenuapp.data.prefs.ObjectPreference;
import ca.mymenuapp.data.rx.EndlessObserver;
import ca.mymenuapp.ui.fragments.MenuItemsGridFragment;
import ca.mymenuapp.ui.fragments.ReviewsFragment;
import ca.mymenuapp.ui.misc.AlphaForegroundColorSpan;
import ca.mymenuapp.ui.widgets.KenBurnsView;
import com.astuetz.PagerSlidingTabStrip;
import com.f2prateek.dart.InjectExtra;
import com.squareup.picasso.Picasso;
import javax.inject.Inject;
import javax.inject.Named;

import static ca.mymenuapp.data.DataModule.USER_PREFERENCE;

/**
 * An activity to display a single restaurant.
 *
 * Limitations : menu item images must not be transparent (or contain any transparent pixels, or we
 * can see the list scrolling behind it.
 *
 * todo : sync scrolling
 * todo : handle landscape
 */
public class RestaurantActivity extends BaseActivity implements AbsListView.OnScrollListener {
  public static final String ARGS_RESTAURANT_ID = "restaurant_id";

  @InjectExtra(ARGS_RESTAURANT_ID) long restaurantId;
  // The action bar icon view
  @InjectView(android.R.id.home) ImageView actionBarIconView;
  // top level header that contains restaurantHeaderBackground, restaurantHeaderLogo and tabStrip
  @InjectView(R.id.restaurant_header) View restaurantHeader;
  // background that animates with random menu item pictures
  @InjectView(R.id.restaurant_header_image) KenBurnsView restaurantHeaderBackground;
  // logo for this restaurant
  @InjectView(R.id.restaurant_header_logo) ImageView restaurantHeaderLogo;
  // tabs for pager
  @InjectView(R.id.restaurant_category_tabs) PagerSlidingTabStrip tabStrip;
  // viewpager for swiping between different categories
  @InjectView(R.id.restaurant_menu_pager) ViewPager pager;

  @Inject MyMenuDatabase myMenuDatabase;
  @Inject Picasso picasso;
  @Inject @Named(USER_PREFERENCE) ObjectPreference<User> userPreference;

  // color of the action bar title
  private int actionBarTitleColor;
  // height of the action bar title
  private int actionBarHeight;
  // height of the restaurantHeader read from dimensions, not the view
  private int headerHeight;
  // minimum translation for the sticky effect
  private int minHeaderTranslation;
  // interpolator for smooth animations
  private AccelerateDecelerateInterpolator smoothInterpolator;
  private RectF rectF1 = new RectF();
  private RectF rectF2 = new RectF();
  private AlphaForegroundColorSpan alphaForegroundColorSpan;
  private SpannableString spannableString;
  private TypedValue typedValue = new TypedValue();

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    inflateView(R.layout.activity_restaurant);

    tabStrip.setTextColorResource(android.R.color.white);

    init();
    setupFancyScroll();

    myMenuDatabase.getRestaurantAndMenu(userPreference.get(), restaurantId,
        new EndlessObserver<RestaurantMenu>() {
          @Override public void onNext(RestaurantMenu menu) {
            spannableString = new SpannableString(menu.getRestaurant().businessName);
            picasso.load(menu.getRestaurant().businessPicture)
                .fit()
                .centerCrop()
                .into(restaurantHeaderLogo);
            restaurantHeaderBackground.loadImages(picasso, menu.getRandomMenuItem().picture,
                menu.getRandomMenuItem().picture);
            pager.setAdapter(new MenuCategoryAdapter(getFragmentManager(), menu));
            tabStrip.setViewPager(pager);
          }
        }
    );
  }

  /**
   * Initialize some global variables
   */
  private void init() {
    smoothInterpolator = new AccelerateDecelerateInterpolator();
    headerHeight = getResources().getDimensionPixelSize(R.dimen.restaurant_header_height);
    // we have tabs, so we need twice the space of the actionbar
    minHeaderTranslation = -headerHeight + (2 * getActionBarHeight());
    actionBarTitleColor = getResources().getColor(android.R.color.white);
    alphaForegroundColorSpan = new AlphaForegroundColorSpan(actionBarTitleColor);
  }

  /**
   * Setup the action bar for effects.
   */
  private void setupFancyScroll() {
    getActionBar().setDisplayHomeAsUpEnabled(true);
    getActionBar().setIcon(R.drawable.ic_transparent);
    restaurantHeader.bringToFront(); // explicit, list scrolls behind the header
    restaurantHeaderLogo.bringToFront();
  }

  /**
   * Get the height of the action bar.
   */
  public int getActionBarHeight() {
    if (actionBarHeight != 0) {
      return actionBarHeight;
    }
    getTheme().resolveAttribute(android.R.attr.actionBarSize, typedValue, true);
    actionBarHeight =
        TypedValue.complexToDimensionPixelSize(typedValue.data, getResources().getDisplayMetrics());
    return actionBarHeight;
  }

  @Override public boolean onOptionsItemSelected(MenuItem item) {
    switch (item.getItemId()) {
      case android.R.id.home:
        Intent upIntent = NavUtils.getParentActivityIntent(this);
        if (NavUtils.shouldUpRecreateTask(this, upIntent)) {
          TaskStackBuilder.create(this).addNextIntentWithParentStack(upIntent).startActivities();
        } else {
          NavUtils.navigateUpTo(this, upIntent);
        }
        return true;
      default:
        return super.onOptionsItemSelected(item);
    }
  }

  @Override public void onScrollStateChanged(AbsListView view, int scrollState) {
    // ignore
  }

  @Override public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount,
      int totalItemCount) {
    int scrollY = getScrollY(view);
    restaurantHeader.setTranslationY(Math.max(-scrollY, minHeaderTranslation));
    float ratio = clamp(restaurantHeader.getTranslationY() / minHeaderTranslation, 0.0f, 1.0f);
    interpolate(restaurantHeaderLogo, actionBarIconView,
        smoothInterpolator.getInterpolation(ratio));
    float alpha = clamp(5.0F * ratio - 4.0F, 0.0F, 1.0F);
    setTitleAlpha(alpha);
  }

  public int getScrollY(AbsListView listView) {
    View c = listView.getChildAt(0);
    if (c == null) {
      return 0;
    }

    int firstVisiblePosition = listView.getFirstVisiblePosition();
    int top = c.getTop();

    int headerHeight = 0;
    if (firstVisiblePosition >= 1) {
      headerHeight = ((View) listView.getTag()).getHeight();
    }

    return -top + firstVisiblePosition * c.getHeight() + headerHeight;
  }

  /**
   * Set the alpha value for the action bar title.
   */
  private void setTitleAlpha(float alpha) {
    // spannable string may not be initialized yet, skip until next pass
    if (spannableString != null) {
      alphaForegroundColorSpan.setAlpha(alpha);
      spannableString.setSpan(alphaForegroundColorSpan, 0, spannableString.length(),
          Spannable.SPAN_EXCLUSIVE_EXCLUSIVE);
      getActionBar().setTitle(spannableString);
    }
  }

  /**
   * Standard math clamp method https://en.wikipedia.org/wiki/Clamping_(graphics)
   *
   * @param value value to clamp
   * @param max maximum to return
   * @param min minimum to return
   * @return min if value < min, max if value > max, else value
   */
  public static float clamp(float value, float max, float min) {
    return Math.max(Math.min(value, min), max);
  }

  /**
   * Interpolate between two views.
   * This will animate view1 to somewhere between view1 and view2 dependening on the interpolation
   * value.
   * Used to translate the logo to the action bar icon.
   *
   * @param interpolation 'progress' of the interpolation
   */
  private void interpolate(View view1, View view2, float interpolation) {
    getOnScreenRect(rectF1, view1);
    getOnScreenRect(rectF2, view2);

    float scaleX = 1.0F + interpolation * (rectF2.width() / rectF1.width() - 1.0F);
    float scaleY = 1.0F + interpolation * (rectF2.height() / rectF1.height() - 1.0F);
    float translationX =
        0.5F * (interpolation * (rectF2.left + rectF2.right - rectF1.left - rectF1.right));
    float translationY =
        0.5F * (interpolation * (rectF2.top + rectF2.bottom - rectF1.top - rectF1.bottom));

    view1.setTranslationX(translationX);
    view1.setTranslationY(translationY - restaurantHeader.getTranslationY());
    view1.setScaleX(scaleX);
    view1.setScaleY(scaleY);
  }

  /**
   * Get the position of the view into the given RectF.
   */
  private RectF getOnScreenRect(RectF rect, View view) {
    rect.set(view.getLeft(), view.getTop(), view.getRight(), view.getBottom());
    return rect;
  }

  /**
   * A pager that displays a menu by categories.
   * Each page contains a list of menu items for that particular category.
   */
  class MenuCategoryAdapter extends FragmentPagerAdapter {
    private final RestaurantMenu menu;

    MenuCategoryAdapter(FragmentManager fm, RestaurantMenu menu) {
      super(fm);
      this.menu = menu;
    }

    @Override public int getCount() {
      return menu.getCategoryCount() + 1;
    }

    @Override public Fragment getItem(int position) {
      if (position < menu.getCategoryCount()) {
        return MenuItemsGridFragment.newInstance(menu.getMenuItemsByCategory(position),
            menu.getRestaurant(), menu.getReviews());
      } else {
        return ReviewsFragment.newInstance(menu.getReviews());
      }
    }

    @Override public CharSequence getPageTitle(int position) {
      if (position < menu.getCategoryCount()) {
        return menu.getCategoryTitle(position);
      } else {
        return getString(R.string.reviews);
      }
    }
  }
}
