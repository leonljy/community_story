//
//  LoginViewController.m
//  Story
//
//  Created by Leonljy on 2015. 10. 5..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "TabBarViewController.h"
#import "NewUserViewController.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "PFUser+User.h"
// Testing Codes
//#import "PFObject+Sentence.h"
//#import "PFObject+Story.h"

@interface LoginViewController () 
@property (weak, nonatomic) IBOutlet UIButton *buttonLoginFB;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.buttonLoginFB setHidden:YES];
    NSLog(@"%@", [PFUser currentUser]);
    if ([FBSDKAccessToken currentAccessToken]) {
        FBSDKAccessToken *accessToken = [FBSDKAccessToken currentAccessToken]; // Use existing access token.
        
        // Log In (create/update currentUser) with FBSDKAccessToken
        [PFFacebookUtils logInInBackgroundWithAccessToken:accessToken block:^(PFUser *user, NSError *error) {
            if (!user) {
                NSLog(@"Uh oh. There was an error logging in.");
            } else {
                NSLog(@"User logged in through Facebook!");
                [self presentViewControllerBasedOnUsernameSet:user];
                
                //TODO: Remove Testing Code
//                [PFObject storiesBookmarkedWithSuccessBlock:^(NSArray *objects) {
//                    for(PFObject *story in objects){
//                        [story printAllProperties];
//                    }
//                } failureBlock:^(NSError *error) {
//                    
//                }];
//                 [PFObject currentUpVotedSentencesForStory:[PFObject testStory] successBlock:^(id responseObject) {
//                        NSLog(@"%@", responseObject);
//                    } failureBlock:^(NSError *error) {
//                        NSLog(@"%@", error);
//                    }];
//                    [PFObject currentDownVotedSentencesForStory:[PFObject testStory] successBlock:^(id responseObject) {
//                        NSLog(@"%@", responseObject);
//                    } failureBlock:^(NSError *error) {
//                        NSLog(@"%@", error);
//                    }];
            }
        }];
    }else{
        [self.buttonLoginFB setHidden:NO];
    }
}

//
//-(PFObject *)testUnUpvote{
////    ObjectId: LoPLMGMD53
//    PFQuery *query = [PFQuery queryWithClassName:SENTENCE_CLASSNAME];
//    PFObject *object = [query getObjectWithId:@"LoPLMGMD53"];
//    return object;
//}
//
//-(PFObject *)testNewSentence{
//    PFObject *sentence = [PFObject objectWithClassName:SENTENCE_CLASSNAME];
//    sentence[SENTENCE_KEY_WRITER] = [PFUser currentUser];
//    sentence[SENTENCE_KEY_UPVOTED_COUNT] = [NSNumber numberWithInteger:0];
//    sentence[SENTENCE_KEY_DOWNVOTED_COUNT] = [NSNumber numberWithInteger:0];
//    sentence[SENTENCE_KEY_TEXT] = @"TestText";
//    sentence[SENTENCE_KEY_END_SENTENCE] = [NSNumber numberWithBool:NO];
//    sentence[SENTENCE_KEY_SEQUENCE] = [NSNumber numberWithInteger:0];
//    return sentence;
//}


-(void)showButtonLoginFB{
    [self.buttonLoginFB setHidden:NO];
}

-(void)presentViewControllerBasedOnUsernameSet:(PFUser *)user{
    if([user[USER_KEY_ISUSERNAME_SET] boolValue]){
        [self presentMainViewController];
    }else{
        [self presentNewUserViewController];
    }
}

- (IBAction)handleLogin:(id)sender {
    NSArray *permissions = @[@"public_profile"];
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissions block:^(PFUser *user, NSError *error) {
        if(error){
            //TODO: Show Alert View "There's something problem. Try again please."
        } else if(!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            //TODO: Show Alert View "Canceled Login."
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
            [self presentNewUserViewController];
        } else {
            NSLog(@"User logged in through Facebook!");
            [self presentViewControllerBasedOnUsernameSet:user];
        }
    }];
}

-(void)presentNewUserViewController{
    NewUserViewController *newUserViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewUserViewController"];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [UIView transitionWithView:appDelegate.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [appDelegate.window setRootViewController:newUserViewController];
                    }
                    completion:nil];
}

-(void)presentMainViewController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    TabBarViewController *tabBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

    
    [UIView transitionWithView:appDelegate.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [appDelegate.window setRootViewController:tabBarViewController];
                    }
                    completion:nil];
}

- (IBAction)handleTest:(id)sender {
    [self presentMainViewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
