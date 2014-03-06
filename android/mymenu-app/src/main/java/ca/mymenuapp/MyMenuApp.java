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

package ca.mymenuapp;

import android.app.Application;
import android.content.Intent;
import ca.mymenuapp.data.ForUser;
import ca.mymenuapp.data.api.model.User;
import ca.mymenuapp.data.prefs.ObjectPreference;
import ca.mymenuapp.ui.activities.LoginActivity;
import com.f2prateek.ln.DebugLn;
import com.f2prateek.ln.Ln;
import dagger.ObjectGraph;
import hugo.weaving.DebugLog;
import javax.inject.Inject;

/**
 * Custom {@link android.app.Application} instance.
 * Sets up an {@link dagger.ObjectGraph} which is shared by the entire application.
 * Also configures {@link com.f2prateek.ln.Ln}.
 */
public class MyMenuApp extends Application {

  @Inject @ForUser ObjectPreference<User> user;
  private ObjectGraph applicationGraph;

  @Override public void onCreate() {
    super.onCreate();

    buildApplicationGraphAndInject();

    if (BuildConfig.DEBUG) {
      Ln.set(DebugLn.from(this));
    } else {
      // Crashlytics.start(this);
      // Ln.set(new CrashlyticsLn());
    }
  }

  @DebugLog
  public void buildApplicationGraphAndInject() {
    applicationGraph = ObjectGraph.create(Modules.list(this));
    applicationGraph.inject(this);
    if (user.get() == null) {
      Intent intent = new Intent(this, LoginActivity.class);
      intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      startActivity(intent);
    }
  }

  public ObjectGraph getApplicationGraph() {
    return applicationGraph;
  }
}
