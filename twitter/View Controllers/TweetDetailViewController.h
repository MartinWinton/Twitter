//
//  TweetDetailViewController.h
//  twitter
//
//  Created by Martin Winton on 7/4/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@protocol TweetDetailViewControllerDelegate

- (void)didBack;

@end

@interface TweetDetailViewController : UIViewController



@property (weak, nonatomic) Tweet *tweet;

@property (nonatomic, weak) id<TweetDetailViewControllerDelegate> delegate;



@end
