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
