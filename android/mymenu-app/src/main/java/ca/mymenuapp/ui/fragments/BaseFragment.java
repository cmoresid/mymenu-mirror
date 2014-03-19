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

import android.app.Fragment;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import butterknife.ButterKnife;
import ca.mymenuapp.dagger.scopes.ForActivity;
import ca.mymenuapp.dagger.scopes.ForApplication;
import ca.mymenuapp.ui.activities.BaseActivity;
import com.f2prateek.dart.Dart;
import com.squareup.otto.Bus;
import javax.inject.Inject;

/**
 * Base Fragment for performing operations in all fragments.
 * This injects us into the activity graph provided by
 * {@link ca.mymenuapp.ui.activities.BaseActivity}, registers itself with the application
 * {@link com.squareup.otto.Bus}, and sets up {@link com.f2prateek.dart.Dart} and
 * {@link butterknife.ButterKnife}.
 *
 * Injection isn't done until after {@link #onActivityCreated(android.os.Bundle)}, so don't
 * call dependencies before then.
 */
public class BaseFragment extends Fragment {

  @Inject Bus bus;
  @Inject @ForActivity Context activityContext;
  @Inject @ForApplication Context applicationContext;

  @Override public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    Dart.inject(this);
  }

  @Override public void onActivityCreated(Bundle savedInstanceState) {
    super.onActivityCreated(savedInstanceState);
    ((BaseActivity) getActivity()).getActivityGraph().inject(this);
  }

  @Override public void onViewCreated(View view, Bundle savedInstanceState) {
    super.onViewCreated(view, savedInstanceState);
    ButterKnife.inject(this, view);
  }

  @Override public void onResume() {
    super.onResume();
    bus.register(this);
  }

  @Override public void onPause() {
    bus.unregister(this);
    super.onPause();
  }
}
