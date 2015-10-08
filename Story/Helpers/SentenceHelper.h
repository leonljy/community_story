//
//  SentenceHelper.h
//  Story
//
//  Created by Leonljy on 2015. 10. 7..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#define SENTENCE_KEY_WRITER @"writer"
#define SENTENCE_KEY_UPVOTED_COUNT @"upVotedCount"
#define SENTENCE_KEY_DOWNVOTED_COUNT @"downVotedCount"
#define SENTENCE_KEY_UPVOTED_USERS @"upVotedUsers"
#define SENTENCE_KEY_DOWNVOTED_USERS @"downVotedUsers"
#define SENTENCE_KEY_STORY @"story"
#define SENTENCE_KEY_SEQUENCE @"sequence"
#define SENTENCE_KEY_TEXT @"text"
#define SENTENCE_KEY_END_SENTENCE @"isEndSentence"
#define SENTENCE_KEY_VOTE_POINT @"votePoint"

@interface SentenceHelper : NSObject
typedef void (^ArrayBlock)(NSArray *objects);
typedef void (^SuccessBlock)(id responseObject);
typedef void (^FailureBlock)(NSError *error);

-(void)createNewSentence:(PFObject *)sentence successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
+(SentenceHelper *)sharedInstance;
@end
