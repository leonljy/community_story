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

@interface NewUserViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textFieldUserName;
@property (weak, nonatomic) IBOutlet UIButton *buttonCheckAvailability;
@property (weak, nonatomic) IBOutlet UILabel *labelResultStatus;

@end

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
    user.username = self.textFieldUserName.text;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            [self presentMainViewController];
        }else{
            if([error.localizedDescription isEqualToString:@"Exist"]){
                user.username = beforeUserName;
                NSString *result = [NSString stringWithFormat:@"%@ already exists", self.textFieldUserName.text];
                [self.labelResultStatus setText:result];
                [self.textFieldUserName setText:@""];
                
            }
        }
    }];
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
                       options:UIViewAnimationOptionTransitionFlipFromLeft
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
