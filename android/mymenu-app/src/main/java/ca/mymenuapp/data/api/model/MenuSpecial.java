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

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import org.simpleframework.xml.Element;
import org.simpleframework.xml.Root;

@Root(name = "result")
public class MenuSpecial {

  public static final DateFormat DATE_FORMAT = new SimpleDateFormat("yyyy-mm-dd");

  public static final int OCCUR_TYPE_RECURRING = 1;
  public static final int OCCUR_TYPE_WINDOW = 2;

  public static final int CATEGORY_ENTREE = 1;
  public static final int CATEGORY_DRINK = 2;
  public static final int CATEGORY_DESSERT = 3;

  @Element(name = "id") public long id;
  @Element(name = "merchid") public long merchantId;
  @Element(name = "business", required = false) public String business;
  @Element(name = "name", required = false) public String name;
  @Element(name = "description", required = false) public String description;
  @Element(name = "picture", required = false) public String picture;
  @Element(name = "occurType", required = false) public int occurType;
  @Element(name = "weekday", required = false) public String weekday;
  @Element(name = "startdate", required = false) public String startDate;
  @Element(name = "enddate", required = false) public String endDate;
  @Element(name = "categoryid", required = false) public int categoryId;

  @Element(name = "displayDate", required = false) public Date displayDate;

  // Copy Constructor
  public MenuSpecial(MenuSpecial special, Date displayDate) {
    this.id = special.id;
    this.merchantId = special.merchantId;
    this.business = special.business;
    this.name = special.name;
    this.description = special.description;
    this.picture = special.picture;
    this.occurType = special.occurType;
    this.weekday = special.weekday;
    this.startDate = special.startDate;
    this.endDate = special.endDate;
    this.categoryId = special.categoryId;
    this.displayDate = displayDate;
  }

  public MenuSpecial() {
    // default constructor
  }

  public static String getDayStringForDay(int day) {
    switch (day) {
      case Calendar.MONDAY:
        return "monday";
      case Calendar.TUESDAY:
        return "tuesday";
      case Calendar.WEDNESDAY:
        return "wednesday";
      case Calendar.THURSDAY:
        return "thursday";
      case Calendar.FRIDAY:
        return "friday";
      case Calendar.SATURDAY:
        return "saturday";
      case Calendar.SUNDAY:
        return "sunday";
      default:
        throw new IllegalArgumentException("Day should not be " + day);
    }
  }
}
