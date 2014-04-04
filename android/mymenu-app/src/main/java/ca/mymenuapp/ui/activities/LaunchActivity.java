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

import android.content.Intent;
import android.os.Bundle;
import ca.mymenuapp.data.api.model.User;
import ca.mymenuapp.data.prefs.ObjectPreference;
import javax.inject.Inject;
import javax.inject.Named;

import static ca.mymenuapp.data.DataModule.USER_PREFERENCE;

/**
 * A launch activity that redirects the user to either
 * {@link ca.mymenuapp.ui.activities.LoginActivity}
 * or {@link ca.mymenuapp.ui.activities.MainActivity}.
 */
public class LaunchActivity extends BaseActivity {

  @Inject @Named(USER_PREFERENCE) ObjectPreference<User> userPreference;

  @Override protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    if (userPreference.get() == null) {
      Intent intent = new Intent(this, LoginActivity.class);
      startActivity(intent);
      finish();
    } else {
      Intent intent = new Intent(this, MainActivity.class);
      startActivity(intent);
      finish();
    }
  }
}
