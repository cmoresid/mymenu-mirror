package ca.mymenuapp.ui.fragments;

import android.os.Bundle;
import android.text.Editable;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;
import butterknife.InjectView;
import butterknife.OnClick;
import ca.mymenuapp.R;
import ca.mymenuapp.data.MyMenuDatabase;
import ca.mymenuapp.data.api.model.User;
import ca.mymenuapp.data.prefs.ObjectPreference;
import ca.mymenuapp.data.rx.EndlessObserver;
import ca.mymenuapp.ui.adapters.LocalizedEnumAdapter;
import com.f2prateek.ln.Ln;
import javax.inject.Inject;
import javax.inject.Named;
import retrofit.client.Response;

import static ca.mymenuapp.data.DataModule.USER_PREFERENCE;

/**
 * A fragment where users can update/edit their account information.
 */
public class SettingsFragment extends BaseFragment {

  @Inject MyMenuDatabase myMenuDatabase;
  @Inject @Named(USER_PREFERENCE) ObjectPreference<User> userPreference;

  @InjectView(R.id.settings_name) TextView givenNameText;
  @InjectView(R.id.settings_password) EditText passwordText;
  @InjectView(R.id.settings_confirm_password) EditText confirmPasswordText;
  @InjectView(R.id.settings_firstname) EditText firstName;
  @InjectView(R.id.settings_lastname) EditText lastName;
  @InjectView(R.id.settings_locality) Spinner localitySpinner;
  @InjectView(R.id.settings_city) EditText cityText;
  private User user;

  @Override
  public View onCreateView(LayoutInflater inflater, ViewGroup container,
      Bundle savedInstanceState) {
    return inflater.inflate(R.layout.fragment_settings, container, false);
  }

  @Override
  public void onViewCreated(View view, Bundle savedInstanceState) {
    super.onViewCreated(view, savedInstanceState);
  }

  @Override public void onStart() {
    super.onStart();
    user = userPreference.get();
    firstName.setText(user.firstName);
    lastName.setText(user.lastName);
    cityText.setText(user.city);
    givenNameText.setText("Welcome, " + user.firstName + " " + user.lastName + ".");
    localitySpinner.setAdapter(
        new LocalizedEnumAdapter<>(getActivity(), LocalizedEnumAdapter.State.class));
  }

  @OnClick(R.id.settings_save) public void onSaveClicked() {
    boolean hasError = false;
    boolean passwordSet = false;

    if (!TextUtils.isEmpty(passwordText.getText())) {
      passwordSet = true;
      hasError |= validatePassword(passwordText);
      hasError |= validatePassword(confirmPasswordText);

      if (passwordText.getText().toString().compareTo(confirmPasswordText.getText().toString())
          != 0) {
        hasError = true;
        confirmPasswordText.setError(getString(R.string.passwords_do_not_match));
      } else {
        confirmPasswordText.setError(null);
      }
      if (validatePassword(passwordText) && validatePassword(confirmPasswordText)) {
        if (passwordText.getText().toString().compareTo(confirmPasswordText.getText().toString())
            != 0) {
          hasError = true;
          confirmPasswordText.setError(getString(R.string.passwords_do_not_match));
        } else {
          confirmPasswordText.setError(null);
        }
      }
    }
    if (isEmpty(firstName)) {
      hasError = true;
      firstName.setError(getString(R.string.required));
    } else if (isEmpty(lastName)) {
      hasError = true;
      lastName.setError(getString(R.string.required));
    }
    if (isEmpty(cityText)) {
      hasError = true;
      cityText.setError(getString(R.string.required));
    }

    if (!hasError) {
      if (passwordSet) {
        user.password = passwordText.getText().toString();
      }
      user.city = cityText.getText().toString();
      user.locality = ((LocalizedEnumAdapter.State) localitySpinner.getSelectedItem()).value;
      user.firstName = firstName.getText().toString();
      user.lastName = lastName.getText().toString();
      /* At this point there is no error so we can update the database's user */
      myMenuDatabase.editUser(user, new EndlessObserver<Response>() {
        @Override public void onNext(Response response) {
          Toast.makeText(getActivity(), "Preferences Saved.", Toast.LENGTH_LONG).show();
          userPreference.set(user);
        }
      });
    }
  }

  private boolean validatePassword(EditText passwordText) {
    boolean hasError;
    hasError = isEmpty(passwordText);

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
      editText.setError(getString(R.string.required));
      hasError = true;
    } else {
      editText.setError(null);
    }
    return hasError;
  }
}
