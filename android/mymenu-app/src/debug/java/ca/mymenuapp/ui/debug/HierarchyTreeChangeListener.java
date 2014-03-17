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

package ca.mymenuapp.ui.debug;

import android.view.View;
import android.view.ViewGroup;

/**
 * A {@link android.view.ViewGroup.OnHierarchyChangeListener hierarchy change listener} which
 * recursively monitors an entire tree of views.
 */
public final class HierarchyTreeChangeListener implements ViewGroup.OnHierarchyChangeListener {
  private final ViewGroup.OnHierarchyChangeListener delegate;

  private HierarchyTreeChangeListener(ViewGroup.OnHierarchyChangeListener delegate) {
    if (delegate == null) {
      throw new NullPointerException("Delegate must not be null.");
    }
    this.delegate = delegate;
  }

  /**
   * Wrap a regular {@link android.view.ViewGroup.OnHierarchyChangeListener hierarchy change
   * listener} with one
   * that monitors an entire tree of views.
   */
  public static HierarchyTreeChangeListener wrap(ViewGroup.OnHierarchyChangeListener delegate) {
    return new HierarchyTreeChangeListener(delegate);
  }

  @Override public void onChildViewAdded(View parent, View child) {
    delegate.onChildViewAdded(parent, child);

    if (child instanceof ViewGroup) {
      ViewGroup childGroup = (ViewGroup) child;
      childGroup.setOnHierarchyChangeListener(this);
      for (int i = 0; i < childGroup.getChildCount(); i++) {
        onChildViewAdded(childGroup, childGroup.getChildAt(i));
      }
    }
  }

  @Override public void onChildViewRemoved(View parent, View child) {
    if (child instanceof ViewGroup) {
      ViewGroup childGroup = (ViewGroup) child;
      for (int i = 0; i < childGroup.getChildCount(); i++) {
        onChildViewRemoved(childGroup, childGroup.getChildAt(i));
      }
      childGroup.setOnHierarchyChangeListener(null);
    }

    delegate.onChildViewRemoved(parent, child);
  }
}
