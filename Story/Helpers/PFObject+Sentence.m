//
//  PFObject+Sentence.m
//  Story
//
//  Created by Leonljy on 2015. 10. 7..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "PFObject+Sentence.h"
#import "PFObject+Story.h"

@implementation PFObject (Sentence)

#pragma mark - Fetch Datas from Server

+(void)sentencesForDetailStory:(PFObject *)story successBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    PFQuery *querySelected = [PFQuery queryWithClassName:SENTENCE_CLASSNAME];
    [querySelected whereKey:SENTENCE_KEY_STORY equalTo:story];
    [querySelected whereKey:SENTENCE_KEY_ISSELECTED equalTo:[NSNumber numberWithBool:YES]];
    
    PFQuery *queryCurrentSequence = [PFQuery queryWithClassName:SENTENCE_CLASSNAME];
    [queryCurrentSequence whereKey:SENTENCE_KEY_STORY equalTo:story];
    [queryCurrentSequence whereKey:SENTENCE_KEY_SEQUENCE equalTo:story[STORY_KEY_CURRENTSEQUENCE]];
    
    PFQuery *query = [PFQuery orQueryWithSubqueries:@[querySelected, queryCurrentSequence]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error){
            failureBlock(error);
        }else{
            NSSortDescriptor *sequenceDescr = [[NSSortDescriptor alloc] initWithKey:SENTENCE_KEY_SEQUENCE ascending:YES];
            NSArray *sortDescriptors = @[sequenceDescr];
            NSArray *sortedArray = [objects sortedArrayUsingDescriptors:sortDescriptors];
            successBlock(sortedArray);
        }
    }];
}
+(void)selectedSentencesForStory:(PFObject *)story successBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    PFQuery *query = [PFQuery queryWithClassName:SENTENCE_CLASSNAME];
    [query whereKey:SENTENCE_KEY_STORY equalTo:story];
    [query whereKey:SENTENCE_KEY_ISSELECTED equalTo:[NSNumber numberWithBool:YES]];
    [query orderByAscending:SENTENCE_KEY_SEQUENCE];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error){
            failureBlock(error);
        }else{
            successBlock(objects);
        }
    }];
}
+(void)currentSentencesForStory:(PFObject *)story successBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    NSInteger currentSequence = [story[STORY_KEY_CURRENTSEQUENCE] integerValue];
    [self sentencesForStory:story sequence:currentSequence successBlock:^(NSArray *objects) {
        successBlock(objects);
    } failureBlock:^(NSError *error) {
        failureBlock(error);
    }];
}

+(void)sentencesForStory:(PFObject *)story sequence:(NSInteger)sequence successBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    PFQuery *query = [PFQuery queryWithClassName:SENTENCE_CLASSNAME];
    [query whereKey:SENTENCE_KEY_STORY equalTo:story];
    [query whereKey:SENTENCE_KEY_SEQUENCE equalTo:[NSNumber numberWithInteger:sequence]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error){
            failureBlock(error);
        }else{
            successBlock(objects);
        }
    }];
}

+(void)currentUpVotedSentencesForStory:(PFObject *)story successBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    NSInteger currentSequence = [story[STORY_KEY_CURRENTSEQUENCE] integerValue];
    [self upVotedSentencesForStory:story sequence:currentSequence successBlock:successBlock failureBlock:failureBlock];
}

+(void)currentDownVotedSentencesForStory:(PFObject *)story successBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    NSInteger currentSequence = [story[STORY_KEY_CURRENTSEQUENCE] integerValue];
    [self downVotedSentencesForStory:story sequence:currentSequence successBlock:successBlock failureBlock:failureBlock];
}

+(void)upVotedSentencesForStory:(PFObject *)story sequence:(NSInteger)sequence successBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    PFQuery *query = [PFQuery queryWithClassName:SENTENCE_CLASSNAME];
    [query whereKey:SENTENCE_KEY_STORY equalTo:story];
    [query whereKey:SENTENCE_KEY_SEQUENCE equalTo:[NSNumber numberWithInteger:sequence]];
    [query whereKey:SENTENCE_KEY_UPVOTED_USERS equalTo:[PFUser currentUser]];
    [query includeKey:SENTENCE_KEY_UPVOTED_USERS];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error){
            failureBlock(error);
        }else{
            successBlock(objects);
        }
    }];
}

+(void)downVotedSentencesForStory:(PFObject *)story sequence:(NSInteger)sequence successBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    PFQuery *query = [PFQuery queryWithClassName:SENTENCE_CLASSNAME];
    [query whereKey:SENTENCE_KEY_STORY equalTo:story];
    [query whereKey:SENTENCE_KEY_SEQUENCE equalTo:[NSNumber numberWithInteger:sequence]];
    [query whereKey:SENTENCE_KEY_DOWNVOTED_USERS equalTo:[PFUser currentUser]];
    [query includeKey:SENTENCE_KEY_DOWNVOTED_USERS];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(error){
            failureBlock(error);
        }else{
            successBlock(objects);
        }
    }];
}


#pragma mark CRUD Sentence
-(void)saveNewSentenceWithSuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    self[SENTENCE_KEY_WRITER] = [PFUser currentUser];
    self[SENTENCE_KEY_WRITER_NAME] = [[PFUser currentUser] username];
    self[SENTENCE_KEY_UPVOTED_COUNT] = [NSNumber numberWithInt:0];
    self[SENTENCE_KEY_DOWNVOTED_COUNT] = [NSNumber numberWithInt:0];
    self[SENTENCE_KEY_ISSELECTED] = [NSNumber numberWithBool:NO];
    PFObject *story = self[SENTENCE_KEY_STORY];
    self[SENTENCE_KEY_SEQUENCE] = story[STORY_KEY_CURRENTSEQUENCE];
    
    if(nil==story){
        NSError *error = [NSError errorWithDomain:@"Nil Story" code:0 userInfo:nil];
        failureBlock(error);
    }
    
    if([story[STORY_KEY_WRITERS] containsObject:[PFUser currentUser]]){
        NSLog(@"Contains");
    }else{
        NSLog(@"Not Contains");
        [story addObject:[PFUser currentUser] forKey:STORY_KEY_WRITERS];
        [story incrementKey:STORY_KEY_WRITERS_COUNT];
    }
    [PFObject saveAllInBackground:@[self, story] block:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            successBlock(nil);
        }else{
            failureBlock(error);
        }
    }];
    
}



+(PFObject *)testStory{
    PFQuery *query = [PFQuery queryWithClassName:@"Story"];
    [query whereKey:@"title" equalTo:@"Test Story 1"];
    NSArray *stories = [query findObjects];
    PFObject *story = [stories firstObject];
    
    //    for(PFObject *writer in story[STORY_KEY_WRITERS]){
    //        NSLog(@"%@, id: %@", writer, writer.objectId);
    //    }
    
    return story;
}


#pragma mark Up/Down Votes
-(void)downVoteWithSuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    if([self[SENTENCE_KEY_DOWNVOTED_USERS] containsObject:[PFUser currentUser]]){
        return;
    }
    
    [self addObject:[PFUser currentUser] forKey:SENTENCE_KEY_DOWNVOTED_USERS];
    [self incrementKey:SENTENCE_KEY_DOWNVOTED_COUNT];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            successBlock(nil);
        }else{
            failureBlock(error);
        }
    }];
}

-(void)cancelDownVoteWithSuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    if([self[SENTENCE_KEY_DOWNVOTED_USERS] containsObject:[PFUser currentUser]]){
        [self removeObject:[PFUser currentUser] forKey:SENTENCE_KEY_DOWNVOTED_USERS];
        [self incrementKey:SENTENCE_KEY_DOWNVOTED_COUNT byAmount:[NSNumber numberWithInteger:-1]];
        [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
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

-(void)upVoteWithSuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    if([self[SENTENCE_KEY_UPVOTED_USERS] containsObject:[PFUser currentUser]]){
        return;
    }
    
    [self addObject:[PFUser currentUser] forKey:SENTENCE_KEY_UPVOTED_USERS];
    [self incrementKey:SENTENCE_KEY_UPVOTED_COUNT];
    [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            successBlock(nil);
        }else{
            failureBlock(error);
        }
    }];
}

-(void)cancelUpVoteWithSuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    if([self[SENTENCE_KEY_UPVOTED_USERS] containsObject:[PFUser currentUser]]){
        [self removeObject:[PFUser currentUser] forKey:SENTENCE_KEY_UPVOTED_USERS];
        [self incrementKey:SENTENCE_KEY_UPVOTED_COUNT byAmount:[NSNumber numberWithInteger:-1]];
        [self saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
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

@end
