//
//  ArchiveDescriptionCell.m
//  Story
//
//  Created by Leonljy on 2015. 11. 3..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "ArchiveDescriptionCell.h"

@implementation ArchiveDescriptionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setContents:(PFObject *)story{
    [self.labelDescription setText:story[STORY_KEY_DESCRIPTION]];
}

@end
