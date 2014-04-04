### Create New Account (Sign Up)
User Stories: 1, 4
This script inherently also includes the user story : Set a default location.

Preconditions: This is the first run of the app, or no user is logged in.

1. Launch App
![launch](android-test-assets/createAccount/1.png?raw=true)

2. Click Sign Up to Open Sign Up Screen
![sign_up](android-test-assets/createAccount/2.png?raw=true)

3. Fill in all fields with valid data. See sample below.
```
email: test@gmail.com (must be a valid email, and not same as an existing user on our database)
password: 12345 (must be at least 5 characters long)
given name, surname: test, user (must be non-empty)
city: Edmonton (must be non-empty)
locality: Select 'Alberta' (default)
birthday: 17th April 1994
gender: Select 'male' (default)
```
![fill](android-test-assets/createAccount/3.png?raw=true)

4. Click Sign Up to Open App
![done](android-test-assets/createAccount/4.png?raw=true)

Postconditions: A profile is created for you, and you will be brought to the main screen. You can check your information from the settings pane.
![done](android-test-assets/createAccount/5.png?raw=true)

### Login to existing Account
User Stories: 2
Preconditions : This is the first run of the app, or there is no user logged in.

1. Launch app
![launch](android-test-assets/login/1.png?raw=true)

2. Fill in the fields. The user must be created on the database already, either by signing up or by other means.
```
email: bieber3@ualberta (must be an email)
password: password77
```
![fill](android-test-assets/login/2.png?raw=true)

3. Click Login
![done](android-test-assets/login/3.png?raw=true)

Postconditions: You will be logged in and brought to the main screen.

### Use As Guest
User Stories: 3
Preconditions : This is the first run of the app, or there is no user logged in.

1. Launch app
![launch](android-test-assets/guest/1.png?raw=true)

2. Click 'Guest'

3. See Map
![map](android-test-assets/guest/3.png?raw=true)

4. See Specials
![specials](android-test-assets/guest/4.png?raw=true)

### Edit Information
User Stories: 5

Preconditions : User has been already logged in.

1. Launch app.
![launch](android-test-assets/edit_info/1.png?raw=true)

2. Click 'Settings' (this may be in a spinner in the Action Bar depending on screen size).
![info](android-test-assets/edit_info/2.png?raw=true)

3. Edit information and click save. These can be arbitrary values.
```
given name, surname: PrateekChanged, SrivastavaChanged
password: 123456789 (must be at least 5 characters long)
city: Calgary (must be non-empty)
locality: Select 'Nova Scotia'
```
![edit](android-test-assets/edit_info/3.png?raw=true)

4. Exit app.

5. Repeat steps 1 and 2.
![updated](android-test-assets/edit_info/3.png?raw=true)

Postconditions: The preferences will have been updated with the new values.

### Edit User Restrictions
User Stories: 6

Preconditions : User has been already logged in.

1. Launch App
![launch](android-test-assets/edit_restrictions/1.png?raw=true)

2. Click 'Preferences' (this may be in a spinner in the Action Bar depending on screen size).
![preferences](android-test-assets/edit_restrictions/2.png?raw=true)

3. Click a restriction. It will turn grey. e.g. Dairy
![toggled](android-test-assets/edit_restrictions/3.png?raw=true)

4. Click the 'Save' icon in the Action Bar.

5. Exit App.

6. Repeat steps 1 and 2.
![toggled](android-test-assets/edit_restrictions/4.png?raw=true)

Postconditions: The restrictions will be remembered form your selection (in this case, Dairy will still be grey).

### See Restaurant Locations
User Stories: 7, 8, 9, 18
This script includes the user stories: See Restaurant Locations On A Map, See Restaurant Locations In a List, See Restaurants near me

Preconditions : User has been already logged in, or we are in guest mode.

1. Launch App.
![launch](android-test-assets/restaurants/1.png?raw=true)

Postconditions: A restaurant list is displayed, with the nearest restaurants first.

2. Swipe left, or click to the right of the restaurant list.
![map](android-test-assets/restaurants/2.png?raw=true)

Postconditions: A a map of restaurants is displayed.

### Filter/Sort Restaurants
User Stories: 10, 11
This script includes the user stories:
Search Restaurants by Name, Sort Restaurants By Cuisine, Sort Restaurants By Distance, Sort Restaurants By Rating

Preconditions : User has been already logged in, or we are in guest mode.

1. Launch App.
![launch](android-test-assets/filter_restaurants/1.png?raw=true)

2. Click 'Top Rated'.
![top_rated](android-test-assets/filter_restaurants/2.png?raw=true)

Postconditions: The list is sorted by rating.

3. Click 'Cuisine'.
![cuisine](android-test-assets/filter_restaurants/3.png?raw=true)

Postconditions: The list is sorted by cuisine.

4. Click 'Distance'. (Note that that is the initial sort order that the data was in when launched)
![distance](android-test-assets/filter_restaurants/4.png?raw=true)

Postconditions: The list is sorted by distance.

5. Type in the Search Bar. e.g. 'Boston'.
![filtered_list](android-test-assets/filter_restaurants/5.png?raw=true)
![filtered_map](android-test-assets/filter_restaurants/6.png?raw=true)

Postconditions: The list only displays item matching the search term. The map is filtered with this set as well.

### View Specials
User Stories: 12
This script also includes the user stories:
View specials by type (drink, dessert, entree), View specials for selected date

Preconditions : User has been already logged in, or we are in guest mode.

1. Launch App.
![launch](android-test-assets/specials/1.png?raw=true)

2. Click 'Specials' (this may be in a spinner in the Action Bar depending on screen size).
![specials](android-test-assets/specials/2.png?raw=true)

Postconditions: A list of specials is displayed.

3. Click the filter icon in the Action Bar, and select which types should be shown. e.g. hide drink specials
![filtered](android-test-assets/specials/3.png?raw=true)

Postconditions: All specials of the unselected types (drinks in this case) are hidden.

4. Click the calendar icon at the bottom of the page.
![calendar](android-test-assets/specials/4.png?raw=true)

5. Select a start date.
![start](android-test-assets/specials/5.png?raw=true)

6. Select an end date. This will automatically close the sliding pane.
![date_range](android-test-assets/specials/6.png?raw=true)

Postconditions: Only specials for the selected date are shown (note that they are still filtered with our earlier choices - drinks in this case)

### Customized Menu
User Stories: 13, 14

Preconditions : User has been already logged in, or we are in guest mode.
1. Launch App.
![launch](android-test-assets/specials/1.png?raw=true)

2. Click 'Preferences' (this may be in a spinner in the Action Bar depending on screen size).
![preferences](android-test-assets/edit_restrictions/2.png?raw=true)

3. Click a restriction. It will turn grey. e.g. Vegetarian
![toggled](android-test-assets/edit_restrictions/3.png?raw=true)

4. Click the 'Save' icon in the Action Bar.

5. Click the 'Map' button to go back to the restaurant list.
![map](android-test-assets/edit_restrictions/4.png?raw=true)

6. Click a Restaurant. e.g. Boston Pizza
![custom_menu](android-test-assets/specials/5.png?raw=true)

Postconditions: A customized menu is displayed, with restricted menu items flagged for the user (Double Bacon BBQ Burger)

7. Click on a restricted menu item (e.g. Double Bacon BBQ Burger)
![custom_menu](android-test-assets/specials/6.png?raw=true)

Postconditions: Modifications (if available) are shown for the menu item.

### Menu Item
User Stories: 15, 16, 17, 20, 22

Preconditions : User has been already logged in, or we are in guest mode.

1. Launch App.
![launch](android-test-assets/menu_item/1.png?raw=true)

2. Click on a restaurant, e.g. Boston Pizza

3. Click on a menu item, e.g. Pesto Chicken Burger
![launch](android-test-assets/menu_item/2.png?raw=true)

4. Click the Rate Button.
![launch](android-test-assets/menu_item/3.png?raw=true)

5. Choose a rating (required), and type in some text (not required)
![launch](android-test-assets/menu_item/4.png?raw=true)

6. Click Save.
![launch](android-test-assets/menu_item/5.png?raw=true)

Postconditions: You should see a message saying review was saved.

7. Click the Rating.
![launch](android-test-assets/menu_item/6.png?raw=true)

Postconditions: You will see a list of reviews. If you scroll down, your review will be appended as well.

8. Click the sort button at the top of the screen
![launch](android-test-assets/menu_item/7.png?raw=true)

9. Select one of the sort options (e.g. like count)
![launch](android-test-assets/menu_item/8.png?raw=true)

Postconditions: The list of reviews is now sorted by the selected criteria.

10. Click on of the sort options from the menu
![launch](android-test-assets/menu_item/9.png?raw=true)

Postconditions: You will be directed to the app you selected the menu item to.
![launch](android-test-assets/menu_item/10.png?raw=true)

### Sort Restaurant Reviews
User Stories: 21, 23, 24

1. Launch App.
![launch](android-test-assets/menu_item/1.png?raw=true)

2. Click on a restaurant, e.g. Boston Pizza and select reviews page
![launch](android-test-assets/seeTopLiked/2reviewlist.png?raw=true)

3. Click on the sort button at the top of the page.
![launch](android-test-assets/seeTopLiked/3actionbar.png?raw=true)

4. Select one of the sort options.
![launch](android-test-assets/seeTopLiked/4likecount.png?raw=true)


Postconditions: Reviews are now sorted. This process is the same for sorting 
by top rated and most recent.

6. Click on the overflow (three squares) icon next to a review.
![launch](android-test-assets/reviewreport/prereport.png?raw=true)

7. Click on 'Like'.
![launch](android-test-assets/reviewreport/toast.png?raw=true)

Postconditions: The review that you selected will now be liked and the like 
count will increase.


### Mark Menu Item as Eaten
User Stories: 25
1. Launch App.
![launch](android-test-assets/menu_item/1.png?raw=true)

2. Click on a restaurant, e.g. Boston Pizza
![launch](android-test-assets/eatenthis/1menulist.png?raw=true)

3. Select a Menu Item, e.g. Pesto Chicken Burger (choose one you haven't liked 
before)
![launch](android-test-assets/eatenthis/2pesto.png?raw=true)

4. Click the 'eaten this' button at the top.
![launch](android-test-assets/eatenthis/atepesto.png?raw=true)

Postconditions: MenuItem is now marked as something that whoever is logged in 
has eaten.
