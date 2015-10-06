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
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

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
        [PFFacebookUtils logInInBackgroundWithAccessToken:accessToken
                                                    block:^(PFUser *user, NSError *error) {
                                                        
                                                        if (!user) {
                                                            NSLog(@"Uh oh. There was an error logging in.");
                                                        } else {
                                                            NSLog(@"User logged in through Facebook!");
                                                            NSLog(@"%@", [PFUser currentUser]);
                                                            [self presentMainViewController];
                                                        }
                                                    }];
    }else{
        [self.buttonLoginFB setHidden:NO];
    }
}

-(void)showButtonLoginFB{
    [self.buttonLoginFB setHidden:NO];
}

- (IBAction)handleLogin:(id)sender {
    NSArray *permissions = @[@"public_profile"];
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissions block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            NSLog(@"User logged in through Facebook!");
        }
    }];
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
