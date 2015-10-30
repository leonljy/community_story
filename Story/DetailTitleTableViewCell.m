//
//  DetailTitleTableViewCell.m
//  Story
//
//  Created by Kwanghwi Kim on 2015. 10. 5..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "DetailTitleTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

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
    if(buttonBookmark.selected){
        [self.story cancelBookmarkWithSuccessBlock:^(id responseObject) {
            [buttonBookmark setEnabled:YES];
            buttonBookmark.selected = NO;
        } failureBlock:^(NSError *error) {
            [buttonBookmark setEnabled:YES];
        }];
    }else{
        [self.story bookmarkWithSuccessBlock:^(id responseObject) {
            [buttonBookmark setEnabled:YES];
            buttonBookmark.selected = YES;
        } failureBlock:^(NSError *error) {
            [buttonBookmark setEnabled:YES];
        }];
    }
}

-(void)setStoryPhoto{
    PFFile *image = self.story[STORY_KEY_IMAGE];
    [self.imageViewPhoto sd_setImageWithURL:[NSURL URLWithString:image.url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.imageViewPhoto setImage:image];
        [self.imageViewPhoto setClipsToBounds:YES];
        [self.imageViewPhoto setContentMode:UIViewContentModeScaleAspectFill];
    }];
}

@end
