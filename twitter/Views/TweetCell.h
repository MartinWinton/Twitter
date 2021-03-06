//
//  TweetCell.h
//  twitter
//
//  Created by Martin Winton on 7/2/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "TTTAttributedLabel.h"

@protocol TweetCellDelegate

- (void)getTweet:(Tweet *)tweet;

@end

@interface TweetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *tweetUsername;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *tweetDate;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;

@property (weak, nonatomic) IBOutlet UILabel *favorCount;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) Tweet *tweet;

@property (weak, nonatomic) IBOutlet TTTAttributedLabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;

@property (nonatomic, weak) id<TweetCellDelegate> delegate;




@end
