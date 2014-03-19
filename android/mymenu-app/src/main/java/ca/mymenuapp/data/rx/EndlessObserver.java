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

package ca.mymenuapp.data.rx;

import com.f2prateek.ln.Ln;
import rx.Observer;

public abstract class EndlessObserver<T> implements Observer<T> {
  @Override public void onCompleted() {
  }

  @Override public void onError(Throwable throwable) {
    Ln.e(throwable);
    Ln.e(throwable.getCause());
  }
}