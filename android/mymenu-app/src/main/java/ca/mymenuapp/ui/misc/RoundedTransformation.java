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

import android.graphics.Bitmap;
import android.graphics.Bitmap.Config;
import android.graphics.BitmapShader;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RectF;
import android.graphics.Shader;

// enables hardware accelerated rounded corners
// original idea here :
// http://www.curious-creature.org/2012/12/11/android-recipe-1-image-with-rounded-corners/
// currently unused, save for when profiles have images.
public class RoundedTransformation implements com.squareup.picasso.Transformation {
  private final int radius;
  private final int margin;  // dp

  // radius is corner radii in dp
  // margin is the board in dp
  public RoundedTransformation(final int radius, final int margin) {
    this.radius = radius;
    this.margin = margin;
  }

  @Override
  public Bitmap transform(final Bitmap source) {
    final Paint paint = new Paint();
    paint.setAntiAlias(true);
    paint.setShader(new BitmapShader(source, Shader.TileMode.CLAMP, Shader.TileMode.CLAMP));

    Bitmap output = Bitmap.createBitmap(source.getWidth(), source.getHeight(), Config.ARGB_8888);
    Canvas canvas = new Canvas(output);
    canvas.drawRoundRect(
        new RectF(margin, margin, source.getWidth() - margin, source.getHeight() - margin), radius,
        radius, paint);

    if (source != output) {
      source.recycle();
    }

    return output;
  }

  @Override
  public String key() {
    return "rounded";
  }
}
