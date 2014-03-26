package ca.mymenuapp.ui.widgets;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.RectF;
import android.util.AttributeSet;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
import android.widget.TextView;
import ca.mymenuapp.R;
import java.text.NumberFormat;

public class RatingWheelView extends View{

  private final RectF tempRect = new RectF();

  private final Paint progressPaint = new Paint();
  private final Paint circlePaint = new Paint();
  private final Paint innerCirclePaint = new Paint();
  private final Paint ratingPaint = new Paint();
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
    return super.onTouchEvent(event);
  }

  private void init() {
    circlePaint.setColor(getResources().getColor(R.color.turqoise));
    circlePaint.setAntiAlias(true);
    innerCirclePaint.setColor(0xffffffff);
    progressPaint.setColor(getResources().getColor(R.color.pale_green));
    progressPaint.setAntiAlias(true);
    rating = 1;
    ratingPaint.setColor(getResources().getColor(R.color.storm_dust));
    ratingPaint.setTextSize(20);
    max = 100;
  }

  @Override protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
    super.onMeasure(widthMeasureSpec, heightMeasureSpec);
    // keep the view square
    int size = Math.min(getMeasuredWidth(), getMeasuredHeight());
    setMeasuredDimension(size, size);
  }

  @Override protected void onDraw(Canvas canvas) {
    tempRect.set(0, 0, getWidth(), getHeight());
    canvas.drawCircle(tempRect.centerX(), tempRect.centerY(), tempRect.width() / 2, circlePaint);
    canvas.drawArc(tempRect, -90, 360 * rating / max, true, progressPaint);
    canvas.drawCircle(tempRect.centerX(), tempRect.centerY(), tempRect.width() / 4,
        innerCirclePaint);
    canvas.drawText(progressText,tempRect.centerX(),tempRect.centerY(),ratingPaint);
    super.onDraw(canvas);
  }

  /**
   * Sets the current progress and maximum progress value, both of which
   * must be valid values.
   */
  public void setProgressAndMax(int progress, int max) {
    progress = progress > max ? max : progress; // don't let progress be greater than max
    this.rating = progress;
    this.max = max;
    progressText = Integer.toString(progress);
    invalidate();
  }

}
