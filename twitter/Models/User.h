//
//  User.h
//  twitter
//
//  Created by Martin Winton on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *name;
@property (nonatomic)  BOOL *verified;
@property (nonatomic)  NSString *idStr;


@property (strong, nonatomic) NSString *screenName;
@property (strong, nonatomic) NSString *followersCountString;
@property (strong, nonatomic) NSString *followingCountString;
@property (strong, nonatomic) NSNumber *followerTest;

@property (strong, nonatomic) NSString *tweetCountString;


@property (strong, nonatomic) NSString *locationString;
@property (strong, nonatomic) NSString *descriptionString;



@property (strong, nonatomic) NSURL *profileImageURL;
@property (strong, nonatomic) NSURL *bannerURL;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
