package ca.mymenuapp.ui.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import butterknife.ButterKnife;
import butterknife.InjectView;
import ca.mymenuapp.R;
import ca.mymenuapp.data.api.model.MenuItemReview;
import ca.mymenuapp.ui.misc.BindableAdapter;
import ca.mymenuapp.ui.widgets.OverflowView;
import com.f2prateek.ln.Ln;
import java.util.List;

public class MenuItemReviewAdapter extends BindableAdapter<MenuItemReview> {

  final List<MenuItemReview> reviews;
  MenuItemReview selected;

  public MenuItemReviewAdapter(Context context, List<MenuItemReview> reviews) {
    super(context);
    this.reviews = reviews;
  }

  @Override public int getCount() {
    return reviews.size();
  }

  @Override public MenuItemReview getItem(int position) {
    return reviews.get(position);
  }

  @Override public long getItemId(int position) {
    return getItem(position).id;
  }

  @Override public View newView(LayoutInflater inflater, int position, ViewGroup container) {
    View view = inflater.inflate(R.layout.adapter_review_menu_item, container, false);
    ViewHolder viewHolder = new ViewHolder(view);
    view.setTag(viewHolder);
    viewHolder.overflow.addItem(R.id.like, R.string.like);
    viewHolder.overflow.addItem(R.id.dislike, R.string.dislike);
    viewHolder.overflow.addItem(R.id.spam, R.string.spam);
    return view;
  }

  @Override public void bindView(final MenuItemReview review, int position, View view) {
    ViewHolder holder = (ViewHolder) view.getTag();
    holder.email.setText(review.userEmail);
    holder.review.setText(review.description);
    if (review.rating < 5f) {
      setLeftDrawable(R.drawable.ic_action_emo_shame, holder.email);
    } else {
      setLeftDrawable(R.drawable.ic_action_emo_basic, holder.email);
    }
    holder.overflow.setListener(new OverflowView.OverflowActionListener() {
      @Override public void onPopupShown() {

      }

      @Override public void onPopupDismissed() {

      }

      @Override public void onActionSelected(int action) {
        Ln.d("selected action %d for item %s", action, review);
      }
    });
  }

  void setLeftDrawable(int drawable, TextView target) {
    target.setCompoundDrawablesWithIntrinsicBounds(drawable, 0, 0, 0);
  }

  class ViewHolder {
    @InjectView(R.id.email) TextView email;
    @InjectView(R.id.review) TextView review;
    @InjectView(R.id.overflow) OverflowView overflow;
    @InjectView(R.id.rating) TextView rating;

    ViewHolder(View root) {
      ButterKnife.inject(this, root);
    }
  }

  public interface OnReviewActionClickedListener {
    void onReviewActionClicked(int action, MenuItemReview itemReview);
  }
}