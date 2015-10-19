//
//  FeaturedTableViewCell.m
//  Story
//
//  Created by john kim on 10/6/15.
//  Copyright © 2015 Favorie&John. All rights reserved.
//

#import "FeaturedTableViewCell.h"

@interface FeaturedTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *featuredCellTitle;
@property (weak, nonatomic) IBOutlet UILabel *featuredCellDescription;
@property (weak, nonatomic) IBOutlet UILabel *featuredStoryText;
@property (weak, nonatomic) IBOutlet UILabel *featuredName;
@property (weak, nonatomic) IBOutlet UILabel *currentUsersCount;
@property (weak, nonatomic) IBOutlet UILabel *currentSequenceCount;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewRepresent;

@property (weak, nonatomic) IBOutlet UILabel *labelTitleUnderline;

@end

@implementation FeaturedTableViewCell
@synthesize featuredCellTitle;
@synthesize featuredCellDescription;
@synthesize featuredStoryText;
@synthesize featuredName;
@synthesize currentUsersCount;
@synthesize currentSequenceCount;


- (void)awakeFromNib {
    // Initialization code

    featuredCellDescription.lineBreakMode = NSLineBreakByWordWrapping;
    featuredCellDescription.numberOfLines = 0;
    featuredStoryText.lineBreakMode = NSLineBreakByWordWrapping;
    featuredStoryText.numberOfLines = 0;

}

-(void)setStoryDatasToUI:(PFObject *)story{
    [self setStoryTitle:story];
    
    [self setStoryText:story];
    
    NSInteger currentSequece = [story[STORY_KEY_CURRENTSEQUENCE] integerValue];
    NSString *stringSequence = [NSString stringWithFormat:@"%ld", (long)currentSequece];
//    self.currentSequenceCount.text = stringSequence;
    
    NSInteger writersCount = [story[STORY_KEY_WRITERS_COUNT] integerValue];
    NSString *writersCountString = [NSString stringWithFormat:@"%ld", (long)writersCount];
    self.currentUsersCount.text = [NSString stringWithFormat:@"%@ Join %@ Comments", writersCountString, stringSequence];
}

-(void)setStoryTitle:(PFObject *)story{
    NSString *storyTitle = story[STORY_KEY_TITLE];
    self.featuredCellTitle.text = storyTitle;
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle), NSUnderlineColorAttributeName:[UIColor blackColor]};
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc] initWithString:storyTitle  attributes:underlineAttribute];
    self.labelTitleUnderline.attributedText = attrString;
}

-(void)setStoryText:(PFObject *)story{
    NSString *storyText;
    NSString *prolougeText = story[STORY_KEY_FIRST_SENTENCE];
    NSArray *text = story[STORY_KEY_SELECTED_TEXTS];
    
    NSMutableString *selectedStrings = [NSMutableString new];
    NSInteger sentenceNum = 5;
    for (int i=0; i < [text count]; i++) {
        if (i == sentenceNum) {
            break;
        }
        [selectedStrings appendString: [NSString stringWithFormat:@"\n\n%d %@", i, [text objectAtIndex:i]]];
    }
    
    storyText = [NSString stringWithFormat:@"%@ %@", prolougeText, selectedStrings];
    self.featuredStoryText.text = storyText ;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
