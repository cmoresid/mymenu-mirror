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

package ca.mymenuapp.data.api.model;

import android.app.Application;
import android.content.res.AssetManager;
import ca.mymenuapp.model.Menu;
import javax.inject.Inject;
import javax.inject.Singleton;

@Singleton
public final class MockMenuLoader {
  private final AssetManager assetManager;

  @Inject MockMenuLoader(Application application) {
    assetManager = application.getAssets();
  }

  /** A filename like {@code abc123.jpg} inside the {@code mock/images/} asset folder. */
  public Menu newMenu(String filename) {
    String path = "mock/images/" + filename;

    String id = filename.substring(0, filename.lastIndexOf('.'));
    String link = "mock:///" + path;

    Menu menu = new Menu();
    menu.id = path.hashCode();
    menu.picture = path;
    return menu;
  }
}
