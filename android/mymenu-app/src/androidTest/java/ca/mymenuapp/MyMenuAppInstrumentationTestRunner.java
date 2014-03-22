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
import android.app.KeyguardManager;
import android.content.Context;
import android.content.SharedPreferences;
import android.os.PowerManager;
import ca.mymenuapp.data.ApiEndpoints;
import ca.mymenuapp.data.DebugDataModule;
import com.google.android.apps.common.testing.testrunner.GoogleInstrumentationTestRunner;

import static android.content.Context.KEYGUARD_SERVICE;
import static android.content.Context.POWER_SERVICE;
import static android.os.PowerManager.ACQUIRE_CAUSES_WAKEUP;
import static android.os.PowerManager.FULL_WAKE_LOCK;
import static android.os.PowerManager.ON_AFTER_RELEASE;

public class MyMenuAppInstrumentationTestRunner extends GoogleInstrumentationTestRunner {

  @Override public void onStart() {
    runOnMainSync(new Runnable() {
      @Override public void run() {
        Application app = (Application) getTargetContext().getApplicationContext();
        String simpleName = MyMenuAppInstrumentationTestRunner.class.getSimpleName();

        // Unlock the device so that the tests can input keystrokes.
        ((KeyguardManager) app.getSystemService(KEYGUARD_SERVICE)) //
            .newKeyguardLock(simpleName) //
            .disableKeyguard();
        // Wake up the screen.
        ((PowerManager) app.getSystemService(POWER_SERVICE)) //
            .newWakeLock(FULL_WAKE_LOCK | ACQUIRE_CAUSES_WAKEUP | ON_AFTER_RELEASE, simpleName) //
            .acquire();
      }
    });

    super.onStart();
  }

  @Override public void callApplicationOnCreate(Application app) {
    // explicitly set mock mode and seen drawer
    SharedPreferences preferences =
        app.getSharedPreferences(BuildConfig.PACKAGE_NAME, Context.MODE_PRIVATE);
    preferences.edit()
        .putString(DebugDataModule.DEBUG_API_ENDPOINT, ApiEndpoints.MOCK_MODE.url)
        .putBoolean(DebugDataModule.DEBUG_DRAWER_SEEN, true)
        .commit();

    super.callApplicationOnCreate(app);
  }
}
