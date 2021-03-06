# Project 2 - Flix

Flix  is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: ~3 days spent in total

## User Stories

The following **required** functionality is complete:

- [x] User sees an app icon on the home screen and a styled launch screen.
- [x] User can view a list of movies currently playing in theaters from The Movie Database.
- [x] Poster images are loaded using the UIImageView category in the AFNetworking library.
- [x] User sees a loading state while waiting for the movies API.
- [x] User can pull to refresh the movie list.
- [x] User sees an error message when there's a networking error.
- [x] User can tap a tab bar button to view a grid layout of Movie Posters using a CollectionView.

The following **optional** features are implemented:

- [x] User can tap a poster in the collection view to see a detail screen of that movie
- [x] User can search for a movie.
- [x] All images fade in as they are loading.
- [x] User can view the large movie poster by tapping on a cell.
- [x] For the large poster, load the low resolution image first and then switch to the high resolution image when complete.
- [x] Customize the selection effect of the cell.
- [x] Customize the navigation bar.
- [x] Customize the UI.

The following **additional** features are implemented:

- [x] Star rating displayed for each movie on "now playing" page.
- [x] "Popular Movies" tab displays movies that are most popular.
- [x] Popular movies are given a "banner" that shows the average watcher rating.
- [x] On movie description, release date is shown.
- [x] Trailer can be played on "details" page by tapping the play button on the large poster.
- [x] Changed App Icon to custom logo design.

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. I thought it would be cool to add a "custom filters" feature where the user can filter movies by genre, rating, runtime, etc. Not sure how I would go about doing this, but could be something cool to explore!
2. The way that I implemented star ratings was brute force in nature, and didn't allow for half-stars to be shown. I'd like to discuss a better method of implementing this feature.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='http://g.recordit.co/kNNxOx4RQ9.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with RecordIt.

## Notes

This app posed a few challenges for me during development - I had a bit of trouble implementing and debugging the search bar featuer at first due to some updates that had to be made with the filtered data and reloading the movies displayed in the tableView. After some help and some tinkering though, I was able to get it to have smooth animated transitions and nice integration with the UI. Additionally, the features that I added myself were a bit challenging to implement at first since there was no CodePath documentation about them specifically, but they turned out looking pretty cool!

## Credits

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library

## License

    Copyright 2020 Pranathi Peri

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
