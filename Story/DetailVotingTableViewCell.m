//
//  DetailVotingTableViewCell.m
//  Story
//
//  Created by Kwanghwi Kim on 2015. 10. 5..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "DetailVotingTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation DetailVotingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)handleUp:(id)sender {
    
}
- (IBAction)handleDown:(id)sender {
    
}

-(void)setSentenceImageViewWithFrame:(CGRect)frame sentence:(PFObject *)sentence{
    if(nil==self.imageViewSentence){
        self.imageViewSentence = [[UIImageView alloc] initWithFrame:frame];
        [self.imageViewSentence setClipsToBounds:YES];
        [self.imageViewSentence setContentMode:UIViewContentModeScaleAspectFill];
        [self.viewContentBackground addSubview:self.imageViewSentence];
    }
    PFFile *image = sentence[SENTENCE_KEY_IMAGE];
    [self.imageViewSentence sd_setImageWithURL:[NSURL URLWithString:image.url] placeholderImage:nil];
}

@end
