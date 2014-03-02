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

package ca.mymenuapp.ui.activities;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.view.ViewGroup;
import butterknife.ButterKnife;
import ca.mymenuapp.MyMenuApp;
import ca.mymenuapp.dagger.scopes.ForApplication;
import ca.mymenuapp.ui.ActivityModule;
import ca.mymenuapp.ui.AppContainer;
import com.f2prateek.dart.Dart;
import com.squareup.otto.Bus;
import dagger.ObjectGraph;
import javax.inject.Inject;

/**
 * Base Activity for performing operations in all activities.
 * This injects us into the application graph, provides a root view from {@link
 * ca.mymenuapp.ui.AppContainer}, registers itself with the application {@link
 * com.squareup.otto.Bus}, and sets up {@link com.f2prateek.dart.Dart} and
 * {@link butterknife.ButterKnife}.
 */
public class BaseActivity extends Activity {

  @Inject Bus bus;
  @Inject @ForApplication Context applicationContext;
  @Inject AppContainer appContainer;
  private ObjectGraph activityGraph;
  private ViewGroup container;

  @Override protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    activityGraph = ((MyMenuApp) getApplication()).getApplicationGraph().plus(getModules());
    activityGraph.inject(this);

    container = appContainer.get(this, (MyMenuApp) getApplication());

    Dart.inject(this);
  }

  @Override protected void onResume() {
    super.onResume();
    bus.register(this);
  }

  @Override protected void onPause() {
    bus.unregister(this);
    super.onPause();
  }

  public void inflateView(int layoutResourceId) {
    getLayoutInflater().inflate(layoutResourceId, container);
    injectViews();
  }

  private void injectViews() {
    ButterKnife.inject(this);
  }

  public ObjectGraph getActivityGraph() {
    return activityGraph;
  }

  protected Object[] getModules() {
    return new Object[] {
        new ActivityModule(this)
    };
  }
}
