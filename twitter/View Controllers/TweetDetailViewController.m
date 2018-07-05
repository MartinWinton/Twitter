//
//  TweetDetailViewController.m
//  twitter
//
//  Created by Martin Winton on 7/4/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TweetDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TTTAttributedLabel.h"
#import "APIManager.h"
#import "ComposeViewController.h"




@interface TweetDetailViewController () <ComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tweetUsernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tweetPic;
@property (weak, nonatomic) IBOutlet UILabel *tweetScreen;
@property (weak, nonatomic) IBOutlet UILabel *tweetBody;
@property (weak, nonatomic) IBOutlet UILabel *tweetTime;
@property (weak, nonatomic) IBOutlet UILabel *numfavs;
@property (weak, nonatomic) IBOutlet UILabel *numretweets;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;

@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon"] forState : UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState : UIControlStateSelected];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState : UIControlStateHighlighted];
    
   
    
    self.tweetUsernameLabel.text = self.tweet.user.name;
    
    self.tweetBody.text = self.tweet.text;
    self.tweetScreen.text = [NSString stringWithFormat:@"%@%@", @"@", self.tweet.user.screenName];
    self.tweetPic.image = nil;
    if (self.tweet.user.profileImageURL != nil) {
        [self.tweetPic setImageWithURL:self.tweet.user.profileImageURL];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Convert String to Date
    NSDate *date = [formatter dateFromString:self.tweet.createdAtString];
    
    formatter.dateStyle = NSDateFormatterShortStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    
    self.tweetTime.text = [formatter stringFromDate:date];

    [self refreshData];
    
    // Do any additional setup after loading the view.
}


-(void)refreshData{
    
    
    self.numretweets.text = [[NSNumber numberWithInt:self.tweet.retweetCount] stringValue];
    self.numfavs.text = [[NSNumber numberWithInt:self.tweet.favoriteCount] stringValue];
    
    
    if(self.tweet.favorited){
        
        [self.favoriteButton setSelected:YES];
     
        
        
        
    }
    
    else{
        
        [self.favoriteButton setSelected:NO];
        
        
        
        
    }
    
    if(self.tweet.retweeted){
        
        [self.retweetButton setSelected:YES];
        
        
        
        
    }
    
    else{
        
        [self.retweetButton setSelected:NO];
        
        
        
        
    }
    
    
    
    
    
    
}

- (IBAction)clickBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
    [self.delegate didBack];


}


-(void) unfavoriteAndRefresh{
    
    self.tweet.favorited = NO;
    self.tweet.favoriteCount -= 1;
    [self refreshData];
    
    
    
    
}

-(void) favoriteAndRefresh{
    
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
    [self refreshData];
    
    
    
    
}
- (IBAction)didTapFavorite:(id)sender {
    
    if(self.tweet.favorited){
        
        [self unfavoriteAndRefresh];
        
        
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
                [self favoriteAndRefresh];
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
                
                
                
            }
            
        }];
        
        
        
        
    }
    
    else{
        
        [self favoriteAndRefresh];
        
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
                [self unfavoriteAndRefresh];
                
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                
            }
            
            
        }];
        
        
    }
}
- (IBAction)didTapRetweet:(id)sender {
    
    
    
    if(self.tweet.retweeted){
        
        [self unretweetAndRefresh];
        
        
        
        
        
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
                [self retweetAndRefresh];
                
                
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
                
                
            }
            
        }];
        
        
        
        
    }
    else{
        
        [self retweetAndRefresh];
        
        
        
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
                [self unretweetAndRefresh];
                
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
                
                
                
            }
            
        }];
        
        
        
        
    }
    
    
    
    
}

-(void) unretweetAndRefresh{
    
    self.tweet.retweeted = NO;
    self.tweet.retweetCount -= 1;
    [self refreshData];
    
    
    
    
}

-(void) retweetAndRefresh{
    
    self.tweet.retweeted = YES;
    self.tweet.retweetCount += 1;
    [self refreshData];
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didTweet:(Tweet *)tweet{
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
        UINavigationController *navigationController = [segue destinationViewController];
    
    ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
    composeController.delegate = self;
    composeController.isReply = YES;
    composeController.replyTweet = self.tweet;
    
 
}


@end
