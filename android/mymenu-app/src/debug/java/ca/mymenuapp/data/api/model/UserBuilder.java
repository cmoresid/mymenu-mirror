/*
 * Copyright 2014 Prateek Srivastava (@f2prateek)
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

package ca.mymenuapp.data.api.model;

class UserBuilder {
  final User user;

  UserBuilder(long id) {
    user = new User();
    user.id = id;
  }

  UserBuilder email(String email) {
    user.email = email;
    return this;
  }

  UserBuilder firstName(String firstName) {
    user.firstName = firstName;
    return this;
  }

  UserBuilder lastName(String lastName) {
    user.lastName = lastName;
    return this;
  }

  UserBuilder password(String password) {
    user.password = password;
    return this;
  }

  UserBuilder city(String city) {
    user.city = city;
    return this;
  }

  UserBuilder locality(String locality) {
    user.locality = locality;
    return this;
  }

  UserBuilder country(String country) {
    user.country = country;
    return this;
  }

  UserBuilder gender(char gender) {
    user.gender = gender;
    return this;
  }

  UserBuilder birthday(int birthday) {
    user.birthday = birthday;
    return this;
  }

  UserBuilder birthmonth(int birthmonth) {
    user.birthmonth = birthmonth;
    return this;
  }

  UserBuilder birthyear(int birthyear) {
    user.birthyear = birthyear;
    return this;
  }

  UserBuilder facebookid(String facebookid) {
    user.facebookid = facebookid;
    return this;
  }

  User get() {
    return user;
  }
}
