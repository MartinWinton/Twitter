//
//  ProfileViewController.m
//  twitter
//
//  Created by Martin Winton on 7/3/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "APIManager.h"
#import "TweetCell.h"
#import "ProfileCell.h"
#import "TweetDetailViewController.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, TweetCellDelegate, TweetDetailViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *profileView;
@property (nonatomic,strong) NSMutableArray *cells;
@property (assign, nonatomic) Tweet *cellTweet;



@end

@implementation ProfileViewController
- (IBAction)didClickBack:(id)sender {
    
    [self dismissViewControllerAnimated:true completion:nil];

    
    
    
}

- (void)didBack{
    
    [self.profileView reloadData];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.profileView setSeparatorColor:[UIColor colorWithRed:0.00 green:0.67 blue:0.93 alpha:1.0]];

    
    self.profileView.dataSource = self;
    self.profileView.delegate = self;
    
    self.cells = [NSMutableArray array];
    
    if(self.didClick){
        [self.cells addObject:self.user];
        [self getFeed];
        
    }
    // if we clicked on the profile, this means user was already set, so we can add it to the table and refresh
    
    else{
        
        // otherwise we are on the main user page, and we can simply call the api request
    
    
    [[APIManager shared] getMainUserWithCompletion:^(User *user, NSError *error) {
        
        if (user){
            
            self.user = user;
            [self.cells addObject:self.user];
            
            [self.profileView reloadData];
            
            [self getFeed];

        }
        
        else {
            NSLog(@"😫😫😫 Error getting user: %@", error.localizedDescription);
        }
    }];
       
        
    }
    
     
    // Do any additional setup after loading the view.
}

-(void)getFeed{
    
    [[APIManager shared] getUserTimelineFromUser:self.user withCompletion:^(NSMutableArray *tweets, NSError *error) {
        
        
        if (tweets) {
            
            
            for(int i = 0; i < tweets.count; i++) {
                
                [self.cells addObject:tweets[i]];
            }
            
            [self.profileView reloadData];
            
            
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
    return self.cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.cells[indexPath.row] isKindOfClass:[Tweet class]]){
        
        TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Feed"];
        Tweet *tweet  = self.cells[indexPath.row];
        cell.delegate = self;
        cell.tweet = tweet;
        return cell;

    }
    
    else {
            
            ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Profile"];
            User *user  = self.cells[indexPath.row];
            cell.user = user;
            return cell;
        
    }
    
}


- (void)getTweet:(Tweet *)tweet {
    
    self.cellTweet = tweet;
}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewAutomaticDimension;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
       UINavigationController *navigationController = [segue destinationViewController];
     if([navigationController.topViewController isKindOfClass:[ProfileViewController class]]){
        
        ProfileViewController *detailController = (ProfileViewController*)navigationController.topViewController;
        
        detailController.user = self.cellTweet.user;
        detailController.didClick = true;
        
    }
    
     else if([navigationController.topViewController isKindOfClass:[TweetDetailViewController class]]){
         
         
         TweetDetailViewController *detailController = (TweetDetailViewController*)navigationController.topViewController;
         NSLog(@"Detail Segue");
         UITableViewCell *tappedCell = sender;
         NSIndexPath *indexPath = [self.profileView indexPathForCell:tappedCell];
         Tweet *tweet = self.cells[indexPath.row];
         detailController.tweet = tweet;
         detailController.delegate = self;
         
         //customary tableview cell tap code
         
     }
}


@end
