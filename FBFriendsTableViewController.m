//
//  FBFriendsTableViewController.m
//  Womchat
//
//  Created by Vi on 11/5/14.
//  Copyright (c) 2014 Vi & Ryan. All rights reserved.
//

#import "FBFriendsTableViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <AddressBook/AddressBook.h>

@interface FBFriendsTableViewController ()
@property NSArray *friendsList;
@property NSMutableArray *contactList;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FBFriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsList =  [NSArray new];
    self.title = @"Facebook Friends";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.099 green:0.367 blue:0.654 alpha:1.000];
  //  [self permissionsContacts];
    

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSDictionary *friend = self.friendsList[indexPath.row];
    NSLog(@"Friend: %@", friend);
    cell.textLabel.text = friend[@"name"];

//    UIImage *defaultPhoto = [UIImage imageNamed:@"facebook_avatar.png"];
//    cell.imageView.image = defaultPhoto;
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", friend[@"id"]];
    NSURL *avatarUrl = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:avatarUrl];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        cell.imageView.image = [UIImage imageWithData:data];
    }];



    cell.imageView.contentMode = UIViewContentModeCenter;

    return cell;
}



@end
