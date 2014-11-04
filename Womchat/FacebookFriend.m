//
//  FacebookFriends.m
//  Womchat
//
//  Created by S on 11/3/14.
//  Copyright (c) 2014 Vi & Ryan. All rights reserved.
//

#import "FacebookFriend.h"

@implementation FacebookFriend

@dynamic name;
@dynamic fbID;
@dynamic friendOf;


+(NSString *)parseClassName
{
    return @"FacebookFriend";
}

+(void)load
{
    [self registerSubclass];
}

@end
