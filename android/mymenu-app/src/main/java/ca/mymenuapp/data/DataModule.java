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

package ca.mymenuapp.data;

import android.content.Context;
import android.content.SharedPreferences;
import android.net.Uri;
import ca.mymenuapp.BuildConfig;
import ca.mymenuapp.dagger.scopes.ForApplication;
import ca.mymenuapp.data.api.ApiModule;
import ca.mymenuapp.data.api.model.User;
import ca.mymenuapp.data.prefs.ObjectPreference;
import com.f2prateek.ln.Ln;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.squareup.okhttp.HttpResponseCache;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.picasso.OkHttpDownloader;
import com.squareup.picasso.Picasso;
import dagger.Module;
import dagger.Provides;
import java.io.File;
import java.io.IOException;
import javax.inject.Singleton;

/**
 * Module for any data sources, including databases (which we don't use), http clients, image
 * loaders and preferences.
 */
@Module(
    includes = ApiModule.class,
    complete = false,
    library = true)
public final class DataModule {

  static final int DISK_CACHE_SIZE = 50 * 1024 * 1024; // 50MB

  static OkHttpClient createOkHttpClient(Context app) {
    OkHttpClient client = new OkHttpClient();
    // Install an HTTP cache in the application cache directory.
    try {
      File cacheDir = new File(app.getCacheDir(), "http");
      HttpResponseCache cache = new HttpResponseCache(cacheDir, DISK_CACHE_SIZE);
      client.setResponseCache(cache);
    } catch (IOException e) {
      Ln.e(e, "Unable to install disk cache.");
    }

    return client;
  }

  @Provides @Singleton Gson provideGson() {
    return new GsonBuilder().create();
  }

  @Provides @Singleton
  SharedPreferences provideSharedPreferences(@ForApplication Context applicationContext) {
    return applicationContext.getSharedPreferences(BuildConfig.PACKAGE_NAME, Context.MODE_PRIVATE);
  }

  @Provides @Singleton
  OkHttpClient provideOkHttpClient(@ForApplication Context applicationContext) {
    return createOkHttpClient(applicationContext);
  }

  @Provides @Singleton
  Picasso providePicasso(@ForApplication Context applicationContext, OkHttpClient client) {
    return new Picasso.Builder(applicationContext).downloader(new OkHttpDownloader(client))
        .listener(new Picasso.Listener() {
          @Override public void onImageLoadFailed(Picasso picasso, Uri uri, Exception e) {
            Ln.e(e, "Failed to load image: %s", uri);
          }
        })
        .build();
  }

  @Provides @Singleton @ForUser
  ObjectPreference<User> providesUser(SharedPreferences preferences, Gson gson) {
    ObjectPreference<User> userPreference =
        new ObjectPreference<>(preferences, gson, User.class, "user");
    return userPreference;
  }
}