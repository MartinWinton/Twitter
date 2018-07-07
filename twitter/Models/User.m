//
//  User.m
//  twitter
//
//  Created by Martin Winton on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "User.h"
#import "NumberFormatter.h"
@implementation User

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
        self.idStr = dictionary[@"id_str"];
        self.name = dictionary[@"name"];
        self.verified = [dictionary[@"verified"] boolValue];
        

      
        
        long followers  = [dictionary[@"followers_count"] integerValue];
        
        self.followersCountString = [NumberFormatter suffixNumber:[NSNumber numberWithLong:followers]];
        
        long following  = [dictionary[@"friends_count"] integerValue];

        
     
      self.followingCountString = [NumberFormatter suffixNumber:[NSNumber numberWithLong:following]];
        self.tweetCountString = [ NSString stringWithFormat:@"%@",dictionary[@"statuses_count"]];
        



        self.locationString =  [ NSString stringWithFormat:@"%@",dictionary[@"location"]];
        self.descriptionString =  [ NSString stringWithFormat:@"%@",dictionary[@"description"]];



        self.screenName = dictionary[@"screen_name"];
        self.profileImageURL = [NSURL  URLWithString:[dictionary[@"profile_image_url_https"] stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"]];
        
        
         self.bannerURL = [NSURL URLWithString:dictionary[@"profile_banner_url"]];
    }
    return self;
}

@end
