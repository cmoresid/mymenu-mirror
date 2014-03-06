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

import android.content.Context;
import ca.mymenuapp.MyMenuModule;
import ca.mymenuapp.dagger.scopes.ForActivity;
import ca.mymenuapp.ui.activities.BaseActivity;
import ca.mymenuapp.ui.activities.LoginActivity;
import ca.mymenuapp.ui.activities.MainActivity;
import ca.mymenuapp.ui.activities.SignUpActivity;
import ca.mymenuapp.ui.fragments.BaseFragment;
import ca.mymenuapp.ui.fragments.DietaryPreferencesFragment;
import ca.mymenuapp.ui.fragments.PlaceholderFragment;
import dagger.Module;
import dagger.Provides;
import javax.inject.Singleton;

@Module(
    injects = {
        // Activities
        BaseActivity.class, MainActivity.class, LoginActivity.class, SignUpActivity.class,
        // Fragments
        BaseFragment.class, PlaceholderFragment.class, DietaryPreferencesFragment.class
    },
    complete = false,
    addsTo = MyMenuModule.class)
public class ActivityModule {
  private final BaseActivity activity;

  public ActivityModule(BaseActivity activity) {
    this.activity = activity;
  }

  @Provides @Singleton @ForActivity Context provideActivityContext() {
    return activity;
  }
}
