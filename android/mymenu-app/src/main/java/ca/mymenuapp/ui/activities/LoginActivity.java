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

import android.content.Intent;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.widget.EditText;
import butterknife.InjectView;
import butterknife.OnClick;
import ca.mymenuapp.R;
import ca.mymenuapp.data.MyMenuDatabase;
import ca.mymenuapp.data.api.model.User;
import ca.mymenuapp.data.prefs.ObjectPreference;
import ca.mymenuapp.data.rx.EndlessObserver;
import com.f2prateek.ln.Ln;
import javax.inject.Inject;
import javax.inject.Named;

import static ca.mymenuapp.data.DataModule.USER_PREFERENCE;

/**
 * Activity that prompts a userPreference to login with their credentials.
 * This will be first view seen by the user, if they are logged in, we open up MainActivity
 * TODO: facebook login
 */
public class LoginActivity extends BaseActivity {
  @Inject MyMenuDatabase myMenuDatabase;
  @Inject @Named(USER_PREFERENCE) ObjectPreference<User> userPreference;
  @InjectView(R.id.email) EditText emailText;
  @InjectView(R.id.password) EditText passwordText;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    inflateView(R.layout.activity_login);

    if (userPreference.get() != null) {
      Intent intent = new Intent(this, MainActivity.class);
      startActivity(intent);
      finish();
    }
  }

  @OnClick(R.id.sign_up) void onSignUpClicked() {
    Intent intent = new Intent(this, SignUpActivity.class);
    intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
    startActivity(intent);
    finish();
  }

  @OnClick(R.id.login) void onLoginClicked() {
    boolean hasError = false;

    if (TextUtils.isEmpty(emailText.getText())) {
      emailText.setError(getString(R.string.required));
      hasError = true;
    } else {
      emailText.setError(null);
    }

    Editable pass = passwordText.getText();
    if (TextUtils.isEmpty(pass)) {
      passwordText.setError(getString(R.string.required));
      hasError = true;
    } else if (pass.length() < 5) {
      passwordText.setError(getString(R.string.password_length));
      hasError = true;
    } else {
      passwordText.setError(null);
    }

    if (!hasError) {
      setProgressBarIndeterminateVisibility(true);
      final String email = emailText.getText().toString();
      final String password = passwordText.getText().toString();
      myMenuDatabase.getUser(email, password, new EndlessObserver<User>() {
        @Override public void onNext(User user) {
          setProgressBarIndeterminateVisibility(false);
          userPreference.set(user);
          Intent intent = new Intent(LoginActivity.this, MainActivity.class);
          intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
          startActivity(intent);
          finish();
        }
      });
    }
  }
}
