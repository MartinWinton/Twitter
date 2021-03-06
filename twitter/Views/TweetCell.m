//
//  TweetCell.m
//  twitter
//
//  Created by Martin Winton on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"
#import "DateTools.h"
#import "TTTAttributedLabel.h"
#import "NumberFormatter.h"
#import "FavoriteRetweetHelper.h"
#import "ProfileViewController.h"

@interface TweetCell ()<FavoriteRetweetHelperDelegate>
@property (weak, nonatomic) IBOutlet UILabel *retweetedByLabel;
@property (weak, nonatomic) IBOutlet UIImageView *retweetedByImage;
@property (nonatomic,strong)  FavoriteRetweetHelper *helper;

@end
@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon"] forState : UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState : UIControlStateSelected];
       [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState : UIControlStateHighlighted];
    
    
    
    
    
}

- (IBAction)didTapButton:(id)sender {
    [self.delegate getTweet:self.tweet];
}



- (IBAction)didTapFavorite:(id)sender {
    
    
    [self.helper toggleFavorite];
    
    [self refreshData];
    
}


- (IBAction)didTapRetweet:(id)sender {
    
    [self.helper toggleRetweet];
    
    [self refreshData];
    
    
}

-(void) refreshData {
    
    /*
    if(self.tweet.imageURL != nil){
        
        [self.mediaImage setImageWithURL:self.tweet.imageURL];
        self.mediaImage.image = nil;
        self.mediaImage.frame = CGRectMake(91, 78, 269, 130);
        self.mediaImage.center =self.mediaImage.superview.center;

    }
    
    else{
        self.mediaImage.image = nil;
        self.mediaImage.frame = CGRectMake(0, 0, 0, 0);
        self.mediaImage.center =self.mediaImage.superview.center;
        
    }
     
     */
    
    self.tweetUsername.text = self.tweet.user.name;
    self.tweetLabel.text = self.tweet.text;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Convert String to Date
    NSDate *date = [formatter dateFromString:self.tweet.createdAtString];
    self.tweetDate.text = [NSString stringWithFormat:@"%@%@", @"· ", date.shortTimeAgoSinceNow];
    
    
    self.screenName.text = [NSString stringWithFormat:@"%@%@", @"@", self.tweet.user.screenName];
    
    if(self.tweet.retweetedByUser != nil && ![self.tweet.user.screenName isEqualToString:self.tweet.retweetedByUser.screenName] && ![self.tweet.user.name isEqualToString:self.tweet.retweetedByUser.name]){
        
        self.retweetedByLabel.text= [NSString stringWithFormat:@"%@%@", self.tweet.retweetedByUser.name, @" Retweeted"];
        
        [self.retweetedByImage setImage:[UIImage imageNamed:@"retweet-icon-green"]];
        
    }
    else{
        
        self.retweetedByLabel.text = @"";
        self.retweetedByImage.image = nil;

        
    }
    
    
    self.retweetCount.text = [NumberFormatter suffixNumber:[NSNumber numberWithInt:self.tweet.retweetCount]];
     self.favorCount.text = [NumberFormatter suffixNumber:[NSNumber numberWithInt:self.tweet.favoriteCount]];
    
    self.profileImage.image = nil;
    self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2;
    self.profileImage.clipsToBounds = YES;
    
    if (self.tweet.user.profileImageURL != nil) {
        [self.profileImage setImageWithURL:self.tweet.user.profileImageURL];
    }
    
    if(self.tweet.favorited){
        
        [self.favoriteButton setSelected:YES];
        self.favorCount.textColor = [UIColor redColor];
        
        
        
    }
    
    else{
        
        [self.favoriteButton setSelected:NO];
        self.favorCount.textColor = [UIColor lightGrayColor];
        
        
        
        
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
    
    


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet{
    // Since we're replacing the default setter, we have to set the underlying private storage _movie ourselves.
    // _movie was an automatically declared variable with the @propery declaration.
    // You need to do this any time you create a custom setter.
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
