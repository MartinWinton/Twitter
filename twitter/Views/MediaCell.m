//
//  MediaCell.m
//  twitter
//
//  Created by Martin Winton on 7/6/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "MediaCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "DateTools.h"
#import "TTTAttributedLabel.h"
#import "NumberFormatter.h"
#import "FavoriteRetweetHelper.h"
#import "ProfileViewController.h"
@interface MediaCell ()<FavoriteRetweetHelperDelegate>

@property (nonatomic,strong)  FavoriteRetweetHelper *helper;
@end
@implementation MediaCell

- (IBAction)didTapFavorite:(id)sender {
    
    
    [self.helper toggleFavorite];
    
    [self refreshData];
    
}


- (IBAction)didTapRetweet:(id)sender {
    
    [self.helper toggleRetweet];
    
    [self refreshData];
    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void) refreshData {
    
    
     if(self.tweet.imageURL != nil){
     
     [self.mediaImg setImageWithURL:self.tweet.imageURL];
    
     }
     
     else{
     self.mediaImg.image = nil;
     
     }
     
     
    
    self.tweetUsername.text = self.tweet.user.name;
    self.tweetText.text = self.tweet.text;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Convert String to Date
    NSDate *date = [formatter dateFromString:self.tweet.createdAtString];
    self.tweetTime.text = [NSString stringWithFormat:@"%@%@", @"· ", date.shortTimeAgoSinceNow];
    
    
    self.tweetScreen.text = [NSString stringWithFormat:@"%@%@", @"@", self.tweet.user.screenName];
    
 
    
    
    self.retweetCount.text = [NumberFormatter suffixNumber:[NSNumber numberWithInt:self.tweet.retweetCount]];
    self.favoriteCount.text = [NumberFormatter suffixNumber:[NSNumber numberWithInt:self.tweet.favoriteCount]];
    
    self.profileImage.image = nil;
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
    self.profileImage.clipsToBounds = YES;
    
    if (self.tweet.user.profileImageURL != nil) {
        [self.profileImage setImageWithURL:self.tweet.user.profileImageURL];
    }
    
    if(self.tweet.favorited){
        
        [self.favoriteButton setSelected:YES];
        self.favoriteCount.textColor = [UIColor redColor];
        
        
        
    }
    
    else{
        
        [self.favoriteButton setSelected:NO];
        self.favoriteCount.textColor = [UIColor lightGrayColor];
        
        
        
        
    }
    
    if(self.tweet.retweeted){
        
        [self.retweetButton setSelected:YES];
        
        self.retweetCount.textColor =  [UIColor colorWithRed:0.10 green:0.81 blue:0.53 alpha:1.0];
        
        
        
    }
    
    else{
        
        [self.retweetButton setSelected:NO];
        self.retweetCount.textColor = [UIColor lightGrayColor];
        
        
        
    }
    
    

    
    
}
- (IBAction)didTapButton:(id)sender {
    [self.delegate getTweet:self.tweet];
}

- (void)setTweet:(Tweet *)tweet{
    
    _tweet = tweet;
    
    self.helper = [[FavoriteRetweetHelper alloc] initWithTweet:self.tweet];
    self.helper.delegate = self;
    
    
    [self refreshData];
}

- (void)didFailFavorite {
    
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
@end
