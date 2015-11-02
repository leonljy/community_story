//
//  DetailContentsTableViewCell.h
//  Story
//
//  Created by Kwanghwi Kim on 2015. 10. 5..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFObject+Sentence.h"

@interface DetailContentsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelContents;
//@property (weak, nonatomic) IBOutlet UIView *viewBottomBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;
@property (strong ,nonatomic) UIImageView *imageViewSentence;

-(void)setSentenceImageViewWithFrame:(CGRect)frame sentence:(PFObject *)sentence;
@end
