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

import android.app.Application;
import android.content.Context;
import android.content.SharedPreferences;
import ca.mymenuapp.dagger.scopes.ForApplication;
import ca.mymenuapp.data.api.DebugApiModule;
import ca.mymenuapp.data.prefs.BooleanPreference;
import ca.mymenuapp.data.prefs.IntPreference;
import ca.mymenuapp.data.prefs.StringPreference;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.picasso.OkHttpDownloader;
import com.squareup.picasso.Picasso;
import dagger.Module;
import dagger.Provides;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import javax.inject.Named;
import javax.inject.Singleton;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import retrofit.MockRestAdapter;

@Module(
    includes = DebugApiModule.class,
    complete = false,
    library = true,
    overrides = true)
public final class DebugDataModule {
  // identifiers for identifying debug preferences
  public static final String DEBUG_ANIMATION_SPEED = "debug_animation_speed";
  public static final String DEBUG_API_ENDPOINT = "debug_endpoint";
  public static final String DEBUG_NETWORK_PROXY = "debug_network_proxy";
  public static final String DEBUG_PICASSO_DEBUGGING = "debug_picasso_debugging";
  public static final String DEBUG_PIXEL_GRID_ENABLED = "debug_pixel_grid_enabled";
  public static final String DEBUG_PIXEL_RATIO_ENABLED = "debug_pixel_ratio_enabled";
  public static final String DEBUG_SCALPEL_ENABLED = "debug_scalpel_enabled";
  public static final String DEBUG_SCALPEL_WIREFRAME_ENABLED = "debug_scalpel_wireframe_drawer";
  public static final String DEBUG_DRAWER_SEEN = "debug_seen_debug_drawer";

  private static final int DEFAULT_ANIMATION_SPEED = 1; // 1x (normal) speed.
  private static final boolean DEFAULT_PICASSO_DEBUGGING = false; // Debug indicators displayed
  private static final boolean DEFAULT_PIXEL_GRID_ENABLED = false; // No pixel grid overlay.
  private static final boolean DEFAULT_PIXEL_RATIO_ENABLED = false; // No pixel ratio overlay.
  private static final boolean DEFAULT_SCALPEL_ENABLED = false; // No crazy 3D view tree.
  private static final boolean DEFAULT_SCALPEL_WIREFRAME_ENABLED = false; // Draw views by default.
  private static final boolean DEFAULT_SEEN_DEBUG_DRAWER = false; // Show debug drawer first time.

  private static SSLSocketFactory createBadSslSocketFactory() {
    try {
      // Construct SSLSocketFactory that accepts any cert.
      SSLContext context = SSLContext.getInstance("TLS");
      TrustManager permissive = new X509TrustManager() {
        @Override public void checkClientTrusted(X509Certificate[] chain, String authType)
            throws CertificateException {
        }

        @Override public void checkServerTrusted(X509Certificate[] chain, String authType)
            throws CertificateException {
        }

        @Override public X509Certificate[] getAcceptedIssuers() {
          return null;
        }
      };
      context.init(null, new TrustManager[] { permissive }, null);
      return context.getSocketFactory();
    } catch (Exception e) {
      throw new AssertionError(e);
    }
  }

  @Provides @Singleton
  OkHttpClient provideOkHttpClient(@ForApplication Context applicationContext) {
    OkHttpClient client = DataModule.createOkHttpClient(applicationContext);
    client.setSslSocketFactory(createBadSslSocketFactory());
    return client;
  }

  @Provides @Singleton @Named(DEBUG_API_ENDPOINT)
  StringPreference provideEndpointPreference(SharedPreferences preferences) {
    return new StringPreference(preferences, DEBUG_API_ENDPOINT, ApiEndpoints.MOCK_MODE.url);
  }

  @Provides @Singleton @IsMockMode
  boolean provideIsMockMode(@Named(DEBUG_API_ENDPOINT) StringPreference endpoint) {
    return ApiEndpoints.isMockMode(endpoint.get());
  }

  @Provides @Singleton @Named(DEBUG_NETWORK_PROXY)
  StringPreference provideNetworkProxy(SharedPreferences preferences) {
    return new StringPreference(preferences, DEBUG_NETWORK_PROXY);
  }

  @Provides @Singleton @Named(DEBUG_ANIMATION_SPEED)
  IntPreference provideAnimationSpeed(SharedPreferences preferences) {
    return new IntPreference(preferences, DEBUG_ANIMATION_SPEED, DEFAULT_ANIMATION_SPEED);
  }

  @Provides @Singleton @Named(DEBUG_PICASSO_DEBUGGING)
  BooleanPreference providePicassoDebugging(SharedPreferences preferences) {
    return new BooleanPreference(preferences, DEBUG_PICASSO_DEBUGGING, DEFAULT_PICASSO_DEBUGGING);
  }

  @Provides @Singleton @Named(DEBUG_PIXEL_GRID_ENABLED)
  BooleanPreference providePixelGridEnabled(SharedPreferences preferences) {
    return new BooleanPreference(preferences, DEBUG_PIXEL_GRID_ENABLED, DEFAULT_PIXEL_GRID_ENABLED);
  }

  @Provides @Singleton @Named(DEBUG_PIXEL_RATIO_ENABLED)
  BooleanPreference providePixelRatioEnabled(SharedPreferences preferences) {
    return new BooleanPreference(preferences, DEBUG_PIXEL_RATIO_ENABLED,
        DEFAULT_PIXEL_RATIO_ENABLED);
  }

  @Provides @Singleton @Named(DEBUG_DRAWER_SEEN)
  BooleanPreference provideSeenDebugDrawer(SharedPreferences preferences) {
    return new BooleanPreference(preferences, DEBUG_DRAWER_SEEN, DEFAULT_SEEN_DEBUG_DRAWER);
  }

  @Provides @Singleton @Named(DEBUG_SCALPEL_ENABLED)
  BooleanPreference provideScalpelEnabled(SharedPreferences preferences) {
    return new BooleanPreference(preferences, DEBUG_SCALPEL_ENABLED, DEFAULT_SCALPEL_ENABLED);
  }

  @Provides @Singleton @Named(DEBUG_SCALPEL_WIREFRAME_ENABLED)
  BooleanPreference provideScalpelWireframeEnabled(SharedPreferences preferences) {
    return new BooleanPreference(preferences, DEBUG_SCALPEL_WIREFRAME_ENABLED,
        DEFAULT_SCALPEL_WIREFRAME_ENABLED);
  }

  @Provides @Singleton Picasso providePicasso(OkHttpClient client, MockRestAdapter mockRestAdapter,
      @IsMockMode boolean isMockMode, Application app) {
    Picasso.Builder builder = new Picasso.Builder(app);
    if (isMockMode) {
      builder.downloader(new MockDownloader(mockRestAdapter, app.getAssets()));
    } else {
      builder.downloader(new OkHttpDownloader(client));
    }
    return builder.build();
  }
}
