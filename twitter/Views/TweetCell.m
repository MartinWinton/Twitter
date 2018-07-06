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

@interface TweetCell ()<TTTAttributedLabelDelegate>
@end
@implementation TweetCell
- (void)awakeFromNib {
    [super awakeFromNib];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon"] forState : UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState : UIControlStateSelected];
       [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState : UIControlStateHighlighted];
    
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

-(void) refreshData {
    
    
    self.tweetUsername.text = self.tweet.user.name;
    self.tweetLabel.text = self.tweet.text;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // Configure the input format to parse the date string
    formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
    // Convert String to Date
    NSDate *date = [formatter dateFromString:self.tweet.createdAtString];
    self.tweetDate.text = [NSString stringWithFormat:@"%@%@", @"· ", date.shortTimeAgoSinceNow];
    
    
    self.screenName.text = [NSString stringWithFormat:@"%@%@", @"@", self.tweet.user.screenName];
    
    
    self.retweetCount.text = [NumberFormatter suffixNumber:[NSNumber numberWithInt:self.tweet.retweetCount]];
     self.favorCount.text = [NumberFormatter suffixNumber:[NSNumber numberWithInt:self.tweet.favoriteCount]];
    
    self.profileImage.image = nil;
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
    
    [self refreshData];
}
    
    - (void)attributedLabel:(TTTAttributedLabel *)label
didSelectLinkWithURL:(NSURL *)url{
        
        
    
    
}
    
    
    

    


@end
