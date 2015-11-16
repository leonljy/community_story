//
//  ProfileContributeCell.h
//  Story
//
//  Created by Leonljy on 2015. 11. 3..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFObject+Story.h"

@interface ProfileContributeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelSentence;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewContent;
@property (weak, nonatomic) IBOutlet UITextView *textViewContribute;
@property (weak, nonatomic) IBOutlet UILabel *labelInfo;
-(void)setStoryInfoWithStory:(PFObject *)story;
@end
