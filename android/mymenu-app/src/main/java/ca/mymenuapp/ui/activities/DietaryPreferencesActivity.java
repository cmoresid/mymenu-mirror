package ca.mymenuapp.ui.activities;

import android.os.Bundle;
import ca.mymenuapp.R;
import ca.mymenuapp.ui.fragments.DietaryPreferencesFragment;

public class DietaryPreferencesActivity extends BaseActivity {

  @Override protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    inflateView(R.layout.activity_dietary_preferences);

    if (savedInstanceState == null) {
      getFragmentManager().beginTransaction()
          .add(R.id.activity_root, new DietaryPreferencesFragment())
          .commit();
    }
  }
}
