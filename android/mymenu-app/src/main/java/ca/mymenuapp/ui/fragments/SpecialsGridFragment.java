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

package ca.mymenuapp.ui.fragments;

import android.content.Context;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import butterknife.ButterKnife;
import butterknife.InjectView;
import ca.mymenuapp.R;
import ca.mymenuapp.data.MyMenuDatabase;
import ca.mymenuapp.data.api.model.MenuSpecial;
import ca.mymenuapp.data.rx.EndlessObserver;
import ca.mymenuapp.ui.misc.BindableListAdapter;
import ca.mymenuapp.ui.widgets.SlidingUpPanelLayout;
import com.f2prateek.ln.Ln;
import com.squareup.picasso.Picasso;
import com.squareup.timessquare.CalendarPickerView;
import com.tonicartos.widget.stickygridheaders.StickyGridHeadersGridView;
import com.tonicartos.widget.stickygridheaders.StickyGridHeadersSimpleAdapter;
import java.text.DateFormat;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import javax.inject.Inject;
import rx.Observable;
import rx.android.schedulers.AndroidSchedulers;
import rx.schedulers.Schedulers;
import rx.util.functions.Func1;
import rx.util.functions.Func2;

public class SpecialsGridFragment extends BaseFragment
    implements CalendarPickerView.OnDateSelectedListener {

  @Inject MyMenuDatabase myMenuDatabase;
  @Inject Picasso picasso;

  @InjectView(R.id.specials_grid) StickyGridHeadersGridView gridView;
  @InjectView(R.id.sliding_layout) SlidingUpPanelLayout slidingUpPanelLayout;
  @InjectView(R.id.specials_date_range) TextView dateRangeText;
  @InjectView(R.id.calendar_view) CalendarPickerView calendarPickerView;

  Date selectedStart;
  Date selectedEnd;

  // different from what is fetched from the network, may contain duplicates,
  // e.g. Wings on Tuesday and Wednesday
  List<MenuSpecial> displayedSpecials;

  MenuItem filterDrinksMenuItem;
  MenuItem filterEntreesMenuItem;
  MenuItem filterDessertsMenuItem;

  @Override public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    setHasOptionsMenu(true);
  }

  @Override public View onCreateView(LayoutInflater inflater, ViewGroup container,
      Bundle savedInstanceState) {
    return inflater.inflate(R.layout.fragment_specials_grid, container, false);
  }

  @Override public void onViewCreated(View view, Bundle savedInstanceState) {
    super.onViewCreated(view, savedInstanceState);
    slidingUpPanelLayout.setDragView(dateRangeText);

    // Date range to allow user to select, between today and one year
    Calendar startDisplayDate = Calendar.getInstance();
    Calendar endDisplayDate = Calendar.getInstance();
    endDisplayDate.add(Calendar.YEAR, 1);

    // Date range to display - one week ahead (this + 6 days = one week) ahead
    final Calendar start = Calendar.getInstance();
    final Calendar end = Calendar.getInstance();
    end.add(Calendar.DATE, 6);

    calendarPickerView.init(startDisplayDate.getTime(), endDisplayDate.getTime())
        .inMode(CalendarPickerView.SelectionMode.RANGE)
        .withSelectedDates(Arrays.asList(start.getTime(), end.getTime()));
    dateRangeText.setText(getString(R.string.date_range_text,
            DateFormat.getDateInstance().format(startDisplayDate.getTime()),
            DateFormat.getDateInstance().format(end.getTime()))
    );

    calendarPickerView.setOnDateSelectedListener(this);
  }

  @Override public void onActivityCreated(Bundle savedInstanceState) {
    super.onActivityCreated(savedInstanceState);

    // fetch from the network one week ahead (this + 6 days = one week)
    final Calendar start = Calendar.getInstance();
    final Calendar end = Calendar.getInstance();
    end.add(Calendar.DATE, 6);
    fetchSpecialsForDateRange(start.getTime(), end.getTime());
  }

  /**
   * Fetch from the network
   */
  private void fetchSpecialsForDateRange(final Date start, final Date end) {
    myMenuDatabase.getSpecialsForDateRange(start, end, new EndlessObserver<List<MenuSpecial>>() {
          @Override public void onNext(List<MenuSpecial> menuSpecials) {
            generateList(start, end, menuSpecials);
            if (filterDrinksMenuItem == null) {
              // don't filter if menu isn't ready yet.
              gridView.setAdapter(new SpecialsAdapter(activityContext, displayedSpecials, picasso));
            } else {
              filterMenuItemsAndDisplay();
            }
          }
        }
    );
  }

  /**
   * We loop over each date from startDate to endDAte
   * For each of these date, we look over the list of specials and add them to our sorted list.
   * We add a special for a date if it matches the day of the date for occurtype 1 specials, and
   * we add add the specials if the startDate<date<endDate
   *
   * At the end, all or sorted by date and returned.
   * By design, it will contain duplicates.
   */
  private void generateList(Date startDate, Date endDate, List<MenuSpecial> specials) {
    displayedSpecials = new ArrayList<>();

    // Calendar instances to iterate
    Calendar currentCalendar = Calendar.getInstance();
    currentCalendar.setTime(startDate);
    Calendar endCalendar = Calendar.getInstance();
    endCalendar.setTime(endDate);

    while (!currentCalendar.after(endCalendar)) {
      String today = MenuSpecial.getDayStringForDay(currentCalendar.get(Calendar.DAY_OF_WEEK));

      for (MenuSpecial special : specials) {
        if (special.occurType == MenuSpecial.OCCUR_TYPE_RECURRING) {
          // see if this day matches the special day
          if (special.weekday.compareToIgnoreCase(today) == 0) {
            displayedSpecials.add(new MenuSpecial(special, currentCalendar.getTime()));
          }
        } else if (special.occurType == MenuSpecial.OCCUR_TYPE_WINDOW) {
          try {
            Calendar specialStart = Calendar.getInstance();
            specialStart.setTime(MenuSpecial.DATE_FORMAT.parse(special.startDate));
            Calendar specialEnd = Calendar.getInstance();
            specialEnd.setTime(MenuSpecial.DATE_FORMAT.parse(special.endDate));
            if (currentCalendar.after(specialStart) && currentCalendar.before(specialEnd)) {
              displayedSpecials.add(new MenuSpecial(special, currentCalendar.getTime()));
            }
          } catch (ParseException e) {
            e.printStackTrace();
            Ln.e(e);
            displayedSpecials.add(new MenuSpecial(special, currentCalendar.getTime()));
          }
        }
      }

      currentCalendar.add(Calendar.DATE, 1);
    }

    Collections.sort(displayedSpecials, new Comparator<MenuSpecial>() {
      @Override public int compare(MenuSpecial lhs, MenuSpecial rhs) {
        return lhs.startDate.compareTo(rhs.startDate);
      }
    });
  }

  @Override public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
    super.onCreateOptionsMenu(menu, inflater);
    inflater.inflate(R.menu.fragment_specials_grid, menu);
    filterDrinksMenuItem = menu.findItem(R.id.specials_filter_drinks);
    filterDrinksMenuItem.setChecked(true);
    filterEntreesMenuItem = menu.findItem(R.id.specials_filter_entrees);
    filterEntreesMenuItem.setChecked(true);
    filterDessertsMenuItem = menu.findItem(R.id.specials_filter_desserts);
    filterDessertsMenuItem.setChecked(true);
  }

  @Override public boolean onOptionsItemSelected(MenuItem item) {
    switch (item.getItemId()) {
      case R.id.specials_filter_drinks:
        filterDrinksMenuItem.setChecked(!filterDrinksMenuItem.isChecked());
        filterMenuItemsAndDisplay();
        break;
      case R.id.specials_filter_entrees:
        filterEntreesMenuItem.setChecked(!filterEntreesMenuItem.isChecked());
        filterMenuItemsAndDisplay();
        break;
      case R.id.specials_filter_desserts:
        filterDessertsMenuItem.setChecked(!filterDessertsMenuItem.isChecked());
        filterMenuItemsAndDisplay();
        break;
      default:
        return super.onOptionsItemSelected(item);
    }

    return true;
  }

  /**
   * Filters menu specials in memory and displays them to the user.
   */
  private void filterMenuItemsAndDisplay() {
    final boolean includeDrinks = filterDrinksMenuItem.isChecked();
    final boolean includeEntrees = filterEntreesMenuItem.isChecked();
    final boolean includeDesserts = filterDessertsMenuItem.isChecked();
    Ln.d("Include drinks(%s), entrees(%s), desserts(%s).", includeDrinks, includeEntrees,
        includeDesserts);
    Observable.from(displayedSpecials)
        .filter(new Func1<MenuSpecial, Boolean>() {
          @Override public Boolean call(MenuSpecial menuSpecial) {
            switch (menuSpecial.categoryId) {
              case MenuSpecial.CATEGORY_DRINK:
                return includeDrinks;
              case MenuSpecial.CATEGORY_ENTREE:
                return includeEntrees;
              case MenuSpecial.CATEGORY_DESSERT:
                return includeDesserts;
              default:
                return false;
            }
          }
        })
        .toSortedList(new Func2<MenuSpecial, MenuSpecial, Integer>() {
          @Override public Integer call(MenuSpecial lhs, MenuSpecial rhs) {
            return lhs.startDate.compareTo(rhs.startDate);
          }
        })
        .subscribeOn(Schedulers.computation())
        .observeOn(AndroidSchedulers.mainThread())
        .subscribe(new EndlessObserver<List<MenuSpecial>>() {
          @Override public void onNext(List<MenuSpecial> filteredSpecials) {
            gridView.setAdapter(new SpecialsAdapter(activityContext, filteredSpecials, picasso));
          }
        });
  }

  @Override public void onDateSelected(Date date) {
    Ln.d("Selected " + date);
    if (selectedStart == null) {
      selectedStart = date;
      dateRangeText.setText(getString(R.string.date_range_prompt));
    } else {
      selectedEnd = date;
      fetchSpecialsForDateRange(selectedStart, selectedEnd);
      dateRangeText.setText(
          getString(R.string.date_range_text, DateFormat.getDateInstance().format(selectedStart),
              DateFormat.getDateInstance().format(selectedEnd))
      );
      selectedStart = null; // clear out first selection
      slidingUpPanelLayout.collapsePane();
    }
  }

  @Override public void onDateUnselected(Date date) {
    Ln.d("Unselected " + date);
  }

  static class SpecialsAdapter extends BindableListAdapter<MenuSpecial>
      implements StickyGridHeadersSimpleAdapter {

    final Picasso picasso;

    public SpecialsAdapter(Context context, List<MenuSpecial> specials, Picasso picasso) {
      super(context, specials);
      this.picasso = picasso;
    }

    @Override public long getItemId(int position) {
      return getItem(position).id;
    }

    @Override public View newView(LayoutInflater inflater, int position, ViewGroup container) {
      View view = inflater.inflate(R.layout.adapter_specials_grid_item, container, false);
      ViewHolder viewHolder = new ViewHolder(view);
      view.setTag(viewHolder);
      return view;
    }

    @Override public void bindView(MenuSpecial item, int position, View view) {
      ViewHolder holder = (ViewHolder) view.getTag();
      holder.name.setText(item.name);
      holder.description.setText(item.description);
      picasso.load(item.picture).fit().centerCrop().into(holder.picture);
    }

    @Override public long getHeaderId(int position) {
      return getItem(position).displayDate.getTime();
    }

    @Override public View getHeaderView(int position, View convertView, ViewGroup parent) {
      HeaderViewHolder headerViewHolder;
      if (convertView == null) {
        convertView = inflater.inflate(R.layout.specials_grid_header_sticky, parent, false);
        headerViewHolder = new HeaderViewHolder(convertView);
        convertView.setTag(headerViewHolder);
      } else {
        headerViewHolder = (HeaderViewHolder) convertView.getTag();
      }

      headerViewHolder.dateLabel.setText(
          DateFormat.getDateInstance().format(getItem(position).displayDate));
      return convertView;
    }

    static class ViewHolder {
      @InjectView(R.id.special_picture) ImageView picture;
      @InjectView(R.id.special_name) TextView name;
      @InjectView(R.id.special_description) TextView description;

      ViewHolder(View root) {
        ButterKnife.inject(this, root);
      }
    }

    static class HeaderViewHolder {
      @InjectView(R.id.date_label) TextView dateLabel;

      HeaderViewHolder(View root) {
        ButterKnife.inject(this, root);
      }
    }
  }
}
