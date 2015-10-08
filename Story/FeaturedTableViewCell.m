//
//  FeaturedTableViewCell.m
//  Story
//
//  Created by john kim on 10/6/15.
//  Copyright © 2015 Favorie&John. All rights reserved.
//

#import "FeaturedTableViewCell.h"

@implementation FeaturedTableViewCell
@synthesize featuredCellTitle;
@synthesize featuredCellDescription;
@synthesize featuredStoryText;
@synthesize featuredName;
@synthesize currentUsersCount;
@synthesize currentSequenceCount;


- (void)awakeFromNib {
    // Initialization code

    featuredCellDescription.lineBreakMode = NSLineBreakByWordWrapping;
    featuredCellDescription.numberOfLines = 0;
    featuredStoryText.lineBreakMode = NSLineBreakByWordWrapping;
    featuredStoryText.numberOfLines = 0;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
