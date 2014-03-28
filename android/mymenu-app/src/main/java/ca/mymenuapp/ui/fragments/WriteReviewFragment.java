package ca.mymenuapp.ui.fragments;

import android.app.DialogFragment;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.EditText;
import android.widget.Toast;
import butterknife.ButterKnife;
import butterknife.InjectView;
import butterknife.OnClick;
import ca.mymenuapp.R;
import ca.mymenuapp.data.MyMenuDatabase;
import ca.mymenuapp.data.api.model.MenuItem;
import ca.mymenuapp.data.api.model.MenuItemReview;
import ca.mymenuapp.data.api.model.User;
import ca.mymenuapp.data.prefs.ObjectPreference;
import ca.mymenuapp.data.rx.EndlessObserver;
import ca.mymenuapp.ui.activities.BaseActivity;
import ca.mymenuapp.ui.widgets.RatingWheelView;
import javax.inject.Inject;
import javax.inject.Named;
import retrofit.client.Response;

import static ca.mymenuapp.data.DataModule.USER_PREFERENCE;

public class WriteReviewFragment extends DialogFragment {

  @InjectView(R.id.write_review_rating_wheel) RatingWheelView wheel;
  @InjectView(R.id.write_review_text) EditText reviewText;

  @Inject MyMenuDatabase myMenuDatabase;
  @Inject @Named(USER_PREFERENCE) ObjectPreference<User> userPreference;

  private MenuItem menuItem;

  public WriteReviewFragment() {
  }

  public WriteReviewFragment(MenuItem item) {
    this.menuItem = item;
  }

  @Override
  public View onCreateView(LayoutInflater inflater, ViewGroup container,
      Bundle savedInstanceState) {
    return inflater.inflate(R.layout.fragment_write_review, container, false);
  }

  @Override public void onViewCreated(View view, Bundle savedInstanceState) {
    super.onViewCreated(view, savedInstanceState);
    getDialog().getWindow().requestFeature(Window.FEATURE_NO_TITLE);
    ButterKnife.inject(this, view);
  }

  @Override public void onActivityCreated(Bundle savedInstanceState) {
    super.onActivityCreated(savedInstanceState);
    ((BaseActivity) getActivity()).getActivityGraph().inject(this);
  }

  @Override public void onStart() {
    super.onStart();
  }

  @OnClick(R.id.actionbar_save) void onSaveClicked() {
    /* User has finished writing review.. Do some error checking. */
    MenuItemReview review = new MenuItemReview();
    User user = userPreference.get();

    if (reviewText.getText().toString().isEmpty()) {
      reviewText.setError(getString(R.string.required));
    } else {
      review.rating = wheel.getRating();
      review.userEmail = user.email;
      review.menuId = menuItem.id;
      review.merchId = menuItem.merchantId;
      review.description = reviewText.getText().toString();

      myMenuDatabase.addRating(review, new EndlessObserver<Response>() {
        @Override public void onNext(Response response) {
        }
      });
      Toast.makeText(getActivity(), "Review Saved.", Toast.LENGTH_LONG).show();
      dismiss();
    }
  }

  @OnClick(R.id.actionbar_cancel) void onCancelClicked() {
    dismiss();
  }
}
