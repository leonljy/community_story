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


@interface MainViewController ()

@property (strong, nonatomic) NSArray *storyArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
  /* Using NSPredicate. Checks if story isEnded and the sorts by writersCount. In case of tie further sort by sentence count and in case of tie futher sort by created time. */
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isEndedStory = NO"];
    PFQuery *query = [PFQuery queryWithClassName:@"Story" predicate:predicate];
    [query orderByDescending:@"writersCount"];
    [query addDescendingOrder:@"currentSequence"];
    [query addAscendingOrder:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            //            NSLog(@"Successfully retrieved %lu scores.", (unsigned long)objects.count);
            self.storyArray = objects;
            for(PFObject *story in self.storyArray){
                
             /*   NSLog(@"WC: %ld, CS: %ld, Created: %@", [story[@"writersCount"] integerValue], [story[@"currentSequence"] integerValue], story.createdAt); */
            }
            [self.tableView reloadData];
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
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
    
//    [self.navigationController pushViewController:detailStoryViewController animated:YES];
    
    DetailStoryTextViewController *detailStoryTextViewController = [DetailStoryTextViewController new];
    [detailStoryTextViewController setHidesBottomBarWhenPushed:YES];
    
    [self.navigationController pushViewController:detailStoryTextViewController animated:YES];
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
//    static NSString *StandardCellIdentifier = @"STANDARD_STORY_CELL";
 
    //TODO need to change resuable cell identifier if section is greater than 1
    PFObject *story = [self.storyArray objectAtIndex:indexPath.row];
    FeaturedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FeaturedCellIdentifier];
    
    if (cell == nil) {
        cell = [[FeaturedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FeaturedCellIdentifier];
    }
    
    
    cell.featuredCellTitle.text = story[@"title"];
    cell.featuredCellDescription.text = story[@"description"];
    cell.featuredStoryText.text = story[@"text"];
    cell.featuredName.text = story[@"ownerName"];
    
//    
//    PFUser *owner = story[@"owner"];
//    PFQuery *query = [PFUser query];
//    [query whereKey:@"objectId" equalTo:owner.objectId];
//    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
//        if(error){
//            
//        }else{
//            if(0<[objects count]){
//                PFUser *user = [objects firstObject];
//                cell.featuredName.text = user.username;
//            }else{
//                
//            }
//        }
//    }];

    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.tableView.frame.size.height - 20;
}

@end
