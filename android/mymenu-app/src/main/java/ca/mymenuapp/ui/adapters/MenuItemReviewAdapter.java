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
import ca.mymenuapp.ui.misc.BindableListAdapter;
import ca.mymenuapp.ui.widgets.OverflowView;
import java.util.List;

public class MenuItemReviewAdapter extends BindableListAdapter<MenuItemReview> {

  private final OnReviewActionClickedListener onReviewActionClickedListener;

  public MenuItemReviewAdapter(Context context, List<MenuItemReview> reviews,
      OnReviewActionClickedListener onReviewActionClickedListener) {
    super(context, reviews);
    this.onReviewActionClickedListener = onReviewActionClickedListener;
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
      setLeftDrawable(R.drawable.ic_emo_shame, holder.email);
    } else {
      setLeftDrawable(R.drawable.ic_emo_basic, holder.email);
    }
    holder.overflow.setListener(new OverflowView.OverflowActionListener() {
      @Override public void onPopupShown() {

      }

      @Override public void onPopupDismissed() {

      }

      @Override public void onActionSelected(int action) {
        onReviewActionClickedListener.onReviewActionClicked(action, review);
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

  // tiny abstraction so parent doesn't have to look up the review
  public interface OnReviewActionClickedListener {
    void onReviewActionClicked(int action, MenuItemReview review);
  }
}