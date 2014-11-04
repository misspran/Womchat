//
//  ContactsViewController.m
//  Womchat
//
//  Created by S on 11/3/14.
//  Copyright (c) 2014 Vi & Ryan. All rights reserved.
//

#import "ContactsViewController.h"
#import <Parse/Parse.h>
#import "FacebookFriend.h"

@interface ContactsViewController () <UITableViewDataSource, UITableViewDelegate>

@property NSArray *contacts;
@property NSMutableDictionary *contactsSeparated;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.contacts = [[NSArray alloc] init];
    self.contactsSeparated = [[NSMutableDictionary alloc] init];

    [self queryForContacts];
}

-(void)queryForContacts
{
    PFQuery *queryForContacts = [PFQuery queryWithClassName:@"FacebookFriend"];
    [queryForContacts whereKey:@"friendOf" equalTo:[PFUser currentUser]];
    [queryForContacts findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.userInfo);
            self.contacts = [NSArray array];
        }
        else
        {
            self.contacts = [objects sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]; //I think I'll need to make it reference the name specifically?
            [self placeContactsInDictionary];
        }
    }];
}

-(void)placeContactsInDictionary
{
    for (FacebookFriend *contact in self.contacts)
    {
        NSString *firstLetter = [contact.name substringToIndex:0];
        firstLetter =[firstLetter uppercaseString];

        if ([self.contactsSeparated objectForKey:firstLetter] == nil)
        {
            self.contactsSeparated
        }
    }
}

#pragma mark TableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    return cell;
}

@end
