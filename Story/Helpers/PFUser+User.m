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

+(void)contributedForUser:(PFUser *)user successBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    PFQuery *query = [PFQuery queryWithClassName:SENTENCE_CLASSNAME];
    __block NSMutableDictionary *userContributed = [NSMutableDictionary dictionary];
    [query whereKey:SENTENCE_KEY_WRITER equalTo:user];
    [query whereKey:SENTENCE_KEY_ISSELECTED equalTo:[NSNumber numberWithBool:YES]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error){
            failureBlock(error);
        }else{
            if(nil!= objects){
                [userContributed setObject:objects forKey:@"sentences"];
            }
            PFQuery *queryStory = [PFQuery queryWithClassName:STORY_CLASSNAME];
            [query whereKey:STORY_KEY_OWNER equalTo:user];
            
            
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
