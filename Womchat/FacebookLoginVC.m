//
//  FacebookLoginVC.m
//  Womchat
//
//  Created by Vi on 11/3/14.
//  Copyright (c) 2014 Vi & Ryan. All rights reserved.
//

#import "FacebookLoginVC.h"
#import <FacebookSDK/FacebookSDK.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface FacebookLoginVC ()<FBLoginViewDelegate>


@end

@implementation FacebookLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];

    FBLoginView *loginView = [[FBLoginView alloc] init];
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 5);
    
    [self.view addSubview:loginView];

    
}

////- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
////                            user:(id<FBGraphUser>)user {
////    self.profilePictureView.profileID = user.id;
////    self.userName.text = user.name;
////}
////
////- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
////    self.statusLabel.text = @"You're logged in as";
////}
////
////- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
////    self.profilePictureView.profileID = nil;
////    self.userName.text = @"";
////    self.statusLabel.text= @"You're not logged in!";
//}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;

    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];

        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";

        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");

        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }

    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}
//-(void)FBLoggedInActiveSession: (BOOL){
//
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
