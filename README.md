# Udacity-Shikimori

Shikimori is a shortened version of shikimori.org website for "You Decide!" udacity project

# Information for reviewer

Before running the app install cocoapods ("pod install" in project directory)

Test Account:
login: udacity_test1
password: udacity_test1

# User experience

The app is based on reveal view controller. User can open left side menu by tapping "menu" button at top-left or by pannig view.
Menu consists of two options: profile and anime section. Anime section is chosen by default. 

# Anime section

When this section appears it loads 50 animes that are presented by image, title, type, and year of release.
When user scroll to last object the new set of 50 animes will be loaded.

User can search for anime by dragging collection view to down. Search bar is placed at collection view header. Search allowes
using only latin letters (because of api specification). 

There is a filter button at top-right. Tapping this button redirects you to another view, where you can special request for anime list.
There are 5 sections in filter view:

1) Status of production lik on going, released or anons. (can choose only 1 option)
2) Type of anime like full movie, tv, etc. (can choose only 1 option)
3) How to order the result. (can choose only 1 option)
4) The minimum score. (can choose only 1 option)
5) Genres. (user may choose plenty of genres)

To save the filter user have to tap top-right button. You will be redirected automalically back and anime view will be refreshed 
with new filter.

3D touch available in anime view. User can preview each anime, and go to full details using 3d touch. 
When user opens anime first time "preview" anime, data is saved to CoreData, the next time data for "preview" will be retrieved
from local database. When user opens full anime description, CoreData is updated.

Full description of anime consists of three sections:

1) Header: name, russian name, genres, number of episodes, etc. 
2) Description.
3) Similar animes. (The section will be empty if there is no similar animes) that are represented as collection view with 
horizontal scrolling. Tapping anime will redirect user to another screen with detailed info of choosen anime.

There is a star button at top-right (appears if user is logged in), that can be filled if this anime is already added lo user list and
not filled when anime is not in user list. When user taps the button the alert is presented where you can remove anime from list, 
add to list or replace to another list.

# Profile section

Is user is not logged in there will be button that will present the login view. After completion of login, you will be redirected back.
When user is logged in he will see the collection views inside table view rows, and header with nickname and avatar.
The table view represents the list of animes in profile there can be up to 5 rows:

1) Planned list
1) Watching list
1) Completed list
1) Dropped list
1) On hold list

There there is no animes in special list the row will not be presented. Each row have header above collection view, it shows the list 
title and button "see all". When you tap button the same view as anime section will be presented but without filter button and search. 
Only animes from choosen list will be loaded to this view. 
The collection view under the header shows up to 10 animes, anime is scrollable and tappable (it will redirects you to full description
view).

Also there is a logout button at top-right.
