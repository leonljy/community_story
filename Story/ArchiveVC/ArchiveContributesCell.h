//
//  ArchiveContributesCell.h
//  Story
//
//  Created by Leonljy on 2015. 11. 3..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArchiveContributesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelUserName;
-(void)setContents:(NSString *)userName;
@end
