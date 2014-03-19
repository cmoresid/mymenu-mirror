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

package ca.mymenuapp.ui.misc;

import android.graphics.Color;
import android.os.Parcel;
import android.text.TextPaint;
import android.text.style.ForegroundColorSpan;

public class AlphaForegroundColorSpan extends ForegroundColorSpan {

  private float mAlpha;

  public AlphaForegroundColorSpan(int color) {
    super(color);
  }

  public AlphaForegroundColorSpan(Parcel src) {
    super(src);
    mAlpha = src.readFloat();
  }

  public void writeToParcel(Parcel dest, int flags) {
    super.writeToParcel(dest, flags);
    dest.writeFloat(mAlpha);
  }

  @Override
  public void updateDrawState(TextPaint ds) {
    ds.setColor(getAlphaColor());
  }

  public void setAlpha(float alpha) {
    mAlpha = alpha;
  }

  public float getAlpha() {
    return mAlpha;
  }

  private int getAlphaColor() {
    int foregroundColor = getForegroundColor();
    return Color.argb((int) (mAlpha * 255), Color.red(foregroundColor),
        Color.green(foregroundColor), Color.blue(foregroundColor));
  }
}
