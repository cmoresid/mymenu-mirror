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
import java.text.NumberFormat;
import java.util.List;

public class MenuItemReviewAdapter extends BindableAdapter<MenuItemReview> {
  final List<MenuItemReview> reviews;

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
    return view;
  }

  @Override public void bindView(MenuItemReview review, int position, View view) {
    ViewHolder holder = (ViewHolder) view.getTag();
    holder.email.setText(review.userEmail);
    holder.review.setText(review.description);
    if (review.rating < 5f) {
      setLeftDrawable(R.drawable.ic_action_emo_shame, holder.email);
    } else {
      setLeftDrawable(R.drawable.ic_action_emo_basic, holder.email);
    }
    holder.rating.setText(NumberFormat.getInstance().format(review.rating));
  }

  void setLeftDrawable(int drawable, TextView target) {
    target.setCompoundDrawablesWithIntrinsicBounds(drawable, 0, 0, 0);
  }

  class ViewHolder {
    @InjectView(R.id.email) TextView email;
    @InjectView(R.id.review) TextView review;
    @InjectView(R.id.like) View like;
    @InjectView(R.id.dislike) View dislike;
    @InjectView(R.id.rating) TextView rating;

    ViewHolder(View root) {
      ButterKnife.inject(this, root);
    }
  }
}