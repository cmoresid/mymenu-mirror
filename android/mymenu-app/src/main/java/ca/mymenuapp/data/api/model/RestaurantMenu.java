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

package ca.mymenuapp.data.api.model;

import com.f2prateek.ln.Ln;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

/**
 * A model class that categorizes menu items by categories.
 * We need consistent ordering so we wrap it in this class.
 */
public class RestaurantMenu {

  private static final Random random = new Random();
  private final Restaurant restaurant;
  private final List<MenuItemReview> reviews;
  private final HashMap<Long, List<MenuItem>> menu;
  private final Long[] keySet; // indexes the order
  private final Map<Long, MenuCategory> categories;

  private long lastCategory = 0;

  /**
   * Categories must be sorted by the order we want to display them in.
   */
  private RestaurantMenu(Restaurant restaurant, List<MenuItemReview> reviews,
      LinkedHashMap<Long, List<MenuItem>> menu, Map<Long, MenuCategory> categories) {
    this.restaurant = restaurant;
    this.reviews = reviews;
    this.menu = menu;
    this.keySet = menu.keySet().toArray(new Long[menu.keySet().size()]);
    this.categories = categories;
  }

  public static RestaurantMenu generate(Restaurant restaurant, List<MenuItem> menuItems,
      List<MenuCategory> menuCategories, List<MenuItemReview> reviews) {
    LinkedHashMap<Long, List<MenuItem>> menu = new LinkedHashMap<>();
    for (MenuItem menuItem : menuItems) {
      if (!menu.containsKey(menuItem.categoryId)) {
        menu.put(menuItem.categoryId, new ArrayList<MenuItem>());
      }
      menu.get(menuItem.categoryId).add(menuItem);
    }



    Map<Long, MenuCategory> categoryMap = new HashMap<>();
    for (MenuCategory menuCategory : menuCategories) {
      categoryMap.put(menuCategory.id, menuCategory);
    }

    return new RestaurantMenu(restaurant, reviews, menu, categoryMap);
  }

  /**
   * Return the number of categories in this menu.
   */
  public int getCategoryCount() {
    return keySet.length;
  }

  /**
   * Get all menu items for this category.
   */
  public List<MenuItem> getMenuItemsByCategory(MenuCategory category) {
    return menu.get(category.id);
  }

  /**
   * Get restaurant.
   */
  public Restaurant getRestaurant() {
    return restaurant;
  }

  public List<MenuItemReview> getReviews() {
    return reviews;
  }

  /**
   * This is the main reason why we have this class!
   * Simply look up the category (which is ordered).
   */
  public List<MenuItem> getMenuItemsByCategory(int position) {
    return menu.get(keySet[position]);
  }

  /**
   * Pick a random menu item.
   * Two sequential calls are guaranteed to return unique items.
   * todo: currently requires at least two categories to work!
   */
  public MenuItem getRandomMenuItem() {
    long category;
    if (keySet.length > 1) {
      while ((category = keySet[random.nextInt(keySet.length)]) == lastCategory) {
        // wait until we find a unique category
      }
    } else {
      category = keySet[0];
    }
    lastCategory = category;
    List<MenuItem> menuItems = menu.get(category);
    return menuItems.get(random.nextInt(menuItems.size()));
  }

  /**
   * Simply look up the category (which is ordered).
   */
  public String getCategoryTitle(int position) {
    return categories.get(keySet[position]).name;
  }

  @Override public String toString() {
    return "RestaurantMenu{" +
        "menu=" + menu +
        ", categories=" + categories +
        '}';
  }
}
