//
//  ProfileUserCell.h
//  Story
//
//  Created by Leonljy on 2015. 10. 20..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileUserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelUsername;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogout;
@property (weak, nonatomic) IBOutlet UILabel *labelUserDescription;

@end
