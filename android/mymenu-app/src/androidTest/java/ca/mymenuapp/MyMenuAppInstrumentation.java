package ca.mymenuapp;

import android.app.Application;
import android.content.Context;
import android.content.SharedPreferences;
import ca.mymenuapp.data.ApiEndpoints;
import ca.mymenuapp.data.DebugDataModule;
import com.google.android.apps.common.testing.testrunner.GoogleInstrumentation;

public class MyMenuAppInstrumentation extends GoogleInstrumentation {

  @Override public void callApplicationOnCreate(Application app) {
    // explicitly set mock mode
    SharedPreferences preferences =
        app.getSharedPreferences(BuildConfig.PACKAGE_NAME, Context.MODE_PRIVATE);
    preferences.edit().putString(DebugDataModule.DEBUG_API_ENDPOINT, ApiEndpoints.MOCK_MODE.url);

    super.callApplicationOnCreate(app);
  }
}
