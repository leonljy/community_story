//
//  DetailContentsTableViewCell.m
//  Story
//
//  Created by Kwanghwi Kim on 2015. 10. 5..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "DetailContentsTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+Tool.h"
#import "NovelistConstants.h"

@implementation DetailContentsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.labelContents setFont:[UIFont systemFontOfSize:[NovelistConstants getTextFontSize]]];
    [self.labelContents setTextColor:[UIColor colorTextGrey]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setSentenceImageViewWithFrame:(CGRect)frame sentence:(PFObject *)sentence{
    if(nil==self.imageViewSentence){
        self.imageViewSentence = [[UIImageView alloc] initWithFrame:frame];
        [self.imageViewSentence setClipsToBounds:YES];
        [self.imageViewSentence setContentMode:UIViewContentModeScaleAspectFill];
        [self.contentView addSubview:self.imageViewSentence];
    }
    PFFile *image = sentence[SENTENCE_KEY_IMAGE];
    [self.imageViewSentence sd_setImageWithURL:[NSURL URLWithString:image.url] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
}

@end
