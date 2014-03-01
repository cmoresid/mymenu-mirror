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

package ca.mymenuapp.ui;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;

/** A "view server" adaptation which automatically hooks itself up to all activities. */
public interface ActivityHierarchyServer extends Application.ActivityLifecycleCallbacks {
  /** An {@link ActivityHierarchyServer} which does nothing. */
  ActivityHierarchyServer NONE = new ActivityHierarchyServer() {
    @Override public void onActivityCreated(Activity activity, Bundle bundle) {
    }

    @Override public void onActivityStarted(Activity activity) {
    }

    @Override public void onActivityResumed(Activity activity) {
    }

    @Override public void onActivityPaused(Activity activity) {
    }

    @Override public void onActivityStopped(Activity activity) {
    }

    @Override public void onActivitySaveInstanceState(Activity activity, Bundle bundle) {
    }

    @Override public void onActivityDestroyed(Activity activity) {
    }
  };
}
