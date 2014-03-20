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
import android.graphics.ColorMatrix;
import android.graphics.ColorMatrixColorFilter;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.BaseAdapter;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.TextView;
import butterknife.ButterKnife;
import butterknife.InjectView;
import ca.mymenuapp.R;
import ca.mymenuapp.data.MyMenuDatabase;
import ca.mymenuapp.data.api.model.DietaryRestriction;
import ca.mymenuapp.data.api.model.User;
import ca.mymenuapp.data.prefs.ObjectPreference;
import ca.mymenuapp.data.rx.EndlessObserver;
import ca.mymenuapp.ui.misc.BindableListAdapter;
import ca.mymenuapp.ui.widgets.BetterViewAnimator;
import ca.mymenuapp.util.CollectionUtils;
import com.f2prateek.ln.Ln;
import com.squareup.picasso.Picasso;
import java.util.List;
import javax.inject.Inject;
import javax.inject.Named;
import retrofit.client.Response;

import static ca.mymenuapp.data.DataModule.USER_PREFERENCE;

/**
 * A {@link ca.mymenuapp.ui.fragments.BaseFragment} that displays dietary preferences and allows
 * them to be toggled on and off.
 * Preferences are toggled by clicking on the item.
 * A grey tile indicates that te userPreference is allergic.
 */
public class DietaryPreferencesFragment extends BaseFragment
    implements AdapterView.OnItemClickListener {

  @Inject MyMenuDatabase myMenuDatabase;
  @Inject Picasso picasso;
  @Inject @Named(USER_PREFERENCE) ObjectPreference<User> userPreference;

  @InjectView(R.id.root) BetterViewAnimator root;
  @InjectView(R.id.grid) GridView grid;

  BaseAdapter gridAdapter;

  @Override public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setHasOptionsMenu(true);
  }

  @Override
  public View onCreateView(LayoutInflater inflater, ViewGroup container,
      Bundle savedInstanceState) {
    return inflater.inflate(R.layout.fragment_dietary_preferences, container, false);
  }

  @Override public void onStart() {
    super.onStart();
    updateRestrictions();
    updateUserPreferences();
  }

  private void updateRestrictions() {
    myMenuDatabase.getAllRestrictions(new EndlessObserver<List<DietaryRestriction>>() {
          @Override public void onNext(List<DietaryRestriction> dietaryRestrictions) {
            initGrid(dietaryRestrictions);
          }
        }
    );
  }

  private void updateUserPreferences() {
    myMenuDatabase.getUserRestrictions(userPreference.get(), new EndlessObserver<List<Long>>() {
      @Override public void onNext(List<Long> dietaryRestrictionIds) {
        userPreference.get().restrictions = dietaryRestrictionIds;
        userPreference.save();
        if (gridAdapter != null) {
          gridAdapter.notifyDataSetInvalidated();
        }
      }
    });
  }

  private void initGrid(List<DietaryRestriction> restrictionList) {
    root.setDisplayedChildId(R.id.grid);
    gridAdapter = new DietaryRestrictionsAdapter(activityContext, restrictionList);
    grid.setAdapter(gridAdapter);
    grid.setOnItemClickListener(this);
  }

  @Override public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
    if (userPreference.get().restrictions == null) {
      Ln.d("userPreference restrictions not yet ready");
      return;
    }
    if (!userPreference.get().restrictions.contains(id)) {
      userPreference.get().restrictions.add(id);
    } else if (userPreference.get().restrictions.contains(id)) {
      userPreference.get().restrictions.remove(id);
    }
    gridAdapter.notifyDataSetInvalidated();
  }

  @Override public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
    super.onCreateOptionsMenu(menu, inflater);
    inflater.inflate(R.menu.fragment_dietary_preferences, menu);
  }

  @Override public boolean onOptionsItemSelected(MenuItem item) {
    switch (item.getItemId()) {
      case R.id.save:
        // save this locally
        userPreference.save();
        getActivity().setProgressBarIndeterminateVisibility(true);
        // delete all of userPreference's existing restrictions
        myMenuDatabase.deleteUserRestrictions(userPreference.get(),
            new EndlessObserver<Response>() {
              @Override public void onNext(Response response) {
                Ln.d("Deleted preferences.");
                myMenuDatabase.updateUserRestrictions(userPreference.get(),
                    new EndlessObserver<List<Response>>() {
                      @Override public void onNext(List<Response> response) {
                        getActivity().setProgressBarIndeterminateVisibility(false);
                        Ln.d("Updated %d preferences.", response.size());
                      }
                    }
                );
              }
            }
        );
        return true;
      default:
        return super.onOptionsItemSelected(item);
    }
  }

  class DietaryRestrictionsAdapter extends BindableListAdapter<DietaryRestriction> {
    private final ColorMatrixColorFilter greyScaleFilter;

    public DietaryRestrictionsAdapter(Context context,
        List<DietaryRestriction> dietaryRestrictions) {
      super(context, dietaryRestrictions);

      ColorMatrix matrix = new ColorMatrix();
      matrix.setSaturation(0); //0 means grayscale
      greyScaleFilter = new ColorMatrixColorFilter(matrix);
    }

    @Override public long getItemId(int position) {
      return getItem(position).id;
    }

    @Override public View newView(LayoutInflater inflater, int position, ViewGroup container) {
      View view = inflater.inflate(R.layout.adapter_dietary_preferences, container, false);
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
      holder.label.setText(item.userLabel);

      if (!CollectionUtils.isNullOrEmpty(userPreference.get().restrictions)) {
        if (userPreference.get().restrictions.contains(getItemId(position))) {
          holder.picture.setColorFilter(greyScaleFilter);
        } else {
          holder.picture.setColorFilter(null);
        }
      }
    }

    class ViewHolder {
      @InjectView(R.id.restriction_picture) ImageView picture;
      @InjectView(R.id.restriction_label) TextView label;

      ViewHolder(View root) {
        ButterKnife.inject(this, root);
      }
    }
  }
}