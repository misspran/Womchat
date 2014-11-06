//
//  FBFriendsTableViewController.h
//  Womchat
//
//  Created by Vi on 11/5/14.
//  Copyright (c) 2014 Vi & Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface FBFriendsTableViewController : UITableViewController
@property (nonatomic, strong) ACAccountStore *accountStore;

@end
