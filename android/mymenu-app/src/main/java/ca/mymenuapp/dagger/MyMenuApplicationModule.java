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

package ca.mymenuapp.dagger;

import android.content.Context;
import ca.mymenuapp.MyMenuApi;
import ca.mymenuapp.MyMenuApplication;
import ca.mymenuapp.dagger.scopes.ForApplication;
import com.squareup.otto.Bus;
import dagger.Module;
import dagger.Provides;
import javax.inject.Singleton;
import org.simpleframework.xml.core.Persister;
import retrofit.RestAdapter;
import retrofit.converter.SimpleXMLConverter;

@Module(
    injects = MyMenuApplication.class,
    library = true)
public class MyMenuApplicationModule {

  private final MyMenuApplication application;

  public MyMenuApplicationModule(MyMenuApplication application) {
    this.application = application;
  }

  @Provides @Singleton @ForApplication Context provideApplicationContext() {
    return application;
  }

  @Provides @Singleton Bus provideBus() {
    return new Bus();
  }

  @Provides @Singleton MyMenuApi provideMyMenuApi() {
    RestAdapter restAdapter = new RestAdapter.Builder() //
        .setServer("http://mymenuapp.ca/rest")
        .setConverter(new SimpleXMLConverter(new Persister()))
        .build();
    return restAdapter.create(MyMenuApi.class);
  }
}