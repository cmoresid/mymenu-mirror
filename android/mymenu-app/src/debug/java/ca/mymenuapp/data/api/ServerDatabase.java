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

import ca.mymenuapp.data.api.model.Menu;
import ca.mymenuapp.data.api.model.MockMenuLoader;
import com.f2prateek.ln.Ln;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;
import javax.inject.Inject;
import javax.inject.Singleton;

/**
 * Simulates in memory database for {@link ca.mymenuapp.data.api.MockMyMenuApi}.
 * TODO: doesn't do anything yet.
 */
@Singleton
public final class ServerDatabase {
  private static final AtomicLong NEXT_ID = new AtomicLong();

  public static long nextId() {
    return NEXT_ID.getAndIncrement();
  }

  public static String nextStringId() {
    return Long.toHexString(nextId());
  }

  private final MockMenuLoader mockMenuLoader;

  private boolean initialized;

  @Inject public ServerDatabase(MockMenuLoader mockMenuLoader) {
    this.mockMenuLoader = mockMenuLoader;
  }

  private synchronized void initializeMockData() {
    if (initialized) return;
    initialized = true;
    Ln.d("Initializing mock data...");
  }

  public List<Menu> getMenu() {
    initializeMockData();
    return null;
  }
}
