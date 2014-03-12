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

package ca.mymenuapp.ui.fragments;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import butterknife.InjectView;
import ca.mymenuapp.R;
import ca.mymenuapp.data.MyMenuDatabase;
import ca.mymenuapp.data.api.model.Menu;
import ca.mymenuapp.data.rx.EndlessObserver;
import com.f2prateek.dart.InjectExtra;
import com.squareup.picasso.Picasso;
import javax.inject.Inject;

/**
 * A placeholder fragment containing a simple view.
 */
public class PlaceholderFragment extends BaseFragment {
  /**
   * The fragment argument representing the section number for this
   * fragment.
   */
  public static final String ARG_SECTION_NUMBER = "section_number";

  @InjectExtra(ARG_SECTION_NUMBER) int sectionNumber;
  @InjectView(R.id.menu_label) TextView label;
  @InjectView(R.id.menu_picture) ImageView picture;

  @Inject MyMenuDatabase myMenuDatabase;
  @Inject Picasso picasso;

  /**
   * Returns a new instance of this fragment for the given section
   * number.
   */
  public static PlaceholderFragment newInstance(int sectionNumber) {
    PlaceholderFragment fragment = new PlaceholderFragment();
    Bundle args = new Bundle();
    args.putInt(ARG_SECTION_NUMBER, sectionNumber);
    fragment.setArguments(args);
    return fragment;
  }

  @Override
  public View onCreateView(LayoutInflater inflater, ViewGroup container,
      Bundle savedInstanceState) {
    return inflater.inflate(R.layout.fragment_placeholder, container, false);
  }

  @Override public void onResume() {
    super.onResume();
    myMenuDatabase.getMenu(sectionNumber, new EndlessObserver<Menu>() {
      @Override public void onNext(Menu menu) {
        label.setText(String.valueOf(menu));
        picasso.load(menu.picture).into(picture);
      }
    });
    label.setText(String.valueOf(sectionNumber));
  }
}
