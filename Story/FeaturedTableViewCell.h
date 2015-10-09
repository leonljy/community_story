//
//  FeaturedTableViewCell.h
//  Story
//
//  Created by john kim on 10/6/15.
//  Copyright © 2015 Favorie&John. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFObject+Story.h"
@interface FeaturedTableViewCell : UITableViewCell
-(void)setStoryDatasToUI:(PFObject *)story;
@end
