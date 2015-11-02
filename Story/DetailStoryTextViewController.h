//
//  DetailStoryTextViewController.h
//  Story
//
//  Created by Kwanghwi Kim on 2015. 10. 6..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLKTextViewController.h"
#import "PFObject+Story.h"

@interface DetailStoryTextViewController : SLKTextViewController
@property (strong, nonatomic) PFObject *story;
@property (strong, nonatomic) UIImage *imageStory;
@end
