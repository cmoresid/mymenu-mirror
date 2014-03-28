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
import android.widget.TextView;
import ca.mymenuapp.R;
import com.f2prateek.ln.Ln;

public class RatingWheelView extends View {

  private final RectF tempRect = new RectF();

  private final Paint progressPaint = new Paint();
  private final Paint circlePaint = new Paint();
  private final Paint innerCirclePaint = new Paint();
  private final Paint ratingPaint = new Paint();
  private float halfTextWidth;
  private float halfTextHeight;
  private double centerX;
  private double centerY;
  private boolean isSet;
  private TextView ratingValue;

  private int rating;
  private int max;
  private String progressText;

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
    if (isSet) {
      double deltaX = x - this.centerX;
      double deltaY = y - this.centerY;
      double angleRadians = Math.atan(deltaX / deltaY);

      if (angleRadians > 3.1415) angleRadians = 3.1415 - angleRadians;

      double degrees = angleRadians * (180.0 / 3.1415);

      // Check which quadrant the touch occured in and adjust
      // the angle appropriately.
      if (x >= centerX && y >= centerY) {
        degrees = degrees + 180.0;
      } else if (x >= centerX) {
        degrees = 270.0 + (90.0 - Math.abs(degrees));
      } else if (y >= centerY) {
        degrees = 90.0 + (90.0 - Math.abs(degrees));
      }

      double percentageOfCircle = (1 - (degrees / 360.0));
      int finalrating = (int) Math.round(percentageOfCircle * 10);

      setRating(finalrating);
    } else {
      Ln.e("Center was not set so input was not dealt with");
    }
    invalidate();
  }

  private void init() {
    circlePaint.setColor(getResources().getColor(R.color.turqoise));
    circlePaint.setAntiAlias(true);
    innerCirclePaint.setColor(0xffffffff);
    progressPaint.setColor(getResources().getColor(R.color.pale_green));
    progressPaint.setAntiAlias(true);
    ratingPaint.setColor(getResources().getColor(R.color.silver));
    Typeface tf = Typeface.create("Helvetica Neu", Typeface.BOLD);
    ratingPaint.setTypeface(tf);
    max = 10;
    setRating(1);
  }

  @Override protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
    super.onMeasure(widthMeasureSpec, heightMeasureSpec);
    // keep the view square
    int size = Math.min(getMeasuredWidth(), getMeasuredHeight());
    setMeasuredDimension(size, size);
  }

  @Override public boolean onDragEvent(DragEvent event) {
    super.onDragEvent(event);
    switch (event.getAction()) {
      case DragEvent.ACTION_DRAG_LOCATION:
        calculateRating(event.getX(), event.getY());
      default:
        break;
    }
    return true;
  }

  @Override protected void onDraw(Canvas canvas) {
    super.onDraw(canvas);
    if (!isSet) {
      centerX = canvas.getWidth() / 2;
      centerY = canvas.getHeight() / 2;
      isSet = true;
    }
    if (progressText.equals("0") || rating == 0) {
      progressText = "1";
      rating = 1;
    }
    tempRect.set(0, 0, getWidth(), getHeight());
    canvas.drawCircle(tempRect.centerX(), tempRect.centerY(), tempRect.width() / 2, circlePaint);
    canvas.drawArc(tempRect, -90, 360 * rating / max, true, progressPaint);
    canvas.drawCircle(tempRect.centerX(), tempRect.centerY(), tempRect.width() / 4,
        innerCirclePaint);
    ratingPaint.setTextSize(tempRect.height() / 3);

    Rect textBounds = new Rect();
    ratingPaint.getTextBounds(progressText, 0, progressText.length(), textBounds);
    halfTextWidth = ratingPaint.measureText(progressText) / 2; // Use measureText to calculate width
    halfTextHeight = textBounds.height() / 2; // Use height from getTextBounds()

    canvas.drawText(progressText, tempRect.centerX() - halfTextWidth,
        tempRect.centerY() + halfTextHeight, ratingPaint);
  }

  /**
   * Sets the current progress and maximum progress value, both of which
   * must be valid values.
   */
  public void setRating(int rating) {
    rating = rating > max ? max : rating; // don't let progress be greater than max
    this.rating = rating;
    progressText = Integer.toString(rating);
    invalidate();
  }

  public double getRating() {
    return (double) this.rating;
  }
}
