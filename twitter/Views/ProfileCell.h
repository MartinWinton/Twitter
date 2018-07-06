//
//  ProfileCell.h
//  twitter
//
//  Created by Martin Winton on 7/5/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface ProfileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *tweetBanner;
@property (weak, nonatomic) IBOutlet UIImageView *tweetProfile;
@property (weak, nonatomic) IBOutlet UILabel *tweetUsername;
@property (weak, nonatomic) IBOutlet UILabel *tweetScreenName;
@property (weak, nonatomic) IBOutlet UILabel *tweetDescription;
@property (weak, nonatomic) IBOutlet UILabel *tweetLocation;
@property (weak, nonatomic) IBOutlet UILabel *numFollowing;
@property (weak, nonatomic) IBOutlet UILabel *numFollowers;
@property (weak, nonatomic) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *verifiedImage;

@end
