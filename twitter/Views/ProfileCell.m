//
//  ProfileCell.m
//  twitter
//
//  Created by Martin Winton on 7/5/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "ProfileCell.h"
#import "UIImageView+AFNetworking.h"
#import "NumberFormatter.h"


@implementation ProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) refreshProfile {
    
    self.tweetUsername.text = self.user.name;
    
    self.tweetScreenName.text = [NSString stringWithFormat:@"%@%@", @"@", self.user.screenName];

    
    self.tweetDescription.text = self.user.descriptionString;
    
    self.tweetLocation.text = self.user.locationString;
    

    
    self.numFollowing.text = self.user.followingCountString;
    
    self.numFollowers.text = self.user.followersCountString;
    
    self.tweetProfile.layer.cornerRadius = self.tweetProfile.frame.size.width/2;
    self.tweetProfile.clipsToBounds = YES;
    self.tweetProfile.layer.borderWidth = 1.5f;
    self.tweetProfile.layer.borderColor = [UIColor whiteColor].CGColor;
    self.tweetProfile.image = nil;
    if (self.user.profileImageURL != nil) {
        [self.tweetProfile setImageWithURL:self.user.profileImageURL];
    }
    
    if (self.user.bannerURL != nil) {
        [self.tweetBanner setImageWithURL:self.user.bannerURL];
    }
    
    self.verifiedImage.image = nil;
    if (self.user.verified) {
        [self.verifiedImage setImage:[UIImage imageNamed:@"selected-icon"]];
    }
    
    
    
    
    
    
    
}

- (void)setUser:(User *)user{
    
    _user = user;
    
    [self refreshProfile];
    
    
}

@end
