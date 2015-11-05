//
//  ProfileUserCell.m
//  Story
//
//  Created by Leonljy on 2015. 10. 20..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "ProfileUserCell.h"

@implementation ProfileUserCell

-(void)awakeFromNib{
    self.buttonLogout.layer.masksToBounds = YES;
    self.buttonLogout.layer.cornerRadius = 5.0;
}
@end
