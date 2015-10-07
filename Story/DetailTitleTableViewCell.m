//
//  DetailTitleTableViewCell.m
//  Story
//
//  Created by Kwanghwi Kim on 2015. 10. 5..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "DetailTitleTableViewCell.h"

@implementation DetailTitleTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)handleNotification:(id)sender {
    UIButton *buttonNotification = (UIButton *)sender;
    [buttonNotification setEnabled:NO];
}
- (IBAction)handleBookmark:(id)sender {
    UIButton *buttonBookmark = (UIButton *)sender;
    [buttonBookmark setEnabled:NO];
}

@end
