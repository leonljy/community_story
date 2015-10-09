//
//  MainViewController.m
//  Story
//
//  Created by john kim on 10/1/15.
//  Copyright © 2015 Favorie&John. All rights reserved.
//

#import "MainViewController.h"
#import "NewStoryViewController.h"
#import <Parse/Parse.h>
#import "FeaturedTableViewCell.h"
#import "DetailStoryViewController.h"
#import "DetailStoryTextViewController.h"
#import "PFObject+Story.h"
#import "standardTableViewCell.h"


@interface MainViewController ()

@property (strong, nonatomic) NSArray *storyArray;
@property (strong, nonatomic) NSMutableArray *populars;
@property (strong, nonatomic) NSMutableArray *nonPopulars;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

typedef enum {
    SECTION_POPULAR_STORY=0,
    SECTION_NON_POPULAR_STORY
}SectionStory;

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
  /* Using NSPredicate. Checks if story isEnded and the sorts by writersCount. In case of tie further sort by sentence count and in case of tie futher sort by created time. */
    
    [PFObject storiesPopularWithSuccessBlock:^(NSArray *objects) {
//        self.storyArray = objects;
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
        
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)handleNewStory:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
    NewStoryViewController *newStoryViewController = [storyboard instantiateViewControllerWithIdentifier:@"NewStoryViewController"];
    
    [newStoryViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:newStoryViewController animated:YES];
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

//tableView

# pragma mark - UITableView data source
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
        
<<<<<<< HEAD
        cell.featuredCellTitle.text = popularStory[STORY_KEY_TITLE];
        cell.featuredCellDescription.text = popularStory[STORY_KEY_DESCRIPTION];
        NSString *storyText;
        NSString *prolougeText = popularStory[STORY_KEY_FIRST_SENTENCE];
  
=======
        cell.featuredCellTitle.text = story[STORY_KEY_TITLE];
        cell.featuredCellDescription.text = story[STORY_KEY_DESCRIPTION];
//        cell.featuredStoryText.text = story[STORY_KEY_TEXT];
        cell.featuredName.text = story[STORY_KEY_OWNER_NAME];
>>>>>>> 7eac7cfb06073860332cb8853f69733ea466e154
        
        cell.featuredStoryText.text = storyText;
        cell.featuredName.text = popularStory[STORY_KEY_OWNER_NAME];
        
        NSInteger currentSequece = [popularStory[STORY_KEY_CURRENTSEQUENCE] integerValue];
        NSString *stringSequence = [NSString stringWithFormat:@"%ld", (long)currentSequece];
        cell.currentSequenceCount.text = stringSequence;
        
        NSInteger writersCount = [popularStory[STORY_KEY_WRITERS_COUNT] integerValue];
        NSString *writersCountString = [NSString stringWithFormat:@"%ld", (long)writersCount];
        cell.currentUsersCount.text = writersCountString;
        
        return cell;

    } else {
      
        PFObject *nonpopularStory = [self.nonPopulars objectAtIndex:indexPath.row];
 
        StandardTableViewCell *cells = [tableView dequeueReusableCellWithIdentifier:StandardCellIdentifier];
       
        if (cells == nil) {
            cells = [[StandardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StandardCellIdentifier];
        }
        
        cells.standardTitle.text = nonpopularStory[STORY_KEY_TITLE];
        cells.standardDescription.text = nonpopularStory[STORY_KEY_DESCRIPTION];
        
        NSInteger currentSequence = [nonpopularStory[STORY_KEY_CURRENTSEQUENCE] integerValue];
        NSString *stringSequence = [NSString stringWithFormat:@"%ld", (long)currentSequence];
        cells.currentSequenceCount.text = stringSequence;
       
        NSInteger writersCount = [nonpopularStory[STORY_KEY_WRITERS_COUNT] integerValue];
        NSString *writerCountString =[NSString stringWithFormat:@"%ld", (long)writersCount];
        cells.currentUsersCount.text =writerCountString;
        
        return cells;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PFObject *story = [self.storyArray objectAtIndex:indexPath.row];
    [self moveToDetailStory:story];
}

#pragma mark - UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
    return self.tableView.frame.size.height - 20;
    } else {
        return 150;
    }
}

@end
