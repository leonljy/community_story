//
//  ArchiveViewController.m
//  Story
//
//  Created by john kim on 10/1/15.
//  Copyright © 2015 Favorie&John. All rights reserved.
//

#import "ArchiveViewController.h"
#import "FeaturedStoryCell.h"
#import "PFObject+Story.h"
#import "PFUser+User.h"

@interface ArchiveViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *stories;
@end

@implementation ArchiveViewController{
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
    [self reloadBookmarkedStories];
    [self reloadAchievedStories];
}
-(void)reloadBookmarkedStories{
    PFUser *user = [PFUser currentUser];
    bookmarkedIds = [NSMutableArray array];
    for(PFObject *story in user[USER_KEY_BOOKMARKED_STORIES]){
        [bookmarkedIds addObject:story.objectId];
    }
}

-(void)reloadAchievedStories{
    [PFObject storiesArchievedWithSuccessBlock:^(NSArray *objects) {
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
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FeaturedStoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_ACHIEVED_STORY" forIndexPath:indexPath];
    PFObject *story = [self.stories objectAtIndex:indexPath.row];
    [cell setAchievedStoryDatasToUI:story];
    
    if([bookmarkedIds containsObject:story.objectId]){
        [cell.imageViewBookmark setImage:[UIImage imageNamed:@"icon_30_color"]];
    }else{
        [cell.imageViewBookmark setImage:[UIImage imageNamed:@"icon_30_black"]];
    }
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
