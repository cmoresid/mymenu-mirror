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
import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import butterknife.InjectView;
import butterknife.OnClick;
import ca.mymenuapp.R;
import ca.mymenuapp.data.MyMenuDatabase;
import ca.mymenuapp.data.api.model.User;
import ca.mymenuapp.data.prefs.ObjectPreference;
import ca.mymenuapp.data.rx.EndlessObserver;
import ca.mymenuapp.ui.adapters.LocalizedEnumAdapter;
import ca.mymenuapp.ui.fragments.DatePickerFragment;
import ca.mymenuapp.util.Strings;
import com.f2prateek.ln.Ln;
import de.keyboardsurfer.android.widget.crouton.Crouton;
import de.keyboardsurfer.android.widget.crouton.Style;
import java.text.DateFormat;
import java.util.Calendar;
import javax.inject.Inject;
import javax.inject.Named;
import retrofit.client.Response;

import static android.content.Intent.FLAG_ACTIVITY_CLEAR_TASK;
import static android.content.Intent.FLAG_ACTIVITY_NEW_TASK;
import static ca.mymenuapp.data.DataModule.USER_PREFERENCE;

/**
 * Activity that prompts a userPreference to sign up.
 */
public class SignUpActivity extends BaseActivity implements DatePickerDialog.OnDateSetListener {

  @Inject MyMenuDatabase myMenuDatabase;
  @Inject @Named(USER_PREFERENCE) ObjectPreference<User> userPreference;

  User user = new User();
  Calendar birthDate;

  @InjectView(R.id.email) EditText emailText;
  @InjectView(R.id.password) EditText passwordText;
  @InjectView(R.id.confirm_password) EditText confirmPasswordText;
  @InjectView(R.id.given_name) EditText givenNameText;
  @InjectView(R.id.surname) EditText surnameText;
  @InjectView(R.id.locality) Spinner localitySpinner;
  @InjectView(R.id.birthdate) TextView birthdateText;
  @InjectView(R.id.gender) Spinner genderSpinner;
  @InjectView(R.id.city) EditText cityText;

  @Override protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    inflateView(R.layout.activity_sign_up);

    localitySpinner.setAdapter(new LocalizedEnumAdapter<>(this, LocalizedEnumAdapter.State.class));
    genderSpinner.setAdapter(new LocalizedEnumAdapter<>(this, LocalizedEnumAdapter.Gender.class));
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

    if (!hasError) {
      if (!Strings.isEmail(emailText.getText().toString())) {
        hasError = false;
        emailText.setError(getString(R.string.invalid));
      } else {
        emailText.setError(null);
      }
    }

    hasError |= validatePassword(passwordText);
    hasError |= validatePassword(confirmPasswordText);

    if (passwordText.getText().toString().compareTo(confirmPasswordText.getText().toString())
        != 0) {
      hasError = true;
      confirmPasswordText.setError(getString(R.string.passwords_do_not_match));
    } else {
      confirmPasswordText.setError(null);
    }

    if (!hasError) {
      if (passwordText.getText().toString().compareTo(confirmPasswordText.getText().toString())
          != 0) {
        hasError = true;
        confirmPasswordText.setError(getString(R.string.passwords_do_not_match));
      } else {
        confirmPasswordText.setError(null);
      }
    }

    hasError |= isEmpty(givenNameText);
    hasError |= isEmpty(surnameText);

    if (birthDate == null) {
      hasError = true;
      Crouton.makeText(this, R.string.birthday_required, Style.ALERT).show();
    }
    if (isEmpty(cityText)) {
      hasError = true;
      Crouton.makeText(this, R.string.city_required, Style.ALERT).show();
    }

    if (!hasError) {
      user.email = emailText.getText().toString();
      user.firstName = givenNameText.getText().toString();
      user.lastName = surnameText.getText().toString();
      user.password = passwordText.getText().toString();
      user.city = cityText.getText().toString();
      user.locality = ((LocalizedEnumAdapter.State) localitySpinner.getSelectedItem()).value;
      user.country = "can"; // todo, show userPreference

      user.birthday = birthDate.get(Calendar.DAY_OF_MONTH);
      user.birthmonth = birthDate.get(Calendar.MONTH);
      user.birthyear = birthDate.get(Calendar.YEAR);
      user.gender = ((LocalizedEnumAdapter.Gender) genderSpinner.getSelectedItem()).value;

      setProgressBarIndeterminateVisibility(true);

      myMenuDatabase.createUser(user, new EndlessObserver<Response>() {
        @Override public void onNext(Response response) {
          setProgressBarIndeterminateVisibility(false);
          userPreference.set(user);
          Intent intent = new Intent(SignUpActivity.this, MainActivity.class);
          intent.setFlags(FLAG_ACTIVITY_CLEAR_TASK | FLAG_ACTIVITY_NEW_TASK);
          startActivity(intent);
          finish();
        }
      });
    }
  }

  private boolean validatePassword(EditText passwordText) {
    boolean hasError = false;
    hasError |= isEmpty(passwordText);
    if (!hasError) {
      Editable pass = passwordText.getText();
      if (pass.length() < 5) {
        Ln.e("Password too short.");
        passwordText.setError(getString(R.string.password_length));
        hasError = true;
      } else {
        passwordText.setError(null);
      }
    }
    return hasError;
  }

  private boolean isEmpty(EditText editText) {
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
}
