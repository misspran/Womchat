//
//  FacebookFriends.h
//  Womchat
//
//  Created by S on 11/3/14.
//  Copyright (c) 2014 Vi & Ryan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <Foundation/Foundation.h>

@interface FacebookFriend : PFObject <PFSubclassing>

@property NSString *name;
@property NSString *fbID;
@property PFUser *friendOf;

@end
