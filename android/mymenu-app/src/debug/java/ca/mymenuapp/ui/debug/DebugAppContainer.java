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

package ca.mymenuapp.ui.debug;

import android.animation.ValueAnimator;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Build;
import android.support.v4.widget.DrawerLayout;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.Spinner;
import android.widget.Switch;
import android.widget.TextView;
import android.widget.Toast;
import butterknife.ButterKnife;
import butterknife.InjectView;
import butterknife.OnClick;
import ca.mymenuapp.BuildConfig;
import ca.mymenuapp.MyMenuApp;
import ca.mymenuapp.R;
import ca.mymenuapp.data.ApiEndpoints;
import ca.mymenuapp.data.prefs.BooleanPreference;
import ca.mymenuapp.data.prefs.IntPreference;
import ca.mymenuapp.data.prefs.StringPreference;
import ca.mymenuapp.ui.AppContainer;
import ca.mymenuapp.ui.activities.LoginActivity;
import ca.mymenuapp.ui.misc.EnumAdapter;
import ca.mymenuapp.util.Strings;
import com.f2prateek.ln.Ln;
import com.jakewharton.madge.MadgeFrameLayout;
import com.jakewharton.scalpel.ScalpelFrameLayout;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.picasso.Picasso;
import com.squareup.picasso.StatsSnapshot;
import java.lang.reflect.Method;
import java.net.InetSocketAddress;
import java.net.Proxy;
import java.net.SocketAddress;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Date;
import java.util.Set;
import java.util.TimeZone;
import javax.inject.Inject;
import javax.inject.Named;
import javax.inject.Singleton;
import retrofit.MockRestAdapter;
import retrofit.RestAdapter;

import static android.content.Intent.FLAG_ACTIVITY_CLEAR_TASK;
import static android.content.Intent.FLAG_ACTIVITY_NEW_TASK;
import static android.view.View.GONE;
import static android.view.View.VISIBLE;
import static butterknife.ButterKnife.findById;
import static ca.mymenuapp.data.DebugDataModule.DEBUG_ANIMATION_SPEED;
import static ca.mymenuapp.data.DebugDataModule.DEBUG_API_ENDPOINT;
import static ca.mymenuapp.data.DebugDataModule.DEBUG_DRAWER_SEEN;
import static ca.mymenuapp.data.DebugDataModule.DEBUG_NETWORK_LOG_LEVEL;
import static ca.mymenuapp.data.DebugDataModule.DEBUG_NETWORK_PROXY;
import static ca.mymenuapp.data.DebugDataModule.DEBUG_PICASSO_DEBUGGING;
import static ca.mymenuapp.data.DebugDataModule.DEBUG_PIXEL_GRID_ENABLED;
import static ca.mymenuapp.data.DebugDataModule.DEBUG_PIXEL_RATIO_ENABLED;
import static ca.mymenuapp.data.DebugDataModule.DEBUG_SCALPEL_ENABLED;
import static ca.mymenuapp.data.DebugDataModule.DEBUG_SCALPEL_WIREFRAME_ENABLED;
import static java.net.Proxy.Type.HTTP;
import static retrofit.RestAdapter.LogLevel;

/**
 * An {@link AppContainer} for debug builds which wrap the content view with a sliding drawer on
 * the right that holds all of the debug information and settings.
 */
@Singleton
public class DebugAppContainer implements AppContainer {
  @SuppressWarnings("SimpleDateFormat")
  private static final DateFormat DATE_DISPLAY_FORMAT = new SimpleDateFormat("yyyy-MM-dd hh:mm a");

  private final OkHttpClient client;
  private final Picasso picasso;
  private final StringPreference apiEndpoint;
  private final IntPreference networkLogLevel;
  private final StringPreference networkProxy;
  private final IntPreference animationSpeed;
  private final BooleanPreference picassoDebugging;
  private final BooleanPreference pixelGridEnabled;
  private final BooleanPreference pixelRatioEnabled;
  private final BooleanPreference scalpelEnabled;
  private final BooleanPreference scalpelWireframeEnabled;
  private final BooleanPreference seenDebugDrawer;
  private final RestAdapter restAdapter;
  private final MockRestAdapter mockRestAdapter;

  MyMenuApp app;
  Activity activity;
  Context drawerContext;
  @InjectView(R.id.debug_drawer_layout) DrawerLayout drawerLayout;
  @InjectView(R.id.debug_content) ViewGroup content;
  @InjectView(R.id.madge_container) MadgeFrameLayout madgeFrameLayout;
  @InjectView(R.id.debug_content) ScalpelFrameLayout scalpelFrameLayout;
  @InjectView(R.id.debug_contextual_title) View contextualTitleView;
  @InjectView(R.id.debug_contextual_list) LinearLayout contextualListView;
  @InjectView(R.id.debug_network_endpoint) Spinner endpointView;
  @InjectView(R.id.debug_network_endpoint_edit) View endpointEditView;
  @InjectView(R.id.debug_network_delay) Spinner networkDelayView;
  @InjectView(R.id.debug_network_variance) Spinner networkVarianceView;
  @InjectView(R.id.debug_network_error) Spinner networkErrorView;
  @InjectView(R.id.debug_network_proxy) Spinner networkProxyView;
  @InjectView(R.id.debug_network_logging) Spinner networkLoggingView;
  @InjectView(R.id.debug_ui_animation_speed) Spinner uiAnimationSpeedView;
  @InjectView(R.id.debug_ui_pixel_grid) Switch uiPixelGridView;
  @InjectView(R.id.debug_ui_pixel_ratio) Switch uiPixelRatioView;
  @InjectView(R.id.debug_ui_scalpel) Switch uiScalpelView;
  @InjectView(R.id.debug_ui_scalpel_wireframe) Switch uiScalpelWireframeView;
  @InjectView(R.id.debug_build_name) TextView buildNameView;
  @InjectView(R.id.debug_build_code) TextView buildCodeView;
  @InjectView(R.id.debug_build_sha) TextView buildShaView;
  @InjectView(R.id.debug_build_date) TextView buildDateView;
  @InjectView(R.id.debug_device_make) TextView deviceMakeView;
  @InjectView(R.id.debug_device_model) TextView deviceModelView;
  @InjectView(R.id.debug_device_resolution) TextView deviceResolutionView;
  @InjectView(R.id.debug_device_density) TextView deviceDensityView;
  @InjectView(R.id.debug_device_release) TextView deviceReleaseView;
  @InjectView(R.id.debug_device_api) TextView deviceApiView;
  @InjectView(R.id.debug_picasso_indicators) Switch picassoIndicatorView;
  @InjectView(R.id.debug_picasso_cache_size) TextView picassoCacheSizeView;
  @InjectView(R.id.debug_picasso_cache_hit) TextView picassoCacheHitView;
  @InjectView(R.id.debug_picasso_cache_miss) TextView picassoCacheMissView;
  @InjectView(R.id.debug_picasso_decoded) TextView picassoDecodedView;
  @InjectView(R.id.debug_picasso_decoded_total) TextView picassoDecodedTotalView;
  @InjectView(R.id.debug_picasso_decoded_avg) TextView picassoDecodedAvgView;
  @InjectView(R.id.debug_picasso_transformed) TextView picassoTransformedView;
  @InjectView(R.id.debug_picasso_transformed_total) TextView picassoTransformedTotalView;
  @InjectView(R.id.debug_picasso_transformed_avg) TextView picassoTransformedAvgView;

  @Inject public DebugAppContainer(OkHttpClient client, Picasso picasso, RestAdapter restAdapter,
      MockRestAdapter mockRestAdapter, @Named(DEBUG_API_ENDPOINT) StringPreference apiEndpoint,
      @Named(DEBUG_NETWORK_PROXY) StringPreference networkProxy,
      @Named(DEBUG_NETWORK_LOG_LEVEL) IntPreference networkLogLevel,
      @Named(DEBUG_ANIMATION_SPEED) IntPreference animationSpeed,
      @Named(DEBUG_PICASSO_DEBUGGING) BooleanPreference picassoDebugging,
      @Named(DEBUG_PIXEL_GRID_ENABLED) BooleanPreference pixelGridEnabled,
      @Named(DEBUG_PIXEL_RATIO_ENABLED) BooleanPreference pixelRatioEnabled,
      @Named(DEBUG_SCALPEL_ENABLED) BooleanPreference scalpelEnabled,
      @Named(DEBUG_SCALPEL_WIREFRAME_ENABLED) BooleanPreference scalpelWireframeEnabled,
      @Named(DEBUG_DRAWER_SEEN) BooleanPreference seenDebugDrawer) {
    this.client = client;
    this.picasso = picasso;
    this.apiEndpoint = apiEndpoint;
    this.scalpelEnabled = scalpelEnabled;
    this.scalpelWireframeEnabled = scalpelWireframeEnabled;
    this.seenDebugDrawer = seenDebugDrawer;
    this.mockRestAdapter = mockRestAdapter;
    this.networkProxy = networkProxy;
    this.networkLogLevel = networkLogLevel;
    this.animationSpeed = animationSpeed;
    this.picassoDebugging = picassoDebugging;
    this.pixelGridEnabled = pixelGridEnabled;
    this.pixelRatioEnabled = pixelRatioEnabled;
    this.restAdapter = restAdapter;
  }

  private static String getDensityString(DisplayMetrics displayMetrics) {
    switch (displayMetrics.densityDpi) {
      case DisplayMetrics.DENSITY_LOW:
        return "ldpi";
      case DisplayMetrics.DENSITY_MEDIUM:
        return "mdpi";
      case DisplayMetrics.DENSITY_HIGH:
        return "hdpi";
      case DisplayMetrics.DENSITY_XHIGH:
        return "xhdpi";
      case DisplayMetrics.DENSITY_XXHIGH:
        return "xxhdpi";
      case DisplayMetrics.DENSITY_XXXHIGH:
        return "xxxhdpi";
      case DisplayMetrics.DENSITY_TV:
        return "tvdpi";
      default:
        return "unknown";
    }
  }

  private static String getSizeString(long bytes) {
    String[] units = new String[] {"B", "KB", "MB", "GB"};
    int unit = 0;
    while (bytes >= 1024) {
      bytes /= 1024;
      unit += 1;
    }
    return bytes + units[unit];
  }

  @Override public ViewGroup get(final Activity activity, MyMenuApp app) {
    this.app = app;
    this.activity = activity;
    drawerContext = activity;

    activity.setContentView(R.layout.debug_activity_frame);

    // Manually find the debug drawer and inflate the drawer layout inside of it.
    ViewGroup drawer = findById(activity, R.id.debug_drawer);
    LayoutInflater.from(drawerContext).inflate(R.layout.debug_drawer_content, drawer);

    // Inject after inflating the drawer layout so its views are available to inject.
    ButterKnife.inject(this, activity);

    // Set up the contextual actions to watch views coming in and out of the content area.
    Set<ContextualDebugActions.DebugAction<?>> debugActions = Collections.emptySet();
    ContextualDebugActions contextualActions = new ContextualDebugActions(this, debugActions);
    content.setOnHierarchyChangeListener(HierarchyTreeChangeListener.wrap(contextualActions));

    drawerLayout.setDrawerShadow(R.drawable.debug_drawer_shadow, Gravity.END);
    drawerLayout.setDrawerListener(new DrawerLayout.SimpleDrawerListener() {
      @Override public void onDrawerOpened(View drawerView) {
        refreshPicassoStats();
      }
    });

    // If you have not seen the debug drawer before, show it with a message
    if (!seenDebugDrawer.get()) {
      drawerLayout.postDelayed(new Runnable() {
        @Override public void run() {
          drawerLayout.openDrawer(Gravity.END);
          Toast.makeText(activity, R.string.debug_drawer_welcome, Toast.LENGTH_LONG).show();
        }
      }, 1000);
      seenDebugDrawer.set(true);
    }

    setupNetworkSection();
    setupUserInterfaceSection();
    setupBuildSection();
    setupDeviceSection();
    setupPicassoSection();

    return content;
  }

  private void setupNetworkSection() {
    final ApiEndpoints currentEndpoint = ApiEndpoints.from(apiEndpoint.get());
    final EnumAdapter<ApiEndpoints> endpointAdapter =
        new EnumAdapter<>(drawerContext, ApiEndpoints.class);
    endpointView.setAdapter(endpointAdapter);
    endpointView.setSelection(currentEndpoint.ordinal());
    endpointView.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
      @Override
      public void onItemSelected(AdapterView<?> adapterView, View view, int position, long id) {
        ApiEndpoints selected = endpointAdapter.getItem(position);
        if (selected != currentEndpoint) {
          if (selected == ApiEndpoints.CUSTOM) {
            Ln.d("Custom network endpoint selected. Prompting for URL.");
            showCustomEndpointDialog(currentEndpoint.ordinal(), "http://");
          } else {
            setEndpointAndRelaunch(selected.url);
          }
        } else {
          Ln.d("Ignoring re-selection of network endpoint %s", selected);
        }
      }

      @Override public void onNothingSelected(AdapterView<?> adapterView) {
      }
    });

    final NetworkDelayAdapter delayAdapter = new NetworkDelayAdapter(drawerContext);
    networkDelayView.setAdapter(delayAdapter);
    networkDelayView.setSelection(
        NetworkDelayAdapter.getPositionForValue(mockRestAdapter.getDelay()));
    networkDelayView.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
      @Override
      public void onItemSelected(AdapterView<?> adapterView, View view, int position, long id) {
        long selected = delayAdapter.getItem(position);
        if (selected != mockRestAdapter.getDelay()) {
          Ln.d("Setting network delay to %sms", selected);
          mockRestAdapter.setDelay(selected);
        } else {
          Ln.d("Ignoring re-selection of network delay %sms", selected);
        }
      }

      @Override public void onNothingSelected(AdapterView<?> adapterView) {
      }
    });

    final NetworkVarianceAdapter varianceAdapter = new NetworkVarianceAdapter(drawerContext);
    networkVarianceView.setAdapter(varianceAdapter);
    networkVarianceView.setSelection(
        NetworkVarianceAdapter.getPositionForValue(mockRestAdapter.getVariancePercentage()));
    networkVarianceView.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
      @Override
      public void onItemSelected(AdapterView<?> adapterView, View view, int position, long id) {
        int selected = varianceAdapter.getItem(position);
        if (selected != mockRestAdapter.getVariancePercentage()) {
          Ln.d("Setting network variance to %s%%", selected);
          mockRestAdapter.setVariancePercentage(selected);
        } else {
          Ln.d("Ignoring re-selection of network variance %s%%", selected);
        }
      }

      @Override public void onNothingSelected(AdapterView<?> adapterView) {
      }
    });

    final NetworkErrorAdapter errorAdapter = new NetworkErrorAdapter(drawerContext);
    networkErrorView.setAdapter(errorAdapter);
    networkErrorView.setSelection(
        NetworkErrorAdapter.getPositionForValue(mockRestAdapter.getErrorPercentage()));
    networkErrorView.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
      @Override
      public void onItemSelected(AdapterView<?> adapterView, View view, int position, long id) {
        int selected = errorAdapter.getItem(position);
        if (selected != mockRestAdapter.getErrorPercentage()) {
          Ln.d("Setting network error to %s%%", selected);
          mockRestAdapter.setErrorPercentage(selected);
        } else {
          Ln.d("Ignoring re-selection of network error %s%%", selected);
        }
      }

      @Override public void onNothingSelected(AdapterView<?> adapterView) {
      }
    });

    int currentProxyPosition = networkProxy.isSet() ? ProxyAdapter.PROXY : ProxyAdapter.NONE;
    final ProxyAdapter proxyAdapter = new ProxyAdapter(activity, networkProxy);
    networkProxyView.setAdapter(proxyAdapter);
    networkProxyView.setSelection(currentProxyPosition);
    networkProxyView.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
      @Override
      public void onItemSelected(AdapterView<?> adapterView, View view, int position, long id) {
        if (position == ProxyAdapter.NONE) {
          Ln.d("Clearing network proxy");
          networkProxy.delete();
          client.setProxy(null);
        } else if (networkProxy.isSet() && position == ProxyAdapter.PROXY) {
          Ln.d("Ignoring re-selection of network proxy %s", networkProxy.get());
        } else {
          Ln.d("New network proxy selected. Prompting for host.");
          showNewNetworkProxyDialog(proxyAdapter);
        }
      }

      @Override public void onNothingSelected(AdapterView<?> adapterView) {
      }
    });

    // Only show the endpoint editor when a custom endpoint is in use.
    endpointEditView.setVisibility(currentEndpoint == ApiEndpoints.CUSTOM ? VISIBLE : GONE);

    if (currentEndpoint == ApiEndpoints.MOCK_MODE) {
      // Disable network proxy if we are in mock mode.
      networkProxyView.setEnabled(false);
      networkLoggingView.setEnabled(false);
    } else {
      // Disable network controls if we are not in mock mode.
      networkDelayView.setEnabled(false);
      networkVarianceView.setEnabled(false);
      networkErrorView.setEnabled(false);
    }

    // We use the JSON rest adapter as the source of truth for the log level.
    final EnumAdapter<LogLevel> loggingAdapter = new EnumAdapter<>(activity, LogLevel.class);
    networkLoggingView.setAdapter(loggingAdapter);
    networkLoggingView.setSelection(networkLogLevel.get());
    restAdapter.setLogLevel(LogLevel.values()[networkLogLevel.get()]);
    networkLoggingView.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
      @Override
      public void onItemSelected(AdapterView<?> adapterView, View view, int position, long id) {
        LogLevel selected = loggingAdapter.getItem(position);
        if (selected != restAdapter.getLogLevel()) {
          Ln.d("Setting logging level to %s", selected);
          restAdapter.setLogLevel(selected);
          networkLogLevel.set(selected.ordinal());
        } else {
          Ln.d("Ignoring re-selection of logging level " + selected);
        }
      }

      @Override public void onNothingSelected(AdapterView<?> adapterView) {
      }
    });
  }

  @OnClick(R.id.debug_network_endpoint_edit) void onEditEndpointClicked() {
    Ln.d("Prompting to edit custom endpoint URL.");
    // Pass in the currently selected position since we are merely editing.
    showCustomEndpointDialog(endpointView.getSelectedItemPosition(), apiEndpoint.get());
  }

  private void setupUserInterfaceSection() {
    final AnimationSpeedAdapter speedAdapter = new AnimationSpeedAdapter(activity);
    uiAnimationSpeedView.setAdapter(speedAdapter);
    final int animationSpeedValue = animationSpeed.get();
    uiAnimationSpeedView.setSelection(
        AnimationSpeedAdapter.getPositionForValue(animationSpeedValue));
    uiAnimationSpeedView.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
      @Override
      public void onItemSelected(AdapterView<?> adapterView, View view, int position, long id) {
        int selected = speedAdapter.getItem(position);
        if (selected != animationSpeed.get()) {
          Ln.d("Setting animation speed to %sx", selected);
          animationSpeed.set(selected);
          applyAnimationSpeed(selected);
        } else {
          Ln.d("Ignoring re-selection of animation speed %sx", selected);
        }
      }

      @Override public void onNothingSelected(AdapterView<?> adapterView) {
      }
    });
    // Ensure the animation speed value is always applied across app restarts.
    content.post(new Runnable() {
      @Override public void run() {
        applyAnimationSpeed(animationSpeedValue);
      }
    });

    boolean gridEnabled = pixelGridEnabled.get();
    madgeFrameLayout.setOverlayEnabled(gridEnabled);
    uiPixelGridView.setChecked(gridEnabled);
    uiPixelRatioView.setEnabled(gridEnabled);
    uiPixelGridView.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
      @Override public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        Ln.d("Setting pixel grid overlay enabled to " + isChecked);
        pixelGridEnabled.set(isChecked);
        madgeFrameLayout.setOverlayEnabled(isChecked);
        uiPixelRatioView.setEnabled(isChecked);
      }
    });

    boolean ratioEnabled = pixelRatioEnabled.get();
    madgeFrameLayout.setOverlayRatioEnabled(ratioEnabled);
    uiPixelRatioView.setChecked(ratioEnabled);
    uiPixelRatioView.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
      @Override public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        Ln.d("Setting pixel scale overlay enabled to " + isChecked);
        pixelRatioEnabled.set(isChecked);
        madgeFrameLayout.setOverlayRatioEnabled(isChecked);
      }
    });

    boolean scalpel = scalpelEnabled.get();
    scalpelFrameLayout.setLayerInteractionEnabled(scalpel);
    uiScalpelView.setChecked(scalpel);
    uiScalpelWireframeView.setEnabled(scalpel);
    uiScalpelView.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
      @Override public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        Ln.d("Setting scalpel interaction enabled to " + isChecked);
        scalpelEnabled.set(isChecked);
        scalpelFrameLayout.setLayerInteractionEnabled(isChecked);
        uiScalpelWireframeView.setEnabled(isChecked);
      }
    });

    boolean wireframe = scalpelWireframeEnabled.get();
    scalpelFrameLayout.setDrawViews(!wireframe);
    uiScalpelWireframeView.setChecked(wireframe);
    uiScalpelWireframeView.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
      @Override public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        Ln.d("Setting scalpel wireframe enabled to " + isChecked);
        scalpelWireframeEnabled.set(isChecked);
        scalpelFrameLayout.setDrawViews(!isChecked);
      }
    });
  }

  private void setupBuildSection() {
    buildNameView.setText(BuildConfig.VERSION_NAME);
    buildCodeView.setText(String.valueOf(BuildConfig.VERSION_CODE));
    buildShaView.setText(BuildConfig.GIT_SHA);

    try {
      // Parse ISO8601-format time into local time.
      DateFormat inFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm'Z'");
      inFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
      Date buildTime = inFormat.parse(BuildConfig.BUILD_TIME);
      buildDateView.setText(DATE_DISPLAY_FORMAT.format(buildTime));
    } catch (ParseException e) {
      throw new RuntimeException("Unable to decode build time: " + BuildConfig.BUILD_TIME, e);
    }
  }

  private void setupDeviceSection() {
    DisplayMetrics displayMetrics = activity.getResources().getDisplayMetrics();
    String densityBucket = getDensityString(displayMetrics);
    deviceMakeView.setText(Strings.truncateAt(Build.MANUFACTURER, 20));
    deviceModelView.setText(Strings.truncateAt(Build.MODEL, 20));
    deviceResolutionView.setText(displayMetrics.heightPixels + "x" + displayMetrics.widthPixels);
    deviceDensityView.setText(displayMetrics.densityDpi + "dpi (" + densityBucket + ")");
    deviceReleaseView.setText(Build.VERSION.RELEASE);
    deviceApiView.setText(String.valueOf(Build.VERSION.SDK_INT));
  }

  private void setupPicassoSection() {
    boolean picassoDebuggingValue = picassoDebugging.get();
    picasso.setDebugging(picassoDebuggingValue);
    picassoIndicatorView.setChecked(picassoDebuggingValue);
    picassoIndicatorView.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
      @Override public void onCheckedChanged(CompoundButton button, boolean isChecked) {
        Ln.d("Setting Picasso debugging to " + isChecked);
        picasso.setDebugging(isChecked);
        picassoDebugging.set(isChecked);
      }
    });

    refreshPicassoStats();
  }

  private void refreshPicassoStats() {
    StatsSnapshot snapshot = picasso.getSnapshot();
    String size = getSizeString(snapshot.size);
    String total = getSizeString(snapshot.maxSize);
    int percentage = (int) ((1f * snapshot.size / snapshot.maxSize) * 100);
    picassoCacheSizeView.setText(size + " / " + total + " (" + percentage + "%)");
    picassoCacheHitView.setText(String.valueOf(snapshot.cacheHits));
    picassoCacheMissView.setText(String.valueOf(snapshot.cacheMisses));
    picassoDecodedView.setText(String.valueOf(snapshot.originalBitmapCount));
    picassoDecodedTotalView.setText(getSizeString(snapshot.totalOriginalBitmapSize));
    picassoDecodedAvgView.setText(getSizeString(snapshot.averageOriginalBitmapSize));
    picassoTransformedView.setText(String.valueOf(snapshot.transformedBitmapCount));
    picassoTransformedTotalView.setText(getSizeString(snapshot.totalTransformedBitmapSize));
    picassoTransformedAvgView.setText(getSizeString(snapshot.averageTransformedBitmapSize));
  }

  private void applyAnimationSpeed(int multiplier) {
    try {
      Method method = ValueAnimator.class.getDeclaredMethod("setDurationScale", float.class);
      method.invoke(null, (float) multiplier);
    } catch (Exception e) {
      throw new RuntimeException("Unable to apply animation speed.", e);
    }
  }

  private void showNewNetworkProxyDialog(final ProxyAdapter proxyAdapter) {
    final int originalSelection = networkProxy.isSet() ? ProxyAdapter.PROXY : ProxyAdapter.NONE;

    View view = LayoutInflater.from(app).inflate(R.layout.debug_drawer_network_proxy, null);
    final EditText host = findById(view, R.id.debug_drawer_network_proxy_host);

    new AlertDialog.Builder(activity) //
        .setTitle("Set Network Proxy")
        .setView(view)
        .setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
          @Override public void onClick(DialogInterface dialog, int i) {
            networkProxyView.setSelection(originalSelection);
            dialog.cancel();
          }
        })
        .setPositiveButton("Use", new DialogInterface.OnClickListener() {
          @Override public void onClick(DialogInterface dialog, int i) {
            String theHost = host.getText().toString();
            if (!Strings.isBlank(theHost)) {
              String[] parts = theHost.split(":", 2);
              SocketAddress address =
                  InetSocketAddress.createUnresolved(parts[0], Integer.parseInt(parts[1]));

              networkProxy.set(theHost); // Persist across restarts.
              proxyAdapter.notifyDataSetChanged(); // Tell the spinner to update.
              networkProxyView.setSelection(ProxyAdapter.PROXY); // And show the proxy.

              client.setProxy(new Proxy(HTTP, address));
            } else {
              networkProxyView.setSelection(originalSelection);
            }
          }
        })
        .setOnCancelListener(new DialogInterface.OnCancelListener() {
          @Override public void onCancel(DialogInterface dialogInterface) {
            networkProxyView.setSelection(originalSelection);
          }
        })
        .show();
  }

  private void showCustomEndpointDialog(final int originalSelection, String defaultUrl) {
    View view = LayoutInflater.from(app).inflate(R.layout.debug_drawer_network_endpoint, null);
    final EditText url = findById(view, R.id.debug_drawer_network_endpoint_url);
    url.setText(defaultUrl);
    url.setSelection(url.length());

    new AlertDialog.Builder(activity) //
        .setTitle("Set Network Endpoint")
        .setView(view)
        .setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
          @Override public void onClick(DialogInterface dialog, int i) {
            endpointView.setSelection(originalSelection);
            dialog.cancel();
          }
        })
        .setPositiveButton("Use", new DialogInterface.OnClickListener() {
          @Override public void onClick(DialogInterface dialog, int i) {
            String theUrl = url.getText().toString();
            if (!Strings.isBlank(theUrl)) {
              setEndpointAndRelaunch(theUrl);
            } else {
              endpointView.setSelection(originalSelection);
            }
          }
        })
        .setOnCancelListener(new DialogInterface.OnCancelListener() {
          @Override public void onCancel(DialogInterface dialogInterface) {
            endpointView.setSelection(originalSelection);
          }
        })
        .show();
  }

  private void setEndpointAndRelaunch(String endpoint) {
    Ln.d("Setting network endpoint to %s", endpoint);
    apiEndpoint.set(endpoint);
    Intent newApp = new Intent(app, LoginActivity.class);
    newApp.setFlags(FLAG_ACTIVITY_CLEAR_TASK | FLAG_ACTIVITY_NEW_TASK);
    app.startActivity(newApp);
    app.buildApplicationGraphAndInject();
  }
}
