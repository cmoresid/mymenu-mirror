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

package ca.mymenuapp;

import ca.mymenuapp.data.DebugDataModule;
import ca.mymenuapp.ui.DebugUiModule;
import dagger.Module;

/**
 * Entry point for all debugging {@link dagger.Module} classes. Used to override bindings in
 * {@link ca.mymenuapp.MyMenuModule} for debug mode.
 */
@Module(
    addsTo = MyMenuModule.class,
    includes = {
        DebugUiModule.class, DebugDataModule.class
    },
    overrides = true)
public final class DebugMyMenuModule {
}
