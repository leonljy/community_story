//
//  DetailStoryViewController.m
//  Story
//
//  Created by Kwanghwi Kim on 2015. 10. 5..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "DetailStoryViewController.h"
#import "DetailTitleTableViewCell.h"
#import "DetailAuthorTableViewCell.h"
#import "DetailTimeTableViewCell.h"
#import "DetailDescriptionTableViewCell.h"
#import "DetailContentsTableViewCell.h"
#import "DetailVotingTableViewCell.h"

@interface DetailStoryViewController () <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation DetailStoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.row) {
        return 44;
    } else if (1==indexPath.row){
        return 44;
    } else if (2==indexPath.row){
        return 44;
    } else if (3==indexPath.row){
        return 150;
    } else if (4==indexPath.row){
        return 150;
    } else {
        return 100;
    }
}


#pragma mark - UITableView Datasource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0==indexPath.row) {
        DetailTitleTableViewCell *cell = (DetailTitleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DETAIL_TITLE_CELL"];
        return cell;
    } else if (1==indexPath.row) {
        DetailAuthorTableViewCell *cell = (DetailAuthorTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DETAIL_AUTHOR_CELL"];
        return cell;
    } else if (2==indexPath.row) {
        DetailTimeTableViewCell *cell = (DetailTimeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DETAIL_TIME_CELL"];
        return cell;
    } else if (3==indexPath.row) {
        DetailDescriptionTableViewCell *cell = (DetailDescriptionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DETAIL_DESCRIPTION_CELL"];
        return cell;
    } else if (4==indexPath.row) {
        DetailContentsTableViewCell *cell = (DetailContentsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DETAIL_CONTENTS_CELL"];
        return cell;
    } else {
        DetailVotingTableViewCell *cell = (DetailVotingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DETAIL_VOTING_CELL"];
        return cell;
    }
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
