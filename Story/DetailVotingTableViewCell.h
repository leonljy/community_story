//
//  DetailVotingTableViewCell.h
//  Story
//
//  Created by Kwanghwi Kim on 2015. 10. 5..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFObject+Sentence.h"

@interface DetailVotingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (weak, nonatomic) IBOutlet UILabel *labelNewSentence;
@property (weak, nonatomic) IBOutlet UIButton *buttonUp;
@property (weak, nonatomic) IBOutlet UIButton *buttonDown;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottomMargin;
@property (weak, nonatomic) IBOutlet UIView *viewContentBackground;
@property (weak, nonatomic) IBOutlet UILabel *labelVoteCount;
@property (strong ,nonatomic) UIImageView *imageViewSentence;

-(void)setSentenceImageViewWithFrame:(CGRect)frame sentence:(PFObject *)sentence;
@end
