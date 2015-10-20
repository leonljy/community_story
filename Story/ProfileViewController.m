//
//  ProfileViewController.m
//  Story
//
//  Created by john kim on 10/1/15.
//  Copyright © 2015 Favorie&John. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileUserCell.h"
#import "PFUser+User.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProfileUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_USER_PROFILE"];
    [cell.buttonLogout addTarget:self action:@selector(handleLogout) forControlEvents:UIControlEventTouchUpInside];
    [cell.labelUsername setText:[[PFUser currentUser] username]];
    [cell.labelUserDescription setText:[[PFUser currentUser] email]];
    return cell;
}


-(void)handleLogout{
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(error){
            
        }else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
            LoginViewController *loginVieWController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            [UIView transitionWithView:appDelegate.window
                              duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{
                                [appDelegate.window setRootViewController:loginVieWController];
                            }
                            completion:nil];
        }
    }];
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
