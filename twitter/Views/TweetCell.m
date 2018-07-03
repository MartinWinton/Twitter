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

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon"] forState : UIControlStateNormal];
    [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState : UIControlStateSelected];
       [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState : UIControlStateHighlighted];
    
}
- (IBAction)didTapFavorite:(id)sender {
    

    
    if(self.tweet.favorited){
      
        
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
                self.tweet.favorited = NO;
                self.tweet.favoriteCount -= 1;

                
            }
        }];


        
        
    }
    
    else{

        
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                
                self.tweet.favorited = YES;
                self.tweet.favoriteCount += 1;
            }
        }];

        
    }
    [self refreshData];


}
- (IBAction)didTapRetweet:(id)sender {
    
    if(self.tweet.retweeted){

 
        
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
                
                self.tweet.retweeted = NO;
                self.tweet.retweetCount -= 1;
            }
        }];


        
        
    }
    else{
        
     
        
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
                
                self.tweet.retweeted = YES;
                self.tweet.retweetCount += 1;
                
            }
        }];


        
        
    }
    
    [self refreshData];

}

-(void) refreshData {
    
    self.tweetUsername.text = self.tweet.user.name;
    self.tweetLabel.text = self.tweet.text;
    self.tweetDate.text = self.tweet.createdAtString;
    self.screenName.text = [NSString stringWithFormat:@"%@%@", @"@", self.tweet.user.screenName];
    self.retweetCount.text = [[NSNumber numberWithInt:self.tweet.retweetCount] stringValue];
    self.favorCount.text = [[NSNumber numberWithInt:self.tweet.favoriteCount] stringValue];
    
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
        self.retweetCount.textColor = [UIColor greenColor];

        
        
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

@end
