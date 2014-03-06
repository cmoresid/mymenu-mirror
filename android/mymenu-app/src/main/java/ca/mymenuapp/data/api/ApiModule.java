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

import ca.mymenuapp.MyMenuApi;
import com.squareup.okhttp.OkHttpClient;
import dagger.Module;
import dagger.Provides;
import javax.inject.Singleton;
import org.simpleframework.xml.core.Persister;
import retrofit.Endpoint;
import retrofit.Endpoints;
import retrofit.RestAdapter;
import retrofit.client.Client;
import retrofit.client.OkClient;
import retrofit.converter.Converter;
import retrofit.converter.SimpleXMLConverter;

/**
 * Module for talking to the backend API.
 * Has direct dependencies on {@link ca.mymenuapp.data.DataModule} for obvious reasons.
 */
@Module(
    complete = false,
    library = true)
public final class ApiModule {
  public static final String PRODUCTION_API_URL = "http://mymenuapp.ca";

  @Provides @Singleton Endpoint provideEndpoint() {
    return Endpoints.newFixedEndpoint(PRODUCTION_API_URL);
  }

  @Provides @Singleton Client provideClient(OkHttpClient client) {
    return new OkClient(client);
  }

  @Provides @Singleton Converter provideConverter() {
    return new XmlConverter();
  }

  @Provides @Singleton
  RestAdapter provideRestAdapter(Endpoint endpoint, Client client, Converter converter) {
    return new RestAdapter.Builder() //
        .setEndpoint(endpoint) //
        .setClient(client) //
        .setConverter(converter) //
        .build();
  }

  @Provides @Singleton MyMenuApi provideMyMenuApi(RestAdapter restAdapter) {
    return restAdapter.create(MyMenuApi.class);
  }
}