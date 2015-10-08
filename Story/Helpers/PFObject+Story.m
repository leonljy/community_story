//
//  PFObject+Story.m
//  Story
//
//  Created by Leonljy on 2015. 10. 7..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "PFObject+Story.h"

@implementation PFObject (Story)

-(void)saveNewStoryWithSuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    self[STORY_KEY_CURRENTSEQUENCE] = [NSNumber numberWithInteger:0];
    self[STORY_KEY_ISENDED_STORY] = [NSNumber numberWithBool:NO];
    
    NSTimeInterval thirtyMinutes = 1800;
    NSDate *today = [NSDate date];
    self[STORY_KEY_DEADLINE] = [today dateByAddingTimeInterval:thirtyMinutes];
    self[STORY_KEY_OWNER] = [PFUser currentUser];
    self[STORY_KEY_OWNER_NAME] = [[PFUser currentUser] username];
    
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded){
            successBlock(nil);
        }else{
            failureBlock(error);
        }
    }];
}

@end
