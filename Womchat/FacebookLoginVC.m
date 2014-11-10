//
//  FacebookLoginVC.m
//  Womchat
//
//  Created by Vi on 11/3/14.
//  Copyright (c) 2014 Vi & Ryan. All rights reserved.
//

#import "FacebookLoginVC.h"
#import "FBFriendsTableViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import <Parse/Parse.h>
#import "FacebookFriend.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>


@interface FacebookLoginVC ()<FBLoginViewDelegate>
@property (nonatomic, strong) ACAccountStore *accountStore;
@property NSArray *friendsObjectArray;


@end

@implementation FacebookLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setupAccountsStore];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAccountStoreChanged:) name:ACAccountStoreDidChangeNotification object:nil];
    [self loggedInSendFBinfoToParse];

    
}

//- (IBAction)FacebookLoginPressed:(id)sender {
//    FBFriendsTableViewController *facebookVC = [[FBFriendsTableViewController alloc]init];
//    facebookVC.accountStore = self.accountStore;
//    [self presentViewController:facebookVC animated:YES completion:nil];
//}
//
//-(void)setupAccountsStore{
//    self.accountStore = [[ACAccountStore alloc]init];
//    if(self.presentedViewController){
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//}
//
//
//- (void)onAccountStoreChanged:(NSNotification *)notification {
//    [self setupAccountsStore];
//
//    if (self.presentedViewController) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }
//}






-(void)loggedInSendFBinfoToParse{
    FBLoginView *loginView = [[FBLoginView alloc] init];
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 5);

    [self.view addSubview:loginView];
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator setTintColor:[UIColor blackColor]];
    [indicator startAnimating];
    [self.view addSubview:indicator];

    // Set permissions required from the facebook user account, you can find more about facebook permissions here https://developers.facebook.com/docs/facebook-login/permissions/v2.0
    NSArray *permissionsArray = @[ @"public_profile", @"email", @"user_location", @"user_friends"];

    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {

        [indicator stopAnimating];
        [indicator removeFromSuperview];

        
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                //                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                errorMessage = @"Uh oh. The user cancelled the Facebook login.";
            } else {
                //                NSLog(@"Uh oh. An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error"
                                                            message:errorMessage
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"Dismiss", nil];
            [alert show];
        } else{
            if (user.isNew) {
                FBRequest *request = [FBRequest requestForMe];
                [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if (!error) {
                        [[PFUser currentUser]setObject:[result objectForKey:@"id"] forKey:@"FacebookID"];
                        [[PFUser currentUser]setObject:[result objectForKey:@"name"] forKey:@"Name"];
                        [[PFUser currentUser]setObject:[result objectForKey:@"email"] forKey:@"Email"];
                        [[PFUser currentUser]setObject:[result objectForKey:@"user_friends"] forKey:@"UserFriends"];
                        [[PFUser currentUser]saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            FBFriendsTableViewController *facebookVC = [[FBFriendsTableViewController alloc]init];
                            facebookVC.accountStore = self.accountStore;
                            [self presentViewController:facebookVC animated:YES completion:nil];
                        }];

                    }
                }];
            }
        }

        FBFriendsTableViewController *facebookVC = [[FBFriendsTableViewController alloc]init];
        facebookVC.accountStore = self.accountStore;
        [self presentViewController:facebookVC animated:YES completion:nil];
        [self requestForFBFriends];

        }];
    }




-(void)requestForFBFriends{


    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result will contain an array with your user's friends in the "data" key
            NSArray *friendsObjects = [result objectForKey:@"data"];

            for (NSDictionary *friendObject in friendsObjects) {
                FacebookFriend *friend = [[FacebookFriend object]objectForKey:@"name"];
                friend.name = [friendObject objectForKey:@"name"];
                friend.fbID = [friendObject objectForKey:@"fbID"];
                friend.friendOf = [PFUser currentUser];
                [friend saveInBackground];
                PFQuery *friendQuery = [PFUser query];
                [friendQuery whereKey:@"FacebookID" containedIn:friendsObjects];
                NSLog(@"QUACK: %@", friendsObjects);
                self.friendsObjectArray = [NSArray arrayWithObject:friendsObjects];
                NSString *userID = [[friendsObjects firstObject] objectForKey:@"id"];
                NSString *userURL = [[NSString stringWithFormat:@"/%@/friends",userID] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

                NSLog(@"Hello: %@",userURL);
                NSLog(@"heyy: %@", friendsObjects);
                [friend saveInBackground];

            }
        }
    }];
}







@end
