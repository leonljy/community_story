//
//  NewStoryViewController.m
//  Story
//
//  Created by john kim on 10/1/15.
//  Copyright © 2015 Favorie&John. All rights reserved.
//

#import "NewStoryViewController.h"
#import <Parse/Parse.h>

@interface NewStoryViewController () 

@end

@implementation NewStoryViewController
@synthesize titleTextField;
@synthesize descriptionTextView;
@synthesize prologueTextView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveNewStory:(id)sender {
   
    
    PFObject *newStory = [PFObject objectWithClassName:@"Story"];
    newStory[@"title"] = titleTextField.text;
    newStory[@"description"] = descriptionTextView.text;
    newStory[@"prologue"] = prologueTextView.text;
    newStory[@"currentSequence"] = [NSNumber numberWithInteger:0];
    newStory[@"text"] = prologueTextView.text;
    newStory[@"isEndedStory"] = [NSNumber numberWithBool:NO];
    
    //Date formatter
    NSDate *today = [NSDate date];
    today = [today dateByAddingTimeInterval:1800];
    newStory[@"deadline"] = today;
    newStory[@"owner"] = [PFUser currentUser];
    newStory[@"ownerName"] = [[PFUser currentUser] username];
    
          [newStory saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            
            NSLog(@"The object has been saved.");
        } else {
            NSLog(@"There was a problem, check error.description");
        }
    }];

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
