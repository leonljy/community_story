//
//  ProfileContributeCell.m
//  Story
//
//  Created by Leonljy on 2015. 11. 3..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "ProfileContributeCell.h"
#import "NovelistConstants.h"
#import "UIColor+Tool.h"
@implementation ProfileContributeCell

- (void)awakeFromNib {
    // Initialization code
//    [self.labelName setFont:[UIFont systemFontOfSize:[NovelistConstants getLabelFontSize]]];
//    [self.labelSentence setFont:[UIFont systemFontOfSize:[NovelistConstants getTextFontSize]]];
//    [self.labelSentence setTextColor:[UIColor colorTextGrey]];
//    [self.textViewContribute setFont:[UIFont systemFontOfSize:[NovelistConstants getTextFontSize]]];
//    [self.textViewContribute setTextColor:[UIColor colorTextGrey]];
    [self.imageViewContent.layer setMasksToBounds:YES];
    self.imageViewContent.layer.cornerRadius = 5.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setStoryInfoWithStory:(PFObject *)story{
    NSInteger currentSequece = [story[STORY_KEY_CURRENTSEQUENCE] integerValue];
    NSString *stringSequence = [NSString stringWithFormat:@"%ld", (long)currentSequece];
    NSInteger writersCount = [story[STORY_KEY_WRITERS_COUNT] integerValue];
    NSString *writersCountString = [NSString stringWithFormat:@"%ld", (long)writersCount];
    self.labelInfo.text = [NSString stringWithFormat:@"%@ Join  |   %@ Comments", writersCountString, stringSequence];
}
@end
