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
