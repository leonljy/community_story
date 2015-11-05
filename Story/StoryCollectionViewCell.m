//
//  FeaturedStoryCell.m
//  Story
//
//  Created by Leonljy on 2015. 10. 19..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "StoryCollectionViewCell.h"
#import "PFObject+Story.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+Tool.h"

@implementation StoryCollectionViewCell
-(void)awakeFromNib{
    [self.labelUnderline setFont:[UIFont systemFontOfSize:15]];
    [self.labelStoryText setFont:[UIFont systemFontOfSize:13]];
    [self.labelPopular setFont:[UIFont systemFontOfSize:10]];
    [self.constraintLineHeight setConstant:0.5];
}

-(void)setLabelColorsForMain{
    [self.labelPopular setTextColor:[UIColor colorGrayWith:100]];
    [self.labelStoryText setTextColor:[UIColor colorGrayWith:100]];
    [self.labelUnderline setTextColor:[UIColor blackColor]];
}

-(void)setLabelColorsForOthers{
    [self.labelPopular setTextColor:[UIColor whiteColor]];
    [self.labelStoryText setTextColor:[UIColor whiteColor]];
    [self.labelUnderline setTextColor:[UIColor whiteColor]];
}

-(void)setStandardStoryDatasToUI:(PFObject *)story{
    [self setStoryTitle:story];
    
    [self setStoryText:story];
    
    [self setStoryPopular:story];
    [self setLabelColorsForMain];
}
-(void)setFeaturedStoryDatasToUI:(PFObject *)story{
    [self setStoryTitle:story];
    
    [self setStoryText:story];
    
    [self setStoryPopular:story];
    
    [self setStoryPhoto:story];
    [self setLabelColorsForMain];
}
-(void)setAchievedStoryDatasToUI:(PFObject *)story{
    [self setStoryTitle:story];
    
    [self setStoryText:story];
    
    [self setStoryPopular:story];
    
    [self setStoryPhoto:story];
    [self setLabelColorsForOthers];
}

-(void)setStoryPhoto:(PFObject *)story{
    PFFile *image = story[STORY_KEY_IMAGE];
    [self.imageViewPhoto sd_setImageWithURL:[NSURL URLWithString:image.url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self.imageViewPhoto setImage:image];
        [self.imageViewPhoto setClipsToBounds:YES];
        [self.imageViewPhoto setContentMode:UIViewContentModeScaleAspectFill];
    }];
}

-(void)setStoryPopular:(PFObject *)story{
    NSInteger currentSequece = [story[STORY_KEY_CURRENTSEQUENCE] integerValue];
    NSString *stringSequence = [NSString stringWithFormat:@"%ld", (long)currentSequece];
    NSInteger writersCount = [story[STORY_KEY_WRITERS_COUNT] integerValue];
    NSString *writersCountString = [NSString stringWithFormat:@"%ld", (long)writersCount];
    self.labelPopular.text = [NSString stringWithFormat:@"%@ Join %@ Comments", writersCountString, stringSequence];
}

-(void)setStoryTitle:(PFObject *)story{
    NSString *storyTitle = story[STORY_KEY_TITLE];
    self.labelUnderline.text = storyTitle;
    
//    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleThick), NSUnderlineColorAttributeName:[UIColor blackColor]};
//    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:storyTitle  attributes:underlineAttribute];
//    self.labelUnderline.attributedText = attrString;
}

-(void)setStoryText:(PFObject *)story{
//    NSString *storyText;
    NSString *prolougeText = story[STORY_KEY_FIRST_SENTENCE];
//    NSArray *text = story[STORY_KEY_SELECTED_TEXTS];
    
//    NSMutableString *selectedStrings = [NSMutableString new];
//    NSInteger sentenceNum = 5;
//    for (int i=0; i < [text count]; i++) {
//        if (i == sentenceNum) {
//            break;
//        }
//        [selectedStrings appendString: [NSString stringWithFormat:@"\n\n%d %@", i, [text objectAtIndex:i]]];
//    }
    
//    storyText = [NSString stringWithFormat:@"%@ %@", prolougeText, selectedStrings];
    self.labelStoryText.text = prolougeText ;
    
}

@end
