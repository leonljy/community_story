//
//  StandardTableViewCell.h
//  Story
//
//  Created by john kim on 10/6/15.
//  Copyright © 2015 Favorie&John. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StandardTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *standardTitle;
@property (weak, nonatomic) IBOutlet UILabel *standardDescription;
@property (weak, nonatomic) IBOutlet UILabel *currentUsersCount;
@property (weak, nonatomic) IBOutlet UILabel *currentSequenceCount;

@end
