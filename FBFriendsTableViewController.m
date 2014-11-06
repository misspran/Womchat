//
//  FBFriendsTableViewController.m
//  Womchat
//
//  Created by Vi on 11/5/14.
//  Copyright (c) 2014 Vi & Ryan. All rights reserved.
//

#import "FBFriendsTableViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FBFriendsTableViewController ()
@property NSArray *friendsList;

@end

@implementation FBFriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsList =  [NSArray new];
    self.title = @"Facebook Friends";
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.099 green:0.367 blue:0.654 alpha:1.000];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];


    [FBRequestConnection startWithGraphPath:@"/686865667/friendlists"
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection,
                                              id result,
                                              NSError *error
                                              ) {
                                NSArray *friendsArray = [result objectForKey:@"data"];
                                                    NSLog(@"Messages: %@",friendsArray);

                              /* handle the result */                          }];

    

    ACAccountType *facebookAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    id options = @{
                   ACFacebookAppIdKey: @"787735437936009",
                   ACFacebookPermissionsKey: @[ @"email", @"read_friendlists"],
                   ACFacebookAudienceKey: ACFacebookAudienceFriends
                   };
    [self.accountStore requestAccessToAccountsWithType:facebookAccountType
                                               options:options
                                            completion:^(BOOL granted, NSError *error) {
                                                if (granted) {
                                                    NSLog(@"Granted!");
                                                    ACAccount *fbAccount = [[self.accountStore accountsWithAccountType:facebookAccountType] lastObject];
                                                    [self fetchFacebookFriends:fbAccount];


                                                } else {
                                                    NSLog(@"Not granted: %@", error);
                                                }


                                            }];



    
}

-(void)fetchFacebookFriends:(ACAccount *)facebookAccount {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/me/friends"];
    SLRequest *friendsListRequest = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodGET
                                                      URL:[NSURL URLWithString:urlString]
                                               parameters:nil];

    friendsListRequest.account = facebookAccount;
    [friendsListRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            NSLog(@"Got a response: %@", [[NSString alloc] initWithData:responseData
                                                               encoding:NSUTF8StringEncoding]);
            if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                NSError *jsonError = nil;
                NSDictionary *friendsListData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                                options:NSJSONReadingAllowFragments
                                                                                  error:&jsonError];
                if (jsonError) {
                    NSLog(@"Error parsing friends list: %@", jsonError);
                } else {
                    self.friendsList = friendsListData[@"data"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }
            } else {
                NSLog(@"HTTP %d returned", urlResponse.statusCode);
            }
        } else {
            NSLog(@"ERROR Connecting");
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        });
    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.friendsList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary *friend = self.friendsList[indexPath.row];
    NSLog(@"Friend: %@", friend);
    cell.textLabel.text = friend[@"email"];
    return cell;
}



@end
