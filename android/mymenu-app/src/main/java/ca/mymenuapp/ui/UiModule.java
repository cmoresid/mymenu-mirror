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
import ca.mymenuapp.dagger.scopes.ForApplication;
import dagger.Module;
import dagger.Provides;
import javax.inject.Singleton;

@Module(
    complete = false,
    library = true)
public class UiModule {
  @Provides @Singleton AppContainer provideAppContainer() {
    return AppContainer.DEFAULT;
  }

  @Provides @Singleton ActivityHierarchyServer provideActivityHierarchyServer() {
    return ActivityHierarchyServer.NONE;
  }

  @Provides @Singleton TabletSupportUtil provideTabletSupportUtil(@ForApplication Context context) {
    return new TabletSupportUtil(context);
  }
}