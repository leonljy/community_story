//
//  NewStoryViewController.m
//  Story
//
//  Created by john kim on 10/1/15.
//  Copyright © 2015 Favorie&John. All rights reserved.
//

#import "NewStoryViewController.h"
#import <Parse/Parse.h>
#import "PFObject+Story.h"

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
    PFObject *newStory = [PFObject objectWithClassName:STORY_CLASSNAME];
    newStory[STORY_KEY_TITLE] = titleTextField.text;
    newStory[STORY_KEY_DESCRIPTION] = descriptionTextView.text;
    newStory[STORY_KEY_FIRST_SENTENCE] = prologueTextView.text;
    newStory[STORY_KEY_TEXT] = prologueTextView.text;
    [newStory saveNewStoryWithSuccessBlock:^(id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(NSError *error) {
        
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
