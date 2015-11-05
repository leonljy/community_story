//
//  DetailFirstSentenceTableViewCell.m
//  Story
//
//  Created by Kwanghwi Kim on 2015. 10. 15..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "DetailFirstSentenceTableViewCell.h"
#import "UIColor+Tool.h"
#import "NovelistConstants.h"
@implementation DetailFirstSentenceTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.labelContents setFont:[UIFont systemFontOfSize:[NovelistConstants getTextFontSize]]];
    [self.labelContents setTextColor:[UIColor colorTextGrey]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
