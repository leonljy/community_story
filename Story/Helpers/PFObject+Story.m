//
//  PFObject+Story.m
//  Story
//
//  Created by Leonljy on 2015. 10. 7..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "PFObject+Story.h"
#import "PFObject+User.h"
@implementation PFObject (Story)

+(void)storiesArchievedWithSuccessBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isEndedStory = YES"];
    PFQuery *query = [PFQuery queryWithClassName:STORY_CLASSNAME predicate:predicate];
    [query orderByDescending:STORY_KEY_ARCHIEVED_TIME];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            successBlock(objects);
        } else {
            failureBlock(error);
        }
    }];
}

+(void)storiesPopularWithSuccessBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isEndedStory = NO"];
    PFQuery *query = [PFQuery queryWithClassName:STORY_CLASSNAME predicate:predicate];
    [query orderByDescending:STORY_KEY_WRITERS_COUNT];
    [query addDescendingOrder:STORY_KEY_CURRENTSEQUENCE];
    [query addAscendingOrder:STORY_KEY_CREATED_TIME];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            successBlock(objects);
        } else {
            failureBlock(error);
        }
    }];
}

+(void)storiesBookmarkedWithSuccessBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    PFUser *user = [PFUser currentUser];
    NSArray *bookmarked = user[USER_KEY_BOOKMARKED_STORIES];
    [PFObject fetchAllInBackground:bookmarked block:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error){
            failureBlock(error);
        }else{
            successBlock(objects);
        }
    }];
}

-(void)printAllProperties{
    NSLog(@"\nObjectId: %@\nTitle: %@\nDescription: %@\nOwnerName: %@\bFirstSentence: %@", self.objectId, self[STORY_KEY_TITLE], self[STORY_KEY_DESCRIPTION], self[STORY_KEY_OWNER_NAME], self[STORY_KEY_FIRST_SENTENCE]);
}
-(void)bookmarkWithSuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    PFUser *user = [PFUser currentUser];
    if([user[USER_KEY_BOOKMARKED_STORIES] containsObject:self]){
        return;
    }else{
        [user addObject:self forKey:USER_KEY_BOOKMARKED_STORIES];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                successBlock(nil);
            }else{
                failureBlock(error);
            }
        }];
    }
}

-(void)cancelBookmarkWithSuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    PFUser *user = [PFUser currentUser];
    if([user[USER_KEY_BOOKMARKED_STORIES] containsObject:self]){
        [user removeObject:self forKey:USER_KEY_BOOKMARKED_STORIES];
        [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded){
                successBlock(nil);
            }else{
                failureBlock(error);
            }
        }];
    }else{
        return;
    }
}



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
