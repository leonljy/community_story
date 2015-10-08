//
//  PFUser+User.m
//  Story
//
//  Created by Leonljy on 2015. 10. 7..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "PFUser+User.h"

@implementation PFUser (User)

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
