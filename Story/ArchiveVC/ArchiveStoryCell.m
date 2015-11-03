//
//  ArchiveStoryCell.m
//  Story
//
//  Created by Leonljy on 2015. 11. 3..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "ArchiveStoryCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation ArchiveStoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setPrologue:(NSString *)prologue{
    [self.labelStory setText:prologue];
}
-(void)setContents:(PFObject *)sentence{
    [self.labelStory setText:sentence[SENTENCE_KEY_TEXT]];
    if(nil == sentence[SENTENCE_KEY_IMAGE]){
        self.imageViewStory = nil;
    }else{
        PFFile *image = sentence[SENTENCE_KEY_IMAGE];
        [self.imageViewStory sd_setImageWithURL:[NSURL URLWithString:image.url] placeholderImage:nil];
        [self.imageViewStory setContentMode:UIViewContentModeScaleAspectFill];
        [self.imageViewStory setClipsToBounds:YES];
    }
}

@end
