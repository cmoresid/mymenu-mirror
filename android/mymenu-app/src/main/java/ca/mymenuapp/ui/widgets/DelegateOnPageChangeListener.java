package ca.mymenuapp.ui.widgets;

import android.support.v4.view.ViewPager;
import ca.mymenuapp.util.CollectionUtils;
import java.util.ArrayList;
import java.util.List;

/**
 * A {@link ViewPager.OnPageChangeListener} that can notify multiple listeners.
 *
 * Used in MainActivity, since we have one listener to enable/disable menu items
 * based on the page (from our SlidingPanel), and one for swiping between tabs (that updates
 * the action bar indicator)
 */
public class DelegateOnPageChangeListener implements ViewPager.OnPageChangeListener {

  private List<ViewPager.OnPageChangeListener> pageChangeListeners;

  public DelegateOnPageChangeListener() {
    pageChangeListeners = new ArrayList<>();
  }

  public void addOnPageChangeListener(ViewPager.OnPageChangeListener listener) {
    pageChangeListeners.add(listener);
  }

  @Override public void onPageScrolled(int position, float positionOffset,
      int positionOffsetPixels) {
    if (!CollectionUtils.isNullOrEmpty(pageChangeListeners)) {
      for (ViewPager.OnPageChangeListener listener : pageChangeListeners) {
        listener.onPageScrolled(position, positionOffset, positionOffsetPixels);
      }
    }
  }

  @Override public void onPageSelected(int position) {
    if (!CollectionUtils.isNullOrEmpty(pageChangeListeners)) {
      for (ViewPager.OnPageChangeListener listener : pageChangeListeners) {
        listener.onPageSelected(position);
      }
    }
  }

  @Override public void onPageScrollStateChanged(int state) {
    if (!CollectionUtils.isNullOrEmpty(pageChangeListeners)) {
      for (ViewPager.OnPageChangeListener listener : pageChangeListeners) {
        listener.onPageScrollStateChanged(state);
      }
    }
  }
}
