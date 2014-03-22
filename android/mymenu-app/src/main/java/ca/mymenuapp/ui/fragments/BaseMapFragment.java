/*
 * Copyright 2014 Prateek Srivastava (@f2prateek)
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

package ca.mymenuapp.ui.fragments;

import android.content.Context;
import android.os.Bundle;
import android.view.View;
import butterknife.ButterKnife;
import ca.mymenuapp.dagger.scopes.ForActivity;
import ca.mymenuapp.dagger.scopes.ForApplication;
import ca.mymenuapp.ui.activities.BaseActivity;
import com.f2prateek.dart.Dart;
import com.google.android.gms.maps.MapFragment;
import com.squareup.otto.Bus;
import javax.inject.Inject;

/**
 * Base Fragment for performing operations in all map fragments.
 * Same as {@link ca.mymenuapp.ui.fragments.BaseFragment}
 */
public class BaseMapFragment extends MapFragment {

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
