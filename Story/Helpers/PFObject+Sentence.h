//
//  PFObject+Sentence.h
//  Story
//
//  Created by Leonljy on 2015. 10. 7..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import <Parse/Parse.h>
#define SENTENCE_CLASSNAME              @"Sentence"
#define SENTENCE_KEY_WRITER             @"writer"
#define SENTENCE_KEY_WRITER_NAME        @"writerName"
#define SENTENCE_KEY_UPVOTED_COUNT      @"upVotedCount"
#define SENTENCE_KEY_UPVOTED_USERS      @"upVotedUsers"
#define SENTENCE_KEY_DOWNVOTED_COUNT    @"downVotedCount"
#define SENTENCE_KEY_DOWNVOTED_USERS    @"downVotedUsers"
#define SENTENCE_KEY_STORY              @"story"
#define SENTENCE_KEY_SEQUENCE           @"sequence"
#define SENTENCE_KEY_TEXT               @"text"
#define SENTENCE_KEY_END_SENTENCE       @"isEndSentence"
#define SENTENCE_KEY_VOTE_POINT         @"votePoint"
#define SENTENCE_KEY_ISSELECTED         @"isSelected"
#define SENTENCE_KEY_IMAGE              @"image"
#define SENTENCE_KEY_CREATED_AT          @"createdAt"


@interface PFObject (Sentence)
typedef void (^ArrayBlock)(NSArray *objects);
typedef void (^SuccessBlock)(id responseObject);
typedef void (^FailureBlock)(NSError *error);

#pragma mark Voted Sentences
+(PFObject *)testStory;//Test Code
//+(void)currentSentencesForStory:(PFObject *)story successBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock;
+(void)currentUpVotedSentencesForStory:(PFObject *)story successBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock;
+(void)currentDownVotedSentencesForStory:(PFObject *)story successBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock;
//+(void)selectedSentencesForStory:(PFObject *)story successBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock;
+(void)sentencesForDetailStory:(PFObject *)story successBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock;
+(void)sentencesForArchivedStory:(PFObject *)story successBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock;
//+(void)sentencesForStory:(PFObject *)story sequence:(NSInteger)sequence successBlock:(ArrayBlock)successBlock failureBlock:(FailureBlock)failureBlock;
//+(void)upVotedSentencesForStory:(PFObject *)story sequence:(NSInteger)sequence successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
//+(void)downVotedSentencesForStory:(PFObject *)story sequence:(NSInteger)sequence successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

#pragma mark Save
-(void)saveNewSentenceWithSuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

#pragma mark Up/Down Votes
-(void)cancelUpVoteWithSuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
-(void)upVoteWithSuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
-(void)downVoteWithSuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
-(void)cancelDownVoteWithSuccessBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

@end
