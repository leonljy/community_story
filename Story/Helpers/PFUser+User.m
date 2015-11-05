//
//  PFUser+User.m
//  Story
//
//  Created by Leonljy on 2015. 10. 7..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "PFUser+User.h"
#import "PFObject+Story.h"
#import "PFObject+Sentence.h"

@implementation PFUser (User)


+(void)contributedCurrentUserWithSuccessBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    PFUser *user = [PFUser currentUser];
    [user contributedForUserSuccessBlock:^(NSArray *objects) {
        successBlock(objects);
    } failureBlock:^(NSError *error) {
        failureBlock(error);
    }];
}
-(void)contributedForUserSuccessBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    PFQuery *querySentence = [PFQuery queryWithClassName:SENTENCE_CLASSNAME];
//    __block NSMutableDictionary *userContributed = [NSMutableDictionary dictionary];
    __block NSMutableArray *contributes = [NSMutableArray array];
    [querySentence whereKey:SENTENCE_KEY_WRITER equalTo:self];
    [querySentence whereKey:SENTENCE_KEY_ISSELECTED equalTo:[NSNumber numberWithBool:YES]];
    [querySentence orderByDescending:SENTENCE_KEY_CREATED_AT];
    [querySentence findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error){
            failureBlock(error);
        }else{
//            if(nil!= objects){
//                [userContributed setObject:objects forKey:@"sentences"];
//            }
            NSMutableArray *objectIds = [NSMutableArray array];
            
            for(PFObject *sentence in objects){
                [contributes addObject:sentence];
                PFObject *story = sentence[SENTENCE_KEY_STORY];
                [objectIds addObject:story.objectId];
            }
            PFQuery *queryMyStory = [PFQuery queryWithClassName:STORY_CLASSNAME];
            [queryMyStory whereKey:STORY_KEY_OWNER equalTo:self];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"objectId IN %@", objectIds];
            PFQuery *queryContributedStory = [PFQuery queryWithClassName:STORY_CLASSNAME predicate:predicate];

            PFQuery *query = [PFQuery orQueryWithSubqueries:@[queryMyStory, queryContributedStory]];
            [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if(error){
                    failureBlock(error);
                }else{
                    for(PFObject *story in objects){
                        [contributes addObject:story];
                    }
                    NSSortDescriptor *createdTimeDescr = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:YES];
                    NSArray *sortDescriptors = @[createdTimeDescr];
                    NSArray *sortedArray = [contributes sortedArrayUsingDescriptors:sortDescriptors];
                    successBlock(sortedArray);
                }
            }];
        }
    }];
}

-(void)updateUsername:(NSString *)username successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    self.username = username;
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            successBlock(nil);
        }else{
            failureBlock(error);
        }
    }];
}

@end
