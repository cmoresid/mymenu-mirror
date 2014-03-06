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
import ca.mymenuapp.data.api.model.DietaryRestriction;
import ca.mymenuapp.data.api.model.DietaryRestrictionResponse;
import ca.mymenuapp.model.Menu;
import javax.inject.Inject;
import javax.inject.Singleton;
import retrofit.Callback;
import retrofit.http.Field;
import retrofit.http.Path;

@Singleton
final class MockMyMenuApi implements MyMenuApi {
  private static final int PAGE_SIZE = 50;

  private final ServerDatabase serverDatabase;

  @Inject MockMyMenuApi(ServerDatabase serverDatabase) {
    this.serverDatabase = serverDatabase;
  }

  @Override public void getMenu(@Path("id") long id, Callback<Menu> cb) {

  }

  @Override public void getAllDietaryRestrictions(@Field("query") String query,
      Callback<DietaryRestrictionResponse> cb) {

  }
}
