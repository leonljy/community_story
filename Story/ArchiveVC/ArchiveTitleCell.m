//
//  ArchiveTitleCell.m
//  Story
//
//  Created by Leonljy on 2015. 11. 3..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "ArchiveTitleCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NovelistConstants.h"
@implementation ArchiveTitleCell

- (void)awakeFromNib {
    // Initialization code
    [self.labelTitle setFont:[UIFont systemFontOfSize:[NovelistConstants getLabelFontSize]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setContents:(PFObject *)story{
    self.labelTitle.text = story[STORY_KEY_TITLE];
    PFFile *image = story[STORY_KEY_IMAGE];
    [self.imageViewImage sd_setImageWithURL:[NSURL URLWithString:image.url] placeholderImage:nil];
    [self.imageViewImage setContentMode:UIViewContentModeScaleAspectFill];
    [self.imageViewImage setClipsToBounds:YES];
}

@end
