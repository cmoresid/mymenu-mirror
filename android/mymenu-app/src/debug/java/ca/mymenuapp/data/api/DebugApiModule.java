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

package ca.mymenuapp.data.api;

import android.content.SharedPreferences;
import ca.mymenuapp.MyMenuApi;
import ca.mymenuapp.data.IsMockMode;
import ca.mymenuapp.data.prefs.StringPreference;
import dagger.Module;
import dagger.Provides;
import javax.inject.Named;
import javax.inject.Singleton;
import retrofit.Endpoint;
import retrofit.Endpoints;
import retrofit.MockRestAdapter;
import retrofit.RestAdapter;
import retrofit.android.AndroidMockValuePersistence;

import static ca.mymenuapp.data.DebugDataModule.DEBUG_API_ENDPOINT;

/**
 * A debug module that overrides bindings in {@link ca.mymenuapp.data.api.ApiModule}.
 */
@Module(
    complete = false,
    library = true,
    overrides = true)
public final class DebugApiModule {

  @Provides @Singleton Endpoint provideEndpoint(
      @Named(DEBUG_API_ENDPOINT) StringPreference apiEndpoint) {
    return Endpoints.newFixedEndpoint(apiEndpoint.get());
  }

  @Provides @Singleton MockRestAdapter provideMockRestAdapter(RestAdapter restAdapter,
      SharedPreferences preferences) {
    MockRestAdapter mockRestAdapter = MockRestAdapter.from(restAdapter);
    AndroidMockValuePersistence.install(mockRestAdapter, preferences);
    return mockRestAdapter;
  }

  @Provides @Singleton MyMenuApi provideMyMenuApi(RestAdapter restAdapter,
      MockRestAdapter mockRestAdapter, @IsMockMode boolean isMockMode, MockMyMenuApi mockService) {
    if (isMockMode) {
      return mockRestAdapter.create(MyMenuApi.class, mockService);
    }
    return restAdapter.create(MyMenuApi.class);
  }
}
