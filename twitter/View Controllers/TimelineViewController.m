//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetDetailViewController.h"

@interface TimelineViewController ()<UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate,TweetDetailViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *tweets;
@property (weak, nonatomic) IBOutlet UITableView *tweetView;
@property (assign, nonatomic) BOOL isMoreDataLoading;



@end

@implementation TimelineViewController
- (IBAction)didLogout:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tweetView insertSubview:refreshControl atIndex:0];



    
    self.tweetView.dataSource = self;
    self.tweetView.delegate = self;
    self.tweets = [NSMutableArray array];

    
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSMutableArray *tweets, NSError *error) {
        if (tweets) {
            
            self.tweets = tweets;
            [self.tweetView reloadData];
            
       
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tweets.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    
    
    
    
    Tweet *tweet  = self.tweets[indexPath.row];
    
    cell.tweet = tweet;
    

    
    
   
    return cell;
}






-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}
 
 

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSMutableArray *tweets, NSError *error) {
        if (tweets) {
            
            self.tweets = tweets;
            [self.tweetView reloadData];
            [refreshControl endRefreshing];

            
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    
    
}


- (void)getMoreData {
    
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSMutableArray *tweets, NSError *error) {
        if (tweets) {
            
            self.tweets = tweets;
            [self.tweetView reloadData];
            
            
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
    
    
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *navigationController = [segue destinationViewController];
  
    
    
    
    
    if([ navigationController.topViewController isKindOfClass:[ComposeViewController class]]){
    
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
        NSLog(@"Compose Segue");
    }
    
    else if([navigationController.topViewController isKindOfClass:[TweetDetailViewController class]]){
        
      
        TweetDetailViewController *detailController = (TweetDetailViewController*)navigationController.topViewController;
        NSLog(@"Detail Segue");
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tweetView indexPathForCell:tappedCell];
        
        Tweet *tweet = self.tweets[indexPath.row];
        detailController.tweet = tweet;
        detailController.delegate = self;
        
    }
    
    
}

- (void)didBack{
    
    [self.tweetView reloadData];

    
}
- (void)didTweet:(Tweet *)tweet{
    
    NSLog(@"Refeshing!");
    
    [self.tweets insertObject:tweet atIndex:0];
    
    [self.tweetView reloadData];

    

    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tweetView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tweetView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tweetView.isDragging) {
            self.isMoreDataLoading = true;
            
            // ... Code to load more results ...
        }
    }
}


@end
