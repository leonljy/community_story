//
//  ArchiveStoryCell.h
//  Story
//
//  Created by Leonljy on 2015. 11. 3..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFObject+Sentence.h"
@interface ArchiveStoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelStory;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewStory;


-(void)setContents:(PFObject *)sentence;
-(void)setPrologue:(NSString *)prologue;
@end
