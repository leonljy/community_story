//
//  StandardTableViewCell.m
//  Story
//
//  Created by john kim on 10/6/15.
//  Copyright © 2015 Favorie&John. All rights reserved.
//

#import "StandardTableViewCell.h"

@interface StandardTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *standardTitle;
@property (weak, nonatomic) IBOutlet UILabel *standardDescription;
@property (weak, nonatomic) IBOutlet UILabel *currentUsersCount;
@property (weak, nonatomic) IBOutlet UILabel *currentSequenceCount;

@end


@implementation StandardTableViewCell
@synthesize standardTitle;
@synthesize standardDescription;
@synthesize currentUsersCount;
@synthesize currentSequenceCount;

- (void)awakeFromNib {
    // Initialization code
    
    standardDescription.lineBreakMode = NSLineBreakByWordWrapping;
    standardDescription.numberOfLines = 0;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setStandardStoryDatasToUI:(PFObject *)story{
    
    self.standardTitle.text = story[STORY_KEY_TITLE];
    self.standardDescription.text = story[STORY_KEY_DESCRIPTION];
    
    NSInteger currentSequence = [story[STORY_KEY_CURRENTSEQUENCE] integerValue];
    NSString *stringSequence = [NSString stringWithFormat:@"%ld", (long)currentSequence];
    self.currentSequenceCount.text = stringSequence;
    
    NSInteger writersCount = [story[STORY_KEY_WRITERS_COUNT] integerValue];
    NSString *writerCountString =[NSString stringWithFormat:@"%ld", (long)writersCount];
    self.currentUsersCount.text =writerCountString;
    
}


@end
