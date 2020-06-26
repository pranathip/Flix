//
//  MoviesViewController.m
//  Flix
//
//  Created by Pranathi Peri on 6/24/20.
//  Copyright © 2020 Pranathi Peri. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *movies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *filteredData;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *searchButton;

@end

@implementation MoviesViewController

//ADDED SO THAT SELECTED ROW UNSELECTS AFTER RETURNING TO VIEW
-(void)viewWillAppear:(BOOL)animated {
    NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
    if (indexPath) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:animated];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //SEARCH BAR
    self.searchBar.delegate = self;
    self.searchBar.alpha = 0;
    
    
    //NSLog(@"activityIndicator Start");
    [self.activityIndicator startAnimating];
    [self fetchMovies];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];

}

- (void) fetchMovies {
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
     NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
     NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
     NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
                
                //CONNECTIVITY ERROR MESSAGE
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The internet connection appears to be offline." preferredStyle:(UIAlertControllerStyleAlert)];
                
                // create a cancel action
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                // handle cancel response here. Doing nothing will dismiss the view.
                    [self fetchMovies];
                }];
                // add the cancel action to the alertController
                [alert addAction:cancelAction];
                
                [self presentViewController:alert animated:YES completion:^{
                    // optional code for what happens after the alert controller has finished presenting
                }];
            }
            else {
                NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data
               // NSLog(@"%@", dataDictionary);
                self.movies = dataDictionary[@"results"];
                self.filteredData = self.movies;
                /*for (NSDictionary *movie in self.movies) {
                    NSLog(@"%@", movie[@"title"]);
                }*/
                
                [self.tableView reloadData];
                [self.activityIndicator stopAnimating];
            }
         [self.refreshControl endRefreshing];
        }];
     [task resume];
    //NSLog(@"activityIndicator Stop");
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.filteredData[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
    //FADE IN IMAGES WHEN DONE LOADING
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:posterURL];
    __weak MovieCell *weakSelf = cell;
    [cell.posterView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
                                        
         // imageResponse will be nil if the image is cached
         if (imageResponse) {
             //NSLog(@"Image was NOT cached, fade in image");
             weakSelf.posterView.alpha = 0.0;
             weakSelf.posterView.image = image;
                                                
             //Animate UIImageView back to alpha 1 over 0.3sec
             [UIView animateWithDuration:0.3 animations:^{
                 weakSelf.posterView.alpha = 1.0;
              }];
         }
         else {
             //NSLog(@"Image was cached so just update the image");
             weakSelf.posterView.image = image;
         }
     }
     failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {
        // do something for the failure condition
     }];
    //cell.posterView.image = nil;
    //[cell.posterView setImageWithURL:posterURL];
    cell.backgroundColor = UIColor.systemGray6Color;
    cell.posterView.layer.cornerRadius = 6;
    cell.whiteRectView.layer.cornerRadius = 6;
    cell.star1.alpha = 1;
    cell.star2.alpha = 0;
    cell.star3.alpha = 0;
    cell.star4.alpha = 0;
    cell.star5.alpha = 0;
    
    //RATINGS
    cell.starRating = [NSArray arrayWithObjects: cell.star1, cell.star2, cell.star3, cell.star4, cell.star5, nil];
    NSNumber *rating = movie[@"vote_average"];
    rating = @([rating doubleValue] / 2);
    //NSLog(@"rating: %@", rating);
    NSNumber *i = @0.0;
    //NSLog(@"i: %@", i);
    while ([i doubleValue] < [rating doubleValue]) {
        //NSLog(@"starred");
        UIImageView *currStar = [cell.starRating objectAtIndex:[i intValue]];
        currStar.alpha = 1;
        i = @([i doubleValue] + 1);
    }
    //half stars
    /*if ([rating doubleValue] - [i doubleValue] > 0.5) {
        
    }*/
    return cell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"title contains[c] %@", searchText];
        self.filteredData = [self.movies filteredArrayUsingPredicate:predicate];

        NSLog(@"%lu", [self.filteredData count]);
        
    }
    else {
        self.filteredData = self.movies;
    }
    
    [self.tableView reloadData];
 
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
}
- (IBAction)onSearchTap:(id)sender {
    NSLog(@"Tapped");
    // create the search bar programatically since you won't be
    // able to drag one onto the navigation bar
    //self.searchBar = [[UISearchBar alloc] init];
    [UIView animateWithDuration:0.3 animations:^{
        [self.searchBar sizeToFit];
        self.navigationItem.titleView = self.searchBar;
        self.searchBar.alpha = 1;
        self.searchBar.showsCancelButton = YES;
        [self.searchButton setEnabled:NO];
        [self.searchButton setTintColor: [UIColor clearColor]];
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [UIView animateWithDuration:0.3 animations:^{
        self.searchBar.showsCancelButton = NO;
        [self.searchBar resignFirstResponder];
        self.searchBar.alpha = 0;
        [self.searchButton setEnabled:YES];
        [self.searchButton setTintColor: [UIColor darkGrayColor]];
    }];
}

/*- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
    [self.searchButton setEnabled:NO];
    [self.searchButton setTintColor: [UIColor clearColor]];
}*/


@end

