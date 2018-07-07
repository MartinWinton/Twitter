//
//  Tweet.m
//  twitter
//
//  Created by Martin Winton on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "Tweet.h"

#import "User.h"
#import "DateTools.h"
@implementation Tweet

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        // Is this a re-tweet?
        NSDictionary *originalTweet = dictionary[@"retweeted_status"];
        if(originalTweet != nil){
            NSDictionary *userDictionary = dictionary[@"user"];
            self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];
            
            // Change tweet to original tweet
            dictionary = originalTweet;
        }
        self.idStr = dictionary[@"id_str"];
        self.text = dictionary[@"text"];
        self.favoriteCount = [dictionary[@"favorite_count"] intValue];
        self.favorited = [dictionary[@"favorited"] boolValue];
        self.retweetCount = [dictionary[@"retweet_count"] intValue];
        self.retweeted = [dictionary[@"retweeted"] boolValue];
        
        self.entities = dictionary[@"entities"];
        NSArray *array = self.entities[@"media"];
        self.mediaDictionary = array[0];
        NSString *media = self.mediaDictionary[@"media_url_https"];
        self.imageURL = [NSURL URLWithString:self.mediaDictionary[@"media_url_https"]];
        
        User *user = [[User alloc] initWithDictionary:dictionary[@"user"]];
        self.user = user;
        
        // Format createdAt date string
        NSString *createdAtOriginalString = dictionary[@"created_at"];
        
        self.createdAtString = createdAtOriginalString;
   
        
    }
    return self;
    
    
}

+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries{
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}

@end
