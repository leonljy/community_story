//
//  MainViewController.m
//  Story
//
//  Created by john kim on 10/1/15.
//  Copyright © 2015 Favorie&John. All rights reserved.
//

#import "MainViewController.h"
#import <Parse/Parse.h>
#import "DetailStoryTextViewController.h"
#import "PFObject+Story.h"
#import "NewStoryNavigationController.h"
#import "StoryCollectionViewCell.h"

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSArray *storyArray;
@property (strong, nonatomic) NSMutableArray *populars;
@property (strong, nonatomic) NSMutableArray *nonPopulars;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

typedef enum {
    SECTION_POPULAR_STORY=0,
    SECTION_NON_POPULAR_STORY
}SectionStory;

@implementation MainViewController{
    UIRefreshControl *refreshControl;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
  /* Using NSPredicate. Checks if story isEnded and the sorts by writersCount. In case of tie further sort by sentence count and in case of tie futher sort by created time. */
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData:)
             forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    [self refreshData:nil];
}

-(void)refreshData:(id)sender{
    [PFObject storiesPopularWithSuccessBlock:^(NSArray *objects) {
        self.populars = [NSMutableArray array];
        self.nonPopulars = [NSMutableArray array];
        if(5<[objects count]){
            for(NSInteger index=0;index < [objects count];index++){
                PFObject *story = [objects objectAtIndex:index];
                if(5>index){
                    [self.populars addObject:story];
                }else{
                    [self.nonPopulars addObject:story];
                }
            }
        }else{
            self.populars = [NSMutableArray arrayWithArray:objects];
        }
        [self.collectionView reloadData];
        [refreshControl endRefreshing];
    } failureBlock:^(NSError *error) {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleNewStory:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    NewStoryNavigationController *newStoryNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"NewStoryNavigationController"];
    [self presentViewController:newStoryNavigationController animated:YES completion:^{
    }];
}

- (void)moveToDetailStory:(PFObject *)story{
    UIStoryboard *detailStoryBoard = [UIStoryboard storyboardWithName:@"DetailStory" bundle:nil];
//    DetailStoryViewController *detailStoryViewController = [detailStoryBoard instantiateViewControllerWithIdentifier:@"DETAIL_STORY"];
//    [self.navigationController pushViewController:detailStoryViewController animated:YES];
    
    DetailStoryTextViewController *detailStoryTextViewController = [DetailStoryTextViewController new];
    [detailStoryTextViewController setHidesBottomBarWhenPushed:YES];
    detailStoryTextViewController.story = story;
    
    [self.navigationController pushViewController:detailStoryTextViewController animated:YES];
}


#pragma mark - UICOllectionView Delegates
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    switch (section) {
        case SECTION_POPULAR_STORY:
            return [self.populars count];
            break;
        case SECTION_NON_POPULAR_STORY:
            return [self.nonPopulars count];
            break;
            
        default:
            return 0;
            break;
    }
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10.0f;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    switch (section) {
        case SECTION_POPULAR_STORY:
            return UIEdgeInsetsMake(0, 0, 10, 0);
            break;
        case SECTION_NON_POPULAR_STORY:
            return UIEdgeInsetsZero;
            break;
            
        default:
            return UIEdgeInsetsZero;
            break;
    }
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize sizeCell;
    CGFloat heightStatusBar = 20.0;
    CGFloat heightNavigationBar = 44.0;
    CGFloat heightTabBar = 44.0;
    CGFloat heightSmallCell = 240;
    CGFloat heightBigCell = collectionView.frame.size.height -  heightStatusBar - heightTabBar - heightNavigationBar;
    switch (indexPath.section) {
        case SECTION_POPULAR_STORY:
            sizeCell = CGSizeMake(collectionView.frame.size.width, heightBigCell);
            break;
        case SECTION_NON_POPULAR_STORY:
            sizeCell = CGSizeMake(collectionView.frame.size.width, heightSmallCell);
            break;
        default:
            sizeCell = CGSizeZero;
            break;
    }
    return sizeCell;
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *FeaturedCellIdentifier = @"CELL_FEATURED_STORY";
    static NSString *StandardCellIdentifier = @"CELL_STANDARD_STORY";
    
    
    if (indexPath.section == SECTION_POPULAR_STORY) {
        
        PFObject *popularStory = [self.populars objectAtIndex:indexPath.row];
        
        StoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FeaturedCellIdentifier forIndexPath:indexPath];
        
        [cell setFeaturedStoryDatasToUI:popularStory];
        
        return cell;
        
    } else {
        
        PFObject *nonpopularStory = [self.nonPopulars objectAtIndex:indexPath.row];
        
        StoryCollectionViewCell *cells = [collectionView dequeueReusableCellWithReuseIdentifier:StandardCellIdentifier forIndexPath:indexPath];
        
        [cells setStandardStoryDatasToUI:nonpopularStory];
        return cells;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PFObject *story;
    switch (indexPath.section) {
        case SECTION_POPULAR_STORY:
            story = [self.populars objectAtIndex:indexPath.row];
            break;
        case SECTION_NON_POPULAR_STORY:
            story = [self.nonPopulars objectAtIndex:indexPath.row];
            break;
            
        default:
            break;
    }
    [self moveToDetailStory:story];
}
//tableView

# pragma mark - UITableView data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case SECTION_POPULAR_STORY:
            return [self.populars count];
            break;
        case SECTION_NON_POPULAR_STORY:
            return [self.nonPopulars count];
            break;
    
        default:
            return 0;
            break;
    }

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *FeaturedCellIdentifier = @"FEATURED_STORY_CELL";
    static NSString *StandardCellIdentifier = @"STANDARD_STORY_CELL";

 
    //TODO need to figure how to start the standard cells from a later indexpath in Parse
    

    
    if (indexPath.section == SECTION_POPULAR_STORY) {

        PFObject *popularStory = [self.populars objectAtIndex:indexPath.row];

        FeaturedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FeaturedCellIdentifier];

        if (cell == nil) {
            cell = [[FeaturedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FeaturedCellIdentifier];
        }
        
        [cell setStoryDatasToUI:popularStory];
        
        return cell;

    } else {
      
        PFObject *nonpopularStory = [self.nonPopulars objectAtIndex:indexPath.row];
 
        StandardTableViewCell *cells = [tableView dequeueReusableCellWithIdentifier:StandardCellIdentifier];
       
        if (cells == nil) {
            cells = [[StandardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StandardCellIdentifier];
        }
        
        [cells setStandardStoryDatasToUI:nonpopularStory];
               
        return cells;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PFObject *story;
    switch (indexPath.section) {
        case SECTION_POPULAR_STORY:
            story = [self.populars objectAtIndex:indexPath.row];
            break;
        case SECTION_NON_POPULAR_STORY:
            story = [self.nonPopulars objectAtIndex:indexPath.row];
            break;
            
        default:
            break;
    }
    [self moveToDetailStory:story];

}

#pragma mark - UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightStatusBar = 20.0;
//    CGFloat heightNavigationBar = 44.0;
    CGFloat heightTabBar = 44.0;
    if (indexPath.section == 0) {
<<<<<<< HEAD
    return self.tableView.frame.size.height - 44;
=======
    return self.tableView.frame.size.height - heightTabBar - heightStatusBar;
>>>>>>> 867772b97d9d978897c905777d6f71d989bc55a9
    } else {
        return 150;
    }
}
 
*/

@end
