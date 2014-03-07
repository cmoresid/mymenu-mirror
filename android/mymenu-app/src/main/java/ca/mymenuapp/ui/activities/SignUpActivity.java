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

package ca.mymenuapp.ui.activities;

import android.app.DatePickerDialog;
import android.app.DialogFragment;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;
import butterknife.InjectView;
import butterknife.OnClick;
import ca.mymenuapp.MyMenuApi;
import ca.mymenuapp.R;
import ca.mymenuapp.data.ForUser;
import ca.mymenuapp.data.api.model.User;
import ca.mymenuapp.data.prefs.ObjectPreference;
import ca.mymenuapp.ui.fragments.DatePickerFragment;
import ca.mymenuapp.ui.misc.EnumAdapter;
import com.f2prateek.ln.Ln;
import java.text.DateFormat;
import java.util.Calendar;
import javax.inject.Inject;
import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;

/**
 * Activity that prompts a user to sign up.
 */
public class SignUpActivity extends BaseActivity implements DatePickerDialog.OnDateSetListener {

  @Inject MyMenuApi myMenuApi;
  @Inject @ForUser ObjectPreference<User> userPreference;

  User user = new User();
  Calendar birthDate;

  @InjectView(R.id.email) EditText emailText;
  @InjectView(R.id.password) EditText passwordText;
  @InjectView(R.id.confirm_password) EditText confirmPasswordText;
  @InjectView(R.id.given_name) EditText givenNameText;
  @InjectView(R.id.surname) EditText surnameText;
  @InjectView(R.id.locality) Spinner localitySpinner;
  @InjectView(R.id.city) Spinner citySpinner;
  @InjectView(R.id.birthdate) TextView birthdateText;
  @InjectView(R.id.gender) Spinner genderSpinner;

  @Override protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    inflateView(R.layout.activity_sign_up);

    citySpinner.setAdapter(new EnumAdapter<>(this, City.class));
    localitySpinner.setAdapter(new EnumAdapter<>(this, State.class));
    genderSpinner.setAdapter(new EnumAdapter<>(this, Gender.class));
  }

  @OnClick(R.id.birthdate) public void onDateClicked() {
    DialogFragment newFragment = new DatePickerFragment();
    newFragment.show(getFragmentManager(), "datePicker");
  }

  @Override public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
    birthDate = Calendar.getInstance();
    birthDate.set(Calendar.DAY_OF_MONTH, dayOfMonth);
    birthDate.set(Calendar.MONTH, monthOfYear);
    birthDate.set(Calendar.YEAR, year);
    birthdateText.setText(DateFormat.getDateInstance().format(birthDate.getTime()));
  }

  @OnClick(R.id.sign_up) public void onSignUpClicked() {
    boolean hasError = false;

    hasError |= isEmpty(emailText);
    hasError |= validatePassword(passwordText);
    hasError |= validatePassword(confirmPasswordText);

    if (passwordText.getText().toString().compareTo(confirmPasswordText.getText().toString())
        != 0) {
      hasError = true;
      confirmPasswordText.setError(getString(R.string.passwords_do_not_match));
    } else {
      confirmPasswordText.setError(null);
    }

    hasError |= isEmpty(givenNameText);
    hasError |= isEmpty(surnameText);

    if (birthDate == null) {
      hasError = true;
      Toast.makeText(this, R.string.birthday_required, Toast.LENGTH_LONG).show();
    }

    if (!hasError) {
      user.email = emailText.getText().toString();
      user.firstName = givenNameText.getText().toString();
      user.lastName = surnameText.getText().toString();
      user.password = passwordText.getText().toString();
      user.city = ((City) citySpinner.getSelectedItem()).value;
      user.locality = ((State) localitySpinner.getSelectedItem()).value;
      user.country = "can"; // todo, show user

      user.birthday = birthDate.get(Calendar.DAY_OF_MONTH);
      user.birthmonth = birthDate.get(Calendar.MONTH);
      user.birthyear = birthDate.get(Calendar.YEAR);
      user.gender = ((Gender) genderSpinner.getSelectedItem()).value;

      setProgressBarIndeterminateVisibility(true);
      myMenuApi.createUser(user.email, user.firstName, user.lastName, user.password, user.city,
          user.locality, user.country, user.gender, user.birthday, user.birthmonth, user.birthyear,
          new Callback<Response>() {
            @Override public void success(Response response, Response response2) {
              setProgressBarIndeterminateVisibility(false);
              userPreference.set(user);
              Intent intent = new Intent(SignUpActivity.this, MainActivity.class);
              intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
              startActivity(intent);
              finish();
            }

            @Override public void failure(RetrofitError error) {
              setProgressBarIndeterminateVisibility(false);
              Ln.e(error.getCause());
            }
          }
      );
    }
  }

  boolean validatePassword(EditText editText) {
    boolean hasError = false;
    hasError |= isEmpty(editText);
    Editable pass = editText.getText();
    if (!hasError) {
      if (pass.length() < 5) {
        Ln.e("Password too short.");
        editText.setError(getString(R.string.password_length));
        hasError = true;
      } else {
        editText.setError(null);
      }
    }
    return hasError;
  }

  boolean isEmpty(EditText editText) {
    boolean hasError = false;
    if (TextUtils.isEmpty(editText.getText())) {
      Ln.e("Email was blank.");
      editText.setError(getString(R.string.required));
      hasError = true;
    } else {
      editText.setError(null);
    }
    return hasError;
  }

  enum City implements LocalizedEnum {
    EDMONTON("Edmonton", R.string.edmonton);

    String value;
    int resourceId;

    City(String value, int resourceId) {
      this.value = value;
      this.resourceId = resourceId;
    }

    @Override public int getStringResourceId() {
      return resourceId;
    }
  }

  enum Gender implements LocalizedEnum {
    MALE('m', R.string.male), FEMALE('f', R.string.female), UNSPECIFIED('u', R.string.unspecified);

    char value;
    int resourceId;

    Gender(char value, int resourceId) {
      this.value = value;
      this.resourceId = resourceId;
    }

    @Override public int getStringResourceId() {
      return resourceId;
    }
  }

  enum State implements LocalizedEnum {
    Alberta("Alberta", R.string.alberta);

    String value;
    int resourceId;

    State(String value, int resourceId) {
      this.value = value;
      this.resourceId = resourceId;
    }

    @Override public int getStringResourceId() {
      return resourceId;
    }
  }

  // Interface for enums that need to be displayed to the user
  interface LocalizedEnum {
    int getStringResourceId();
  }

  /**
   * An {@link ca.mymenuapp.ui.misc.EnumAdapter} that can display localized strings.
   */
  class DisplayEnumAdapter<T extends LocalizedEnum> extends EnumAdapter {

    DisplayEnumAdapter(Context context, Class<T> enumType) {
      super(context, enumType);
    }

    @Override protected String getName(Enum item) {
      return getString(((LocalizedEnum) item).getStringResourceId());
    }
  }
}
