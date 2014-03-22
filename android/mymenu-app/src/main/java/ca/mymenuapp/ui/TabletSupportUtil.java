package ca.mymenuapp.ui;

import android.content.Context;
import ca.mymenuapp.R;

public class TabletSupportUtil {

  private final boolean isTablet;
  private final boolean isSevenInch;
  private final boolean isTenInch;

  public TabletSupportUtil(Context context) {
    isTablet = !context.getResources().getBoolean(R.bool.is_phone);
    isSevenInch = context.getResources().getBoolean(R.bool.is_seven_inch);
    isTenInch = context.getResources().getBoolean(R.bool.is_ten_inch);
  }

  public boolean isTablet() {
    return isTablet;
  }

  public boolean isSevenInch() {
    return isSevenInch;
  }

  public boolean isTenInch() {
    return isTenInch;
  }
}
