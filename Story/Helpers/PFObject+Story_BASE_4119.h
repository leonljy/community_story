//
//  PFObject+Story.h
//  Story
//
//  Created by Leonljy on 2015. 10. 7..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import <Parse/Parse.h>

#define STORY_CLASSNAME @"Story"
#define STORY_KEY_DESCRIPTION @"description"
#define STORY_KEY_TITLE @"title"
#define STORY_KEY_FIRST_SENTENCE @"prologue"
#define STORY_KEY_TEXT @"text"
#define STORY_KEY_OWNER @"owner"
#define STORY_KEY_OWNER_NAME @"ownerName"
#define STORY_KEY_ISENDED_STORY @"isEndedStory"
#define STORY_KEY_DEADLINE @"deadline"
#define STORY_KEY_CURRENTSEQUENCE @"currentSequence"
#define STORY_KEY_WRITERS_COUNT @"writersCount"
#define STORY_KEY_WRITERS @"writers"
#define STORY_KEY_ARCHIEVED_TIME @"archievedAt"
#define STORY_KEY_IMAGE @"image"
#define STORY_KEY_CREATED_TIME @"createdAt"

@interface PFObject (Story)

typedef void (^ArrayBlock)(NSArray *objects);
typedef void (^SuccessBlock)(id responseObject);
typedef void (^FailureBlock)(NSError *error);

#pragma mark - Class Functions

+(void)storiesBookmarkedWithSuccessBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock;
+(void)storiesPopularWithSuccessBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock;
+(void)storiesArchievedWithSuccessBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock;

#pragma mark - Instance Functions
-(void)printAllProperties;

-(void)saveNewStoryWithSuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

-(void)bookmarkWithSuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
-(void)cancelBookmarkWithSuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
@end
