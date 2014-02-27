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
import android.view.View;
import android.view.ViewGroup;
import butterknife.ButterKnife;
import ca.mymenuapp.MyMenuApplication;
import ca.mymenuapp.dagger.ActivityModule;
import ca.mymenuapp.dagger.scopes.ForApplication;
import com.f2prateek.dart.Dart;
import com.squareup.otto.Bus;
import dagger.ObjectGraph;
import javax.inject.Inject;

/**
 * Do not extend from this, extend from BaseActivity instead, which lets us configure build type
 * specific stuff.
 */
public class AbsActivity extends Activity {

  private ObjectGraph activityGraph;
  @Inject Bus bus;
  @Inject @ForApplication Context applicationContext;

  @Override protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    activityGraph = ((MyMenuApplication) getApplication()).getApplicationGraph().plus(getModules());
    activityGraph.inject(this);

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

  @Override public void setContentView(int layoutResID) {
    super.setContentView(layoutResID);
    injectViews();
  }

  @Override public void setContentView(View view) {
    super.setContentView(view);
    injectViews();
  }

  @Override public void setContentView(View view, ViewGroup.LayoutParams params) {
    super.setContentView(view, params);
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
