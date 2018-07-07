//
//  MediaCell.h
//  twitter
//
//  Created by Martin Winton on 7/6/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
@protocol MediaCellDelegate

- (void)getTweet:(Tweet *)tweet;

@end
@interface MediaCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *tweetTime;
@property (weak, nonatomic) IBOutlet UILabel *tweetUsername;
@property (weak, nonatomic) IBOutlet UIButton *tweetImage;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *tweetScreen;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIImageView *mediaImg;
@property (weak, nonatomic) Tweet *tweet;
@property (nonatomic, weak) id<MediaCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;



@end
