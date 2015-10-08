//
//  StandardTableViewCell.m
//  Story
//
//  Created by john kim on 10/6/15.
//  Copyright © 2015 Favorie&John. All rights reserved.
//

#import "StandardTableViewCell.h"

@implementation StandardTableViewCell
@synthesize standardTitle;
@synthesize standardDescription;
@synthesize currentUsersCount;
@synthesize currentSequenceCount;

- (void)awakeFromNib {
    // Initialization code
    
    standardDescription.lineBreakMode = NSLineBreakByWordWrapping;
    standardDescription.numberOfLines = 0;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
