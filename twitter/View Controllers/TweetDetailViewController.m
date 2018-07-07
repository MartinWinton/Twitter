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
#import "ProfileViewController.h"
#import "NumberFormatter.h"
#import "FavoriteRetweetHelper.h"




@interface TweetDetailViewController () <ComposeViewControllerDelegate, FavoriteRetweetHelperDelegate>
@property (weak, nonatomic) IBOutlet UILabel *tweetUsernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tweetPic;
@property (weak, nonatomic) IBOutlet UILabel *tweetScreen;
@property (weak, nonatomic) IBOutlet UILabel *tweetBody;
@property (weak, nonatomic) IBOutlet UILabel *tweetTime;
@property (weak, nonatomic) IBOutlet UILabel *numfavs;
@property (weak, nonatomic) IBOutlet UILabel *numretweets;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (nonatomic,strong)  FavoriteRetweetHelper *helper;


@end

@implementation TweetDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.helper = [[FavoriteRetweetHelper alloc] initWithTweet:self.tweet];
    self.helper.delegate = self;
    
    [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon"] forState : UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState : UIControlStateSelected];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState : UIControlStateHighlighted];
    
    
    
    self.tweetUsernameLabel.text = self.tweet.user.name;
    self.tweetBody.text = self.tweet.text;
    
    self.tweetScreen.text = [NSString stringWithFormat:@"%@%@", @"@", self.tweet.user.screenName];
    // add @ symbol to screen name
    
    
    
    self.tweetPic.layer.cornerRadius = self.tweetPic.frame.size.width/2;
    self.tweetPic.clipsToBounds = YES;
    // make pictures circulular
    
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
    // add time and date to NSDate
    
    self.tweetTime.text = [formatter stringFromDate:date];
    
    [self refreshData];
    
    // Do any additional setup after loading the view.
}


-(void)refreshData{
    
    self.numretweets.text = [NumberFormatter suffixNumber:[NSNumber numberWithInt:self.tweet.retweetCount]];
    self.numfavs.text = [NumberFormatter suffixNumber:[NSNumber numberWithInt:self.tweet.favoriteCount]];
    // format number to shorten them

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



- (IBAction)didTapFavorite:(id)sender {
    
    [self.helper toggleFavorite];
    [self refreshData];

}
- (IBAction)didTapRetweet:(id)sender {
    
    [self.helper toggleRetweet];
    [self refreshData];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didTweet:(Tweet *)tweet{
    
    [self refreshData];
    [self.delegate didBack];

    
    
}


- (void)didFailFavorite {
    
    //reset tweet data if favorite/unfavorite failed
    
    if(self.tweet.favorited){
        
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
    }
    
    else{
        
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
    }
    
    [self refreshData];
    
    
    
}

- (void)didFailRetweet {
    
    //reset tweet data if retweet/unretweet failed

    
    if(self.tweet.retweeted){
        
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
    }
    
    else{
        
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
    }
    
    [self refreshData];
    
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    UINavigationController *navigationController = [segue destinationViewController];
    
    if([ navigationController.topViewController isKindOfClass:[ComposeViewController class]]){
        
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
        composeController.isReply = YES;
        composeController.replyTweet = self.tweet;
        
        NSLog(@"Compose Segue");
    }
    
    else if([navigationController.topViewController isKindOfClass:[ProfileViewController class]]){
        
        
        ProfileViewController *detailController = (ProfileViewController*)navigationController.topViewController;
        
        detailController.user = self.tweet.user;
        detailController.didClick = true;
        
    }
    
    
}


@end

