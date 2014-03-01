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

package ca.mymenuapp.ui.widgets;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.widget.ImageView;
import ca.mymenuapp.R;

public class ForegroundImageView extends ImageView {
  private Drawable foreground;

  public ForegroundImageView(Context context) {
    this(context, null);
  }

  public ForegroundImageView(Context context, AttributeSet attrs) {
    super(context, attrs);

    TypedArray a = context.obtainStyledAttributes(attrs, R.styleable.ForegroundImageView);
    Drawable foreground = a.getDrawable(R.styleable.ForegroundImageView_android_foreground);
    if (foreground != null) {
      setForeground(foreground);
    }
    a.recycle();
  }

  /**
   * Supply a drawable resource that is to be rendered on top of all of the child
   * views in the frame layout.
   *
   * @param drawableResId The drawable resource to be drawn on top of the children.
   */
  public void setForegroundResource(int drawableResId) {
    setForeground(getContext().getResources().getDrawable(drawableResId));
  }

  /**
   * Supply a Drawable that is to be rendered on top of all of the child
   * views in the frame layout.
   *
   * @param drawable The Drawable to be drawn on top of the children.
   */
  public void setForeground(Drawable drawable) {
    if (foreground == drawable) {
      return;
    }
    if (foreground != null) {
      foreground.setCallback(null);
      unscheduleDrawable(foreground);
    }

    foreground = drawable;

    if (drawable != null) {
      drawable.setCallback(this);
      if (drawable.isStateful()) {
        drawable.setState(getDrawableState());
      }
    }
    requestLayout();
    invalidate();
  }

  @Override protected boolean verifyDrawable(Drawable who) {
    return super.verifyDrawable(who) || (who == foreground);
  }

  @Override public void jumpDrawablesToCurrentState() {
    super.jumpDrawablesToCurrentState();
    if (foreground != null) foreground.jumpToCurrentState();
  }

  @Override protected void drawableStateChanged() {
    super.drawableStateChanged();
    if (foreground != null && foreground.isStateful()) {
      foreground.setState(getDrawableState());
    }
  }

  @Override protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
    super.onMeasure(widthMeasureSpec, heightMeasureSpec);
    if (foreground != null) {
      foreground.setBounds(0, 0, getMeasuredWidth(), getMeasuredHeight());
      invalidate();
    }
  }

  @Override protected void onSizeChanged(int w, int h, int oldw, int oldh) {
    super.onSizeChanged(w, h, oldw, oldh);
    if (foreground != null) {
      foreground.setBounds(0, 0, w, h);
      invalidate();
    }
  }

  @Override public void draw(Canvas canvas) {
    super.draw(canvas);
    if (foreground != null) {
      foreground.draw(canvas);
    }
  }
}
