//
//  DetailTitleTableViewCell.h
//  Story
//
//  Created by Kwanghwi Kim on 2015. 10. 5..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFObject+Story.h"
@interface DetailTitleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIButton *buttonBookmark;
@property (weak, nonatomic) IBOutlet UILabel *labelTimeClock;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPhoto;
@property (strong, nonatomic) PFObject *story;

-(void)setStoryPhoto;
@end
