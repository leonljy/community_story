//
//  ArchiveDetailViewController.h
//  Story
//
//  Created by Leonljy on 2015. 11. 3..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFObject+Story.h"

@interface ArchiveDetailViewController : UIViewController
@property (strong, nonatomic) PFObject *story;
@end
