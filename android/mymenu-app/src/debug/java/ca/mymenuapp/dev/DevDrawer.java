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

package ca.mymenuapp.dev;

import android.app.Activity;
import android.content.Context;
import android.support.v4.widget.DrawerLayout;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.Spinner;
import android.widget.Switch;
import android.widget.TextView;
import butterknife.ButterKnife;
import butterknife.InjectView;
import ca.mymenuapp.BuildConfig;
import ca.mymenuapp.R;
import com.f2prateek.ln.Ln;
import com.jakewharton.scalpel.ScalpelFrameLayout;

public class DevDrawer extends DrawerLayout {

  @InjectView(R.id.scalpel) ScalpelFrameLayout scalpelView;
  @InjectView(R.id.scalpel_enabled) Switch scalpelSwitch;
  @InjectView(R.id.scalpel_draw_views) CheckBox drawViews;
  @InjectView(R.id.scalpel_draw_ids) CheckBox drawIds;
  @InjectView(R.id.log_spinner) Spinner logSpinner;
  @InjectView(R.id.build_code) TextView buildCode;
  @InjectView(R.id.build_name) TextView buildName;
  @InjectView(R.id.build_sha) TextView buildSha;
  @InjectView(R.id.build_time) TextView buildTime;

  public DevDrawer(Context context) {
    super(context);
    init();
  }

  public DevDrawer(Context context, AttributeSet attrs) {
    super(context, attrs);
    init();
  }

  public DevDrawer(Context context, AttributeSet attrs, int defStyle) {
    super(context, attrs, defStyle);
    init();
  }

  public void wrapInside(Activity activity) {
    ViewGroup parent = (ViewGroup) activity.findViewById(android.R.id.content);
    View content = parent.getChildAt(0);
    parent.removeViewAt(0);
    scalpelView.addView(content);
    parent.addView(this);
  }

  private void init() {
    LayoutInflater inflater = LayoutInflater.from(getContext());
    addView(inflater.inflate(R.layout.dev_drawer, null));

    ButterKnife.inject(this);

    buildName.setText(getResources().getString(R.string.build_name, BuildConfig.VERSION_NAME));
    buildCode.setText(getResources().getString(R.string.build_code, BuildConfig.VERSION_CODE));
    buildSha.setText(getResources().getString(R.string.build_sha, BuildConfig.GIT_SHA));
    buildTime.setText(getResources().getString(R.string.build_time, BuildConfig.BUILD_TIME));

    scalpelSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
      @Override public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        scalpelView.setLayerInteractionEnabled(isChecked);
        scalpelView.setDrawViews(drawViews.isChecked());
        scalpelView.setDrawIds(drawIds.isChecked());
        drawViews.setEnabled(isChecked);
        drawIds.setEnabled(isChecked);
      }
    });
    drawViews.setChecked(true);
    drawViews.setEnabled(false);
    drawViews.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
      @Override public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        scalpelView.setDrawViews(isChecked);
      }
    });

    drawIds.setChecked(true);
    drawIds.setEnabled(false);
    drawIds.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
      @Override public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        scalpelView.setDrawIds(isChecked);
      }
    });

    ArrayAdapter<CharSequence> adapter =
        ArrayAdapter.createFromResource(getContext(), R.array.ln_level_array,
            android.R.layout.simple_spinner_item);
    adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

    logSpinner.setAdapter(adapter);
    logSpinner.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
      @Override
      public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
        int level = position + 2; // log levels start at 2 but our adapter starts at 0
        Ln.setLoggingLevel(level);
        Ln.d("Log level set to %s", Ln.logLevelToString(level));
      }

      @Override public void onNothingSelected(AdapterView<?> parent) {

      }
    });
  }
}