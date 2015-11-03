//
//  BookMarkViewController.m
//  Story
//
//  Created by john kim on 10/1/15.
//  Copyright © 2015 Favorie&John. All rights reserved.
//

#import "BookMarkViewController.h"
#import "PFObject+Story.h"
#import "StoryCollectionViewCell.h"
#import "DetailStoryTextViewController.h"
#import "ArchiveDetailViewController.h"

@interface BookMarkViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *stories;
@end

@implementation BookMarkViewController{
    NSMutableArray *bookmarkedIds;
    UIRefreshControl *refreshControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData:)
             forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    
    [self refreshData:nil];
}

-(void)refreshData:(id)sender{
    [PFObject storiesBookmarkedWithSuccessBlock:^(NSArray *objects) {
        self.stories = objects;
        [self.collectionView reloadData];
        [refreshControl endRefreshing];
    } failureBlock:^(NSError *error) {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
}


#pragma mark - UICollectoinView Delegates
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0f;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat heightCell = 250;
    return CGSizeMake(self.collectionView.frame.size.width, heightCell);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.stories count];
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PFObject *story = [self.stories objectAtIndex:indexPath.row];
    if([story[STORY_KEY_ISENDED_STORY] boolValue]){
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ArchiveDetailViewController *archivedDetailViewController = [storyboard instantiateViewControllerWithIdentifier:@"ArchiveDetailViewController"];
        archivedDetailViewController.story = story;
        [archivedDetailViewController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:archivedDetailViewController animated:YES];
    }else{
        DetailStoryTextViewController *detailStoryTextViewController = [DetailStoryTextViewController new];
        [detailStoryTextViewController setHidesBottomBarWhenPushed:YES];
        detailStoryTextViewController.story = story;
        
        [self.navigationController pushViewController:detailStoryTextViewController animated:YES];
    }
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    StoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_BOOKMARKED_STORY" forIndexPath:indexPath];
    PFObject *story = [self.stories objectAtIndex:indexPath.row];
    [cell setAchievedStoryDatasToUI:story];
    
    if([bookmarkedIds containsObject:story.objectId]){
        [cell.imageViewBookmark setImage:[UIImage imageNamed:@"imgMarkLine"]];
    }else{
        [cell.imageViewBookmark setImage:[UIImage imageNamed:@"imgMarkBold"]];
    }
    return cell;
}
@end
