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
import android.content.Context;
import ca.mymenuapp.dagger.scopes.ForApplication;
import ca.mymenuapp.data.DataModule;
import ca.mymenuapp.ui.UiModule;
import com.squareup.otto.Bus;
import dagger.Module;
import dagger.Provides;
import javax.inject.Singleton;

/**
 * Entry point for all modules in {@link ca.mymenuapp.MyMenuApp}.
 * This module provides all bindings required for the app.
 */
@Module(
    includes = {
        UiModule.class, DataModule.class
    },
    injects = MyMenuApp.class,
    complete = false,
    library = true)
public class MyMenuModule {

  private final MyMenuApp application;

  public MyMenuModule(MyMenuApp application) {
    this.application = application;
  }

  @Provides @Singleton Application provideApplication() {
    return application;
  }

  @Provides @Singleton @ForApplication Context provideApplicationContext() {
    return application;
  }

  @Provides @Singleton Bus provideBus() {
    return new Bus();
  }
}