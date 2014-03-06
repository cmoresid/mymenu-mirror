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

package ca.mymenuapp.ui.fragments;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.Toast;
import butterknife.ButterKnife;
import butterknife.InjectView;
import ca.mymenuapp.MyMenuApi;
import ca.mymenuapp.R;
import ca.mymenuapp.data.api.model.DietaryRestriction;
import ca.mymenuapp.data.api.model.DietaryRestrictionResponse;
import ca.mymenuapp.ui.misc.BindableAdapter;
import ca.mymenuapp.ui.widgets.BetterViewAnimator;
import com.f2prateek.ln.Ln;
import com.squareup.picasso.Picasso;
import java.util.List;
import javax.inject.Inject;
import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;

/**
 * A {@link ca.mymenuapp.ui.fragments.BaseFragment} that displays dietary preferences and allows
 * them to be toggled on and off.
 */
public class DietaryPreferencesFragment extends BaseFragment {

  @Inject MyMenuApi myMenuApi;
  @Inject Picasso picasso;
  @InjectView(R.id.root) BetterViewAnimator root;
  @InjectView(R.id.grid) GridView grid;

  @Override
  public View onCreateView(LayoutInflater inflater, ViewGroup container,
      Bundle savedInstanceState) {
    return inflater.inflate(R.layout.fragment_dietary_preferences, container, false);
  }

  @Override public void onResume() {
    super.onResume();
    myMenuApi.getAllDietaryRestrictions(MyMenuApi.GET_ALL_RESTRICTIONS_QUERY,
        new Callback<DietaryRestrictionResponse>() {
          @Override
          public void success(DietaryRestrictionResponse response, Response raw) {
            root.setDisplayedChildId(R.id.grid);
            grid.setAdapter(
                new DietaryRestrictionsAdapter(activityContext, response.restrictionList));
          }

          @Override public void failure(RetrofitError error) {
            Ln.e(error.getCause());
          }
        });
  }

  class DietaryRestrictionsAdapter extends BindableAdapter<DietaryRestriction>
      implements CompoundButton.OnCheckedChangeListener {
    private final List<DietaryRestriction> dietaryRestrictions;

    public DietaryRestrictionsAdapter(Context context,
        List<DietaryRestriction> dietaryRestrictions) {
      super(context);
      this.dietaryRestrictions = dietaryRestrictions;
    }

    @Override public int getCount() {
      return dietaryRestrictions.size();
    }

    @Override public DietaryRestriction getItem(int position) {
      return dietaryRestrictions.get(position);
    }

    @Override public long getItemId(int position) {
      return position;
    }

    @Override public View newView(LayoutInflater inflater, int position, ViewGroup container) {
      View view = inflater.inflate(R.layout.adapter_dietary_restrictions, container, false);
      ViewHolder holder = new ViewHolder(view);
      view.setTag(holder);
      return view;
    }

    @Override public void bindView(DietaryRestriction item, int position, View view) {
      ViewHolder holder = (ViewHolder) view.getTag();
      DietaryPreferencesFragment.this.picasso.load(item.picture)
          .placeholder(R.drawable.ic_launcher)
          .fit()
          .centerCrop()
          .into(holder.picture);
      holder.toggle.setText(item.userLabel);
      holder.toggle.setOnCheckedChangeListener(this);
    }

    @Override public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
      Toast.makeText(activityContext, "Selected", Toast.LENGTH_SHORT).show();
    }

    class ViewHolder {
      @InjectView(R.id.picture) ImageView picture;
      @InjectView(R.id.toggle) CheckBox toggle;

      ViewHolder(View root) {
        ButterKnife.inject(this, root);
      }
    }
  }
}
