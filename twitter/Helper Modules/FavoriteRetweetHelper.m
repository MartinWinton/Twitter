//
//  FavoriteRetweetHelper.m
//  twitter
//
//  Created by Martin Winton on 7/6/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "FavoriteRetweetHelper.h"
#import "Tweet.h"
#import "APIManager.h"

//Helper module for retweeting/favorting in TweetDetailViewController and TimelineViewController

@implementation FavoriteRetweetHelper

- (instancetype)initWithTweet:(Tweet *)tweet {
    
    self = [super init];
    if (self) {
        
        self.tweet = tweet;
        
        // should defensive copy here
        
    }
    
    return self;
    
    
    

}

-(void)toggleRetweet{
    
    if(self.tweet.retweeted){
        
        [self unretweet];
        
        
        
        
        
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
                [self.delegate didFailRetweet];
                
                
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
                
                
            }
            
        }];
        
        
        
        
    }
    else{
        
        [self retweet];
        
        
        
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
                [self.delegate didFailRetweet];
                
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
                
                
                
            }
            
        }];
        
        
        
        
    }
    
}

-(void)toggleFavorite{
    
    
    if(self.tweet.favorited){
        
        [self unfavorite];
        
        
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
                [self.delegate didFailFavorite];
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
                
                
                
            }
            
        }];
        
        
        
        
    }
    
    else{
        
        [self favorite];
        
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
                [self.delegate didFailFavorite];
                
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
                
            }
            
            
        }];
        
        
    }
}

-(void) unfavorite{
    
    self.tweet.favorited = NO;
    self.tweet.favoriteCount -= 1;
}

-(void) favorite{
    
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
    
}

-(void) unretweet{
    
    self.tweet.retweeted = NO;
    self.tweet.retweetCount -= 1;
}

-(void) retweet{
    
    self.tweet.retweeted = YES;
    self.tweet.retweetCount += 1;
}


@end
