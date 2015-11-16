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
    [self.labelName setFont:[UIFont systemFontOfSize:[NovelistConstants getLabelFontSize]]];
//    [self.labelSentence setFont:[UIFont systemFontOfSize:[NovelistConstants getTextFontSize]]];
//    [self.labelSentence setTextColor:[UIColor colorTextGrey]];
    [self.textViewContribute setFont:[UIFont systemFontOfSize:[NovelistConstants getTextFontSize]]];
    [self.textViewContribute setTextColor:[UIColor colorTextGrey]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
