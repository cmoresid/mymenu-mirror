package ca.mymenuapp.ui.fragments;

import android.app.DialogFragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import butterknife.ButterKnife;
import butterknife.InjectView;
import butterknife.OnClick;
import ca.mymenuapp.R;
import ca.mymenuapp.data.api.model.MenuItem;
import ca.mymenuapp.ui.activities.BaseActivity;
import ca.mymenuapp.ui.widgets.RatingWheelView;
import com.f2prateek.ln.Ln;

public class WriteReviewFragment extends DialogFragment {


  @InjectView(R.id.write_review_name) TextView itemName;
  @InjectView(R.id.write_review_rating_wheel) RatingWheelView wheel;
  @InjectView(R.id.write_review_text) EditText reviewText;
  @InjectView(R.id.write_review_save) Button saveButton;

  private MenuItem menuItem;

  public WriteReviewFragment() {
  }

  public WriteReviewFragment(MenuItem item){
    this.menuItem = item;
  }

  @Override
  public View onCreateView(LayoutInflater inflater, ViewGroup container,
      Bundle savedInstanceState) {
    return inflater.inflate(R.layout.fragment_write_review, container, false);
  }

  @Override public void onViewCreated(View view, Bundle savedInstanceState) {
    super.onViewCreated(view, savedInstanceState);
    ButterKnife.inject(this,view);
  }
  @Override public void onActivityCreated(Bundle savedInstanceState) {
    super.onActivityCreated(savedInstanceState);
    ((BaseActivity) getActivity()).getActivityGraph().inject(this);
  }

  @Override public void onStart() {
    super.onStart();
    itemName.setText(menuItem.name);
    wheel.setProgressAndMax(10 , 100);

  }

  @OnClick (R.id.write_review_save) void onSaveClicked() {
    /* User has finished writing review.. Do some error checking. */
  }
  @OnClick (R.id.write_review_cancel) void onCancelClicked() {
    this.dismiss();
  }
}
