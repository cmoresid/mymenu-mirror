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
import android.widget.Toast;
import butterknife.InjectView;
import butterknife.OnClick;
import ca.mymenuapp.MyMenuApi;
import ca.mymenuapp.R;
import ca.mymenuapp.data.ForUser;
import ca.mymenuapp.data.api.model.User;
import ca.mymenuapp.data.api.model.UserResponse;
import ca.mymenuapp.data.prefs.ObjectPreference;
import com.f2prateek.ln.Ln;
import javax.inject.Inject;
import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;

public class LoginActivity extends BaseActivity {
  @Inject MyMenuApi myMenuApi;
  @Inject @ForUser ObjectPreference<User> user;
  @InjectView(R.id.username) EditText username;
  @InjectView(R.id.password) EditText password;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    inflateView(R.layout.activity_login);
  }

  @OnClick(R.id.login) void onLoginClicked() {
    boolean hasError = false;

    if (TextUtils.isEmpty(username.getText())) {
      Ln.e("Username was blank.");
      username.setError(getString(R.string.required));
      hasError = true;
    } else {
      username.setError(null);
    }

    Editable pass = password.getText();
    if (TextUtils.isEmpty(pass)) {
      Ln.e("Password was blank.");
      password.setError(getString(R.string.required));
      hasError = true;
    } else if (pass.length() < 5) {
      Ln.e("Password too short.");
      password.setError(getString(R.string.password_length));
      hasError = true;
    } else {
      password.setError(null);
    }

    if (!hasError) {
      myMenuApi.getUser(
          String.format(MyMenuApi.GET_USER_QUERY, username.getText(), password.getText()),
          new Callback<UserResponse>() {
            @Override public void success(UserResponse userResponse, Response response) {
              user.set(userResponse.userList.get(0));
              Intent intent = new Intent(LoginActivity.this, MainActivity.class);
              intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
              startActivity(intent);
              finish();
            }

            @Override public void failure(RetrofitError error) {
              Ln.e(error.getCause());
              Toast.makeText(LoginActivity.this, R.string.login_fail, Toast.LENGTH_LONG).show();
            }
          });
    }
  }
}
