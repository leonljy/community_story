//
//  ArchiveContributesCell.m
//  Story
//
//  Created by Leonljy on 2015. 11. 3..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "ArchiveContributesCell.h"
#import "NovelistConstants.h"

@implementation ArchiveContributesCell

- (void)awakeFromNib {
    // Initialization code
    [self.labelUserName setFont:[UIFont systemFontOfSize:[NovelistConstants getTextFontSize]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setContents:(NSString *)userName{
    [self.labelUserName setText:userName];
}
@end
