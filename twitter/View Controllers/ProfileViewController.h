//
//  ProfileViewController.h
//  twitter
//
//  Created by Martin Winton on 7/3/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) User *user;
@property BOOL didClick;


@end
