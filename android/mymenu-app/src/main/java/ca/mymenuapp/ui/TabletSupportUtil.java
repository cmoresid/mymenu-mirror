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
