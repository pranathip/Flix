//
//  TrailerViewController.m
//  Flix
//
//  Created by Pranathi Peri on 6/26/20.
//  Copyright © 2020 Pranathi Peri. All rights reserved.
//

#import "TrailerViewController.h"

@interface TrailerViewController ()
@property (nonatomic, strong) NSArray *videos;
@property (weak, nonatomic) IBOutlet UIWebView *webkitView;
@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *stringURL = @"https://api.themoviedb.org/3/movie/";
    NSString *movieID = [NSString stringWithFormat:@"%@", self.movie[@"id"]];
    stringURL = [stringURL stringByAppendingString:movieID];
    stringURL = [stringURL stringByAppendingString:@"/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US"];
    NSURL *url = [NSURL URLWithString:stringURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"%@", [error localizedDescription]);
           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               // TODO: Get the array of movies
               // TODO: Store the movies in a property to use elsewhere
               // TODO: Reload your table view data
               //NSLog(@"%@", dataDictionary);
               self.videos = dataDictionary[@"results"];
               NSString *trailerStringURL = [@"https://www.youtube.com/watch?v=" stringByAppendingString:[self.videos objectAtIndex:0][@"key"]];
               //NSLog(@"%@", trailerURL);
               
               // Convert the url String to a NSURL object.
               NSURL *trailerURL = [NSURL URLWithString:trailerStringURL];

               // Place the URL in a URL Request.
               NSURLRequest *trailerRequest = [NSURLRequest requestWithURL:trailerURL
                                                        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                    timeoutInterval:10.0];
               // Load Request into WebView.
               [self.webkitView loadRequest:trailerRequest];
               
           }
       }];
    [task resume];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
