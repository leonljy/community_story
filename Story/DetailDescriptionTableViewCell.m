//
//  DetailDescriptionTableViewCell.m
//  Story
//
//  Created by Kwanghwi Kim on 2015. 10. 5..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "DetailDescriptionTableViewCell.h"
#import "UIColor+Tool.h"
#import "NovelistConstants.h"
@implementation DetailDescriptionTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.labelCategory setFont:[UIFont systemFontOfSize:[NovelistConstants getLabelFontSize]]];
    [self.labelDescription setFont:[UIFont systemFontOfSize:[NovelistConstants getTextFontSize]]];
    [self.labelDescription setTextColor:[UIColor colorTextGrey]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
