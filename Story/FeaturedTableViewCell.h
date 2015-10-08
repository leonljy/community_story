//
//  FeaturedTableViewCell.h
//  Story
//
//  Created by john kim on 10/6/15.
//  Copyright © 2015 Favorie&John. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeaturedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *featuredCellTitle;
@property (weak, nonatomic) IBOutlet UILabel *featuredCellDescription;
@property (weak, nonatomic) IBOutlet UILabel *featuredStoryText;
@property (weak, nonatomic) IBOutlet UILabel *featuredName;
@property (weak, nonatomic) IBOutlet UILabel *currentUsersCount;
@property (weak, nonatomic) IBOutlet UILabel *currentSequenceCount;

@end
