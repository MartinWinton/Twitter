//
//  FavoriteRetweetHelper.h
//  twitter
//
//  Created by Martin Winton on 7/6/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tweet.h"

@protocol FavoriteRetweetHelperDelegate

- (void)didFailFavorite;
- (void)didFailRetweet;


@end

@interface FavoriteRetweetHelper : NSObject
@property (weak, nonatomic) Tweet *tweet;
@property (nonatomic, weak) id<FavoriteRetweetHelperDelegate> delegate;

- (instancetype)initWithTweet:(Tweet *)tweet;
- (void)toggleFavorite;
- (void)toggleRetweet;


@end
