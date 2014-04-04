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
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.graphics.RectF;
import android.graphics.Typeface;
import android.util.AttributeSet;
import android.view.DragEvent;
import android.view.MotionEvent;
import android.view.View;
import ca.mymenuapp.R;

public class RatingWheelView extends View {

  private static final float MAX_RATING = 10f;
  private static final float MIN_RATING = 1f;

  private final RectF tempRect = new RectF();

  private final Paint progressPaint = new Paint();
  private final Paint circlePaint = new Paint();
  private final Paint innerCirclePaint = new Paint();
  private final Paint ratingPaint = new Paint();
  private final Rect textBounds = new Rect();

  private float halfTextWidth;
  private float halfTextHeight;
  private double centerX;
  private double centerY;
  private float rating;

  public RatingWheelView(Context context) {
    super(context);
    init();
  }

  public RatingWheelView(Context context, AttributeSet attrs) {
    super(context, attrs);
    init();
  }

  public RatingWheelView(Context context, AttributeSet attrs, int defStyle) {
    super(context, attrs, defStyle);
    init();
  }

  private void init() {
    circlePaint.setColor(getResources().getColor(R.color.turqoise));
    circlePaint.setAntiAlias(true);
    innerCirclePaint.setColor(0xffffffff);
    innerCirclePaint.setAntiAlias(true);
    progressPaint.setColor(getResources().getColor(R.color.pale_green));
    progressPaint.setAntiAlias(true);
    ratingPaint.setColor(getResources().getColor(R.color.silver));
    ratingPaint.setAntiAlias(true);
    Typeface tf = Typeface.create("Helvetica Neu", Typeface.BOLD);
    ratingPaint.setTypeface(tf);
  }

  @Override protected void onFinishInflate() {
    super.onFinishInflate();
    setRating(1);
  }

  @Override public boolean onTouchEvent(MotionEvent event) {
    //calculateRating(event.getX(), event.getY());
    // Instantiates the drag shadow builder.
    DragShadowBuilder myShadow = new DragShadowBuilder();
    this.startDrag(null,  // the data to be dragged
        myShadow,  // the drag shadow builder
        null,      // no need to use local data
        0          // flags (not currently used, set to 0)
    );
    return super.onTouchEvent(event);
  }

  public void calculateRating(float x, float y) {
    double deltaX = x - this.centerX;
    double deltaY = y - this.centerY;
    double angleRadians = Math.atan(deltaX / deltaY);

    if (angleRadians > Math.PI) {
      angleRadians = Math.PI - angleRadians;
    }

    double degrees = angleRadians * (180.0 / Math.PI);

    // Check which quadrant the touch occured in and adjust
    // the angle appropriately.
    if (x >= centerX && y >= centerY) {
      degrees = degrees + 180.0;
    } else if (x >= centerX) {
      degrees = 270.0 + (90.0 - Math.abs(degrees));
    } else if (y >= centerY) {
      degrees = 90.0 + (90.0 - Math.abs(degrees));
    }

    double percentageOfCircle = (1 - (degrees / 360));
    setRating((float) (percentageOfCircle * 10));

    invalidate();
  }

  @Override protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
    super.onMeasure(widthMeasureSpec, heightMeasureSpec);
    // keep the view square relative to width
    setMeasuredDimension(getMeasuredWidth(), getMeasuredWidth());
  }

  @Override public boolean onDragEvent(DragEvent event) {
    super.onDragEvent(event);
    switch (event.getAction()) {
      case DragEvent.ACTION_DRAG_LOCATION:
        calculateRating(event.getX(), event.getY());
        break;
      default:
        break;
    }
    return true;
  }

  @Override protected void onDraw(Canvas canvas) {
    super.onDraw(canvas);
    centerX = canvas.getWidth() / 2;
    centerY = canvas.getHeight() / 2;

    String ratingText = String.valueOf(Math.round(rating));

    tempRect.set(0, 0, getWidth(), getHeight());
    canvas.drawCircle(tempRect.centerX(), tempRect.centerY(), tempRect.width() / 2, circlePaint);
    canvas.drawArc(tempRect, -90, 360 * rating / MAX_RATING, true, progressPaint);
    canvas.drawCircle(tempRect.centerX(), tempRect.centerY(), tempRect.width() / 4,
        innerCirclePaint);
    ratingPaint.setTextSize(tempRect.height() / 3);

    ratingPaint.getTextBounds(ratingText, 0, ratingText.length(), textBounds);
    halfTextWidth = ratingPaint.measureText(ratingText) / 2; // Use measureText to calculate width
    halfTextHeight = textBounds.height() / 2; // Use height from getTextBounds()
    canvas.drawText(ratingText, tempRect.centerX() - halfTextWidth,
        tempRect.centerY() + halfTextHeight, ratingPaint);
  }

  /**
   * Sets the current progress and maximum progress value, both of which
   * must be valid values.
   */
  public void setRating(float rating) {
    if (rating < MIN_RATING) {
      this.rating = MIN_RATING;
    } else if (rating > MAX_RATING) {
      this.rating = MAX_RATING;
    } else {
      this.rating = rating;
    }
    invalidate();
  }

  public double getRating() {
    return (double) this.rating;
  }
}