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
#import "PFObject+Story.h"
#import "standardTableViewCell.h"


@interface MainViewController ()

@property (strong, nonatomic) NSArray *storyArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
  /* Using NSPredicate. Checks if story isEnded and the sorts by writersCount. In case of tie further sort by sentence count and in case of tie futher sort by created time. */
    [PFObject storiesPopularWithSuccessBlock:^(NSArray *objects) {
        self.storyArray = objects;
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
    NewStoryViewController *newStoryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MAIN"];
    
    
    [self.navigationController pushViewController:newStoryViewController animated:YES];
//    [self moveToDetailStory];
}

- (void)moveToDetailStory{
    UIStoryboard *detailStoryBoard = [UIStoryboard storyboardWithName:@"DetailStory" bundle:nil];
    DetailStoryViewController *detailStoryViewController = [detailStoryBoard instantiateViewControllerWithIdentifier:@"DETAIL_STORY"];
    
    [self.navigationController pushViewController:detailStoryViewController animated:YES];
}

//tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.storyArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *FeaturedCellIdentifier = @"FEATURED_STORY_CELL";
    static NSString *StandardCellIdentifier = @"STANDARD_STORY_CELL";
 
    //TODO need to change resuable cell identifier if section is greater than 1
    
    PFObject *story = [self.storyArray objectAtIndex:indexPath.row];
    
    if (indexPath.section == 0) {
      FeaturedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FeaturedCellIdentifier];

        if (cell == nil) {
            cell = [[FeaturedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FeaturedCellIdentifier];
        }
        
        cell.featuredCellTitle.text = story[STORY_KEY_TITLE];
        cell.featuredCellDescription.text = story[STORY_KEY_DESCRIPTION];
        cell.featuredStoryText.text = story[STORY_KEY_TEXT];
        cell.featuredName.text = story[STORY_KEY_OWNER_NAME];
        
        NSInteger currentSequece = [story[STORY_KEY_CURRENTSEQUENCE] integerValue];
        NSString *stringSequence = [NSString stringWithFormat:@"%ld", (long)currentSequece];
        cell.currentSequenceCount.text = stringSequence;
        
        NSInteger writersCount = [story[STORY_KEY_WRITERS_COUNT] integerValue];
        NSString *writersCountString = [NSString stringWithFormat:@"%ld", (long)writersCount];
        cell.currentUsersCount.text = writersCountString;
        
        return cell;
        

    } else {
      StandardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:StandardCellIdentifier];
       
        if (cell == nil) {
            cell = [[StandardTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StandardCellIdentifier];
        }
        
        cell.standardTitle.text = story[STORY_KEY_TITLE];
        cell.standardDescription.text = story[STORY_KEY_DESCRIPTION];
        
        NSInteger currentSequence = [story[STORY_KEY_CURRENTSEQUENCE] integerValue];
        NSString *stringSequence = [NSString stringWithFormat:@"%ld", (long)currentSequence];
        cell.currentSequenceCount.text = stringSequence;
       
        NSInteger writersCount = [story[STORY_KEY_WRITERS_COUNT] integerValue];
        NSString *writerCountString =[NSString stringWithFormat:@"%ld", (long)writersCount];
        cell.currentUsersCount.text =writerCountString;
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableView.frame.size.height - 20;
}

@end
