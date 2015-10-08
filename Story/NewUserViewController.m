//
//  NewUserViewController.m
//  Story
//
//  Created by Leonljy on 2015. 10. 6..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "NewUserViewController.h"
#import "AppDelegate.h"
#import "TabBarViewController.h"
#import <Parse/Parse.h>
#import "PFUser+User.h"

@interface NewUserViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldUserName;
@property (weak, nonatomic) IBOutlet UIButton *buttonCheckAvailability;
@property (weak, nonatomic) IBOutlet UILabel *labelResultStatus;

@end

static NSString *errorUsernameExist = @"Exist";

@implementation NewUserViewController{
    BOOL isAvailable;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isAvailable = NO;
    [self.buttonCheckAvailability setEnabled:NO];
    [self.textFieldUserName setDelegate:self];
}

- (IBAction)handleCheckAvailability:(id)sender {
    PFUser *user = [PFUser currentUser];
    NSString *beforeUserName = user.username;
    NSString *newUserName = self.textFieldUserName.text;
    
    [user updateUsername:newUserName successBlock:^(id responseObject) {
        [self presentMainViewController];
    } failureBlock:^(NSError *error) {
        if([error.localizedDescription isEqualToString:errorUsernameExist]){
            user.username = beforeUserName;
            NSString *result = [NSString stringWithFormat:@"* %@ already exists *", newUserName];
            [self.labelResultStatus setText:result];
            [self.textFieldUserName setText:@""];
        }
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.textFieldUserName resignFirstResponder];
    return YES;
}

- (IBAction)handleTextFieldChange:(id)sender {
    NSString *text = self.textFieldUserName.text;
    if(0<text.length){
        [self.buttonCheckAvailability setEnabled:YES];
    }else{
        [self.buttonCheckAvailability setEnabled:NO];
    }
}

-(void)presentMainViewController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    TabBarViewController *tabBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    
    [UIView transitionWithView:appDelegate.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        [appDelegate.window setRootViewController:tabBarViewController];
                    }
                    completion:nil];
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
