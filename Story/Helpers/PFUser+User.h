//
//  PFUser+User.h
//  Story
//
//  Created by Leonljy on 2015. 10. 7..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import <Parse/Parse.h>

#define USER_KEY_USERNAME @"username"
#define USER_KEY_EMAIL @"email"
#define USER_KEY_ISUSERNAME_SET @"isUsernameSet"
#define USER_KEY_BOOKMARKED_STORIES @"bookMarkedStories"

@interface PFUser (User)

typedef void (^ArrayBlock)(NSArray *objects);
typedef void (^SuccessBlock)(id responseObject);
typedef void (^FailureBlock)(NSError *error);

-(void)updateUsername:(NSString *)username successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
@end
