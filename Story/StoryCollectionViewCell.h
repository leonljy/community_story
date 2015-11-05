//
//  FeaturedStoryCell.h
//  Story
//
//  Created by Leonljy on 2015. 10. 19..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface StoryCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPhoto;
@property (weak, nonatomic) IBOutlet UILabel *labelUnderline;
@property (weak, nonatomic) IBOutlet UILabel *labelPopular;
@property (weak, nonatomic) IBOutlet UILabel *labelStoryText;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBookmark;


-(void)setStandardStoryDatasToUI:(PFObject *)story;
-(void)setFeaturedStoryDatasToUI:(PFObject *)story;
-(void)setAchievedStoryDatasToUI:(PFObject *)story;
@end
