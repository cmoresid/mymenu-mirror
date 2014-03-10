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
import ca.mymenuapp.MyMenuApi;
import ca.mymenuapp.R;
import ca.mymenuapp.data.ForUser;
import ca.mymenuapp.data.api.model.DietaryRestriction;
import ca.mymenuapp.data.api.model.DietaryRestrictionResponse;
import ca.mymenuapp.data.api.model.User;
import ca.mymenuapp.data.api.model.UserRestrictionResponse;
import ca.mymenuapp.data.prefs.ObjectPreference;
import ca.mymenuapp.ui.misc.BindableAdapter;
import ca.mymenuapp.ui.widgets.BetterViewAnimator;
import ca.mymenuapp.util.CollectionUtils;
import com.f2prateek.ln.Ln;
import com.squareup.picasso.Picasso;
import java.util.ArrayList;
import java.util.List;
import javax.inject.Inject;
import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;

/**
 * A {@link ca.mymenuapp.ui.fragments.BaseFragment} that displays dietary preferences and allows
 * them to be toggled on and off.
 * Preferences are toggled by clicking on the item.
 * A grey tile indicates that te user is allergic.
 */
public class DietaryPreferencesFragment extends BaseFragment
    implements AdapterView.OnItemClickListener {

  @Inject MyMenuApi myMenuApi;
  @Inject Picasso picasso;
  @Inject @ForUser ObjectPreference<User> user;

  @InjectView(R.id.root) BetterViewAnimator root;
  @InjectView(R.id.grid) GridView grid;

  BaseAdapter gridAdapter;
  ColorMatrixColorFilter greyScaleFilter;

  @Override public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setHasOptionsMenu(true);

    ColorMatrix matrix = new ColorMatrix();
    matrix.setSaturation(0); //0 means grayscale
    greyScaleFilter = new ColorMatrixColorFilter(matrix);
  }

  @Override
  public View onCreateView(LayoutInflater inflater, ViewGroup container,
      Bundle savedInstanceState) {
    return inflater.inflate(R.layout.fragment_dietary_preferences, container, false);
  }

  @Override public void onResume() {
    super.onResume();
    myMenuApi.getRestrictionsForUser(
        String.format(MyMenuApi.GET_USER_RESTRICTIONS, user.get().email),
        new Callback<UserRestrictionResponse>() {
          @Override
          public void success(UserRestrictionResponse response, Response raw) {
            user.get().restrictions = new ArrayList<>();
            if (response.links != null) {
              for (UserRestrictionResponse.UserRestrictionLink link : response.links) {
                user.get().restrictions.add(link.restrictId);
              }
              user.save();
              if (gridAdapter != null) {
                gridAdapter.notifyDataSetInvalidated();
              }
            }
          }

          @Override public void failure(RetrofitError error) {
            Ln.e(error.getCause());
          }
        }
    );
    myMenuApi.getAllDietaryRestrictions(MyMenuApi.GET_ALL_RESTRICTIONS_QUERY,
        new Callback<DietaryRestrictionResponse>() {
          @Override
          public void success(DietaryRestrictionResponse response, Response raw) {
            initGrid(response.restrictionList);
          }

          @Override public void failure(RetrofitError error) {
            Ln.e(error.getCause());
          }
        }
    );
  }

  private void initGrid(List<DietaryRestriction> restrictionList) {
    root.setDisplayedChildId(R.id.grid);
    gridAdapter = new DietaryRestrictionsAdapter(activityContext, restrictionList);
    grid.setAdapter(gridAdapter);
    grid.setOnItemClickListener(this);
  }

  @Override public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
    if (user.get().restrictions == null) {
      Ln.d("user restrictions not yet ready");
      return;
    }
    if (!user.get().restrictions.contains(id)) {
      user.get().restrictions.add(id);
    } else if (user.get().restrictions.contains(id)) {
      user.get().restrictions.remove(id);
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
        user.save();
        getActivity().setProgressBarIndeterminateVisibility(true);
        // delete all of user's existing restrictions
        myMenuApi.deleteUserRestrictions(
            String.format(MyMenuApi.DELETE_USER_RESTRICTIONS, user.get().email),
            new Callback<Response>() {
              @Override public void success(Response response, Response response2) {
                // Once deleted, insert all of their restrictions back in.
                // todo: do this in one query?
                for (Long id : user.get().restrictions) {
                  myMenuApi.putUserRestriction(user.get().email, id, new Callback<Response>() {
                    @Override public void success(Response response, Response response2) {
                      getActivity().setProgressBarIndeterminateVisibility(false);
                    }

                    @Override public void failure(RetrofitError error) {
                      getActivity().setProgressBarIndeterminateVisibility(false);
                      Ln.e(error.getCause());
                    }
                  });
                }
              }

              @Override public void failure(RetrofitError error) {
                Ln.e(error.getCause());
              }
            }
        );
        return true;
      default:
        return super.onOptionsItemSelected(item);
    }
  }

  class DietaryRestrictionsAdapter extends BindableAdapter<DietaryRestriction> {
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
      return position + 1;
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

      if (!CollectionUtils.isNullOrEmpty(user.get().restrictions)) {
        if (user.get().restrictions.contains(getItemId(position))) {
          holder.picture.setColorFilter(greyScaleFilter);
        } else {
          holder.picture.setColorFilter(null);
        }
      }
    }

    class ViewHolder {
      @InjectView(R.id.picture) ImageView picture;
      @InjectView(R.id.label) TextView label;

      ViewHolder(View root) {
        ButterKnife.inject(this, root);
      }
    }
  }
}
