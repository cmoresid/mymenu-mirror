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

package ca.mymenuapp.ui.adapters;

import android.content.Context;
import ca.mymenuapp.R;
import ca.mymenuapp.ui.misc.EnumAdapter;

/**
 * An {@link ca.mymenuapp.ui.misc.EnumAdapter} that can display localized strings.
 */
public class LocalizedEnumAdapter<T extends LocalizedEnumAdapter.LocalizedEnum>
    extends EnumAdapter {

  public LocalizedEnumAdapter(Context context, Class<T> enumType) {
    super(context, enumType);
  }

  @Override protected String getName(Enum item) {
    return getContext().getString(((LocalizedEnum) item).getStringResourceId());
  }

  // Interface for enums that need to be displayed to the userPreference
  interface LocalizedEnum {
    int getStringResourceId();
  }

  public enum State implements LocalizedEnum {
    Alberta("Alberta", R.string.alberta),
    BritishColombia("British Colombia", R.string.bc),
    Manitoba("Manitoba", R.string.mani),
    NewBrunswick("New Brunswick", R.string.newb),
    Newfoundland("Newfoundland", R.string.nfld),
    NorthWestTerritories("North West Territories", R.string.nwt),
    NovaScotia("Nova Scotia", R.string.novascot),
    Nunavut("Nunavut", R.string.nunavut),
    Ontario("Ontario", R.string.ontario),
    PrinceEdwardIsland("Prince Edward Island", R.string.pei),
    Quebec("Quebec", R.string.quebec),
    Saskatchewan("Saskatchewan", R.string.sask),
    Yukon("Yukon", R.string.yuk);

    public String value;
    int resourceId;

    State(String value, int resourceId) {
      this.value = value;
      this.resourceId = resourceId;
    }

    @Override public int getStringResourceId() {
      return resourceId;
    }
  }

  public enum Gender implements LocalizedEnum {
    MALE('m', R.string.male), FEMALE('f', R.string.female), UNSPECIFIED('u', R.string.unspecified);

    public char value;
    int resourceId;

    Gender(char value, int resourceId) {
      this.value = value;
      this.resourceId = resourceId;
    }

    @Override public int getStringResourceId() {
      return resourceId;
    }
  }
}
