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

@interface LoginViewController () <FBSDKLoginButtonDelegate>


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
//    loginButton.center = self.view.center;
//    loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
//
//    [self.view addSubview:loginButton];
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
    }];
//    [login
//     logInWithReadPermissions: @[@"public_profile"]
//     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//         if (error) {
//             NSLog(@"Process error");
//         } else if (result.isCancelled) {
//             NSLog(@"Cancelled");
//         } else {
//             NSLog(@"Logged in");
//         }
//     }];
}

-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error{
    
}

-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
}

-(BOOL)loginButtonWillLogin:(FBSDKLoginButton *)loginButton{
    return YES;
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
