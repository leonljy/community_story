//
//  ArchiveTitleCell.h
//  Story
//
//  Created by Leonljy on 2015. 11. 3..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFObject+Story.h"

@interface ArchiveTitleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewImage;
@property (weak, nonatomic) IBOutlet UIButton *buttonBookmark;

-(void)setContents:(PFObject *)story;
@end
