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
