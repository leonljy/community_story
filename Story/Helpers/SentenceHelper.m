//
//  SentenceHelper.m
//  Story
//
//  Created by Leonljy on 2015. 10. 7..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "SentenceHelper.h"
#import "StoryHelper.h"
@implementation SentenceHelper

static SentenceHelper *instance;

+(SentenceHelper *)sharedInstance{
    if(nil==instance){
        instance = [[SentenceHelper alloc] init];
    }
    return instance;
}

-(void)createNewSentence:(PFObject *)sentence successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    // TODO: Testing Code
    
    PFObject *story = [self testStory];
    sentence = [self testNewSentence:story];
    /////////////////////
    
    //PFObject *story = sentence[SENTENCE_KEY_STORY];
    if([story[STORY_KEY_WRITERS] containsObject:[PFUser currentUser]]){
        NSLog(@"Contains");
    }else{
        NSLog(@"Not Contains");
        [story addObject:[PFUser currentUser] forKey:STORY_KEY_WRITERS];
        [story incrementKey:STORY_KEY_WRITERS_COUNT];
    }
    [PFObject saveAllInBackground:@[sentence, story] block:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded){
            successBlock(nil);
        }else{
            failureBlock(error);
        }
    }];
    
}

-(PFObject *)testStory{
    PFQuery *query = [PFQuery queryWithClassName:@"Story"];
    [query whereKey:@"title" equalTo:@"Test Story 1"];
    NSArray *stories = [query findObjects];
    PFObject *story = [stories firstObject];
    
//    for(PFObject *writer in story[STORY_KEY_WRITERS]){
//        NSLog(@"%@, id: %@", writer, writer.objectId);
//    }
    
    return story;
}

-(PFObject *)testNewSentence:(PFObject *)story{
    PFObject *sentence = [PFObject objectWithClassName:@"Sentence"];
    sentence[SENTENCE_KEY_WRITER] = [PFUser currentUser];
    sentence[SENTENCE_KEY_UPVOTED_COUNT] = [NSNumber numberWithInteger:0];
    sentence[SENTENCE_KEY_DOWNVOTED_COUNT] = [NSNumber numberWithInteger:0];
    sentence[SENTENCE_KEY_STORY] = story;
    sentence[SENTENCE_KEY_TEXT] = @"TestText";
    sentence[SENTENCE_KEY_END_SENTENCE] = [NSNumber numberWithBool:NO];
    sentence[SENTENCE_KEY_SEQUENCE] = [NSNumber numberWithInteger:0];
    return sentence;
}
@end
