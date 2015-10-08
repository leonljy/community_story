//
//  DetailStoryTextViewController.m
//  Story
//
//  Created by Kwanghwi Kim on 2015. 10. 6..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "DetailStoryTextViewController.h"
#import "DetailTitleTableViewCell.h"
#import "DetailAuthorTableViewCell.h"
#import "DetailTimeTableViewCell.h"
#import "DetailDescriptionTableViewCell.h"
#import "DetailContentsTableViewCell.h"
#import "DetailVotingTableViewCell.h"


@interface DetailStoryTextViewController ()

@end

@implementation DetailStoryTextViewController

- (id)init {
    self = [super initWithTableViewStyle:UITableViewStylePlain];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

+ (UITableViewStyle)tableViewStyleForCoder:(NSCoder *)decoder{
    return UITableViewStylePlain;
}

- (void)commonInit{
    [[NSNotificationCenter defaultCenter] addObserver:self.tableView selector:@selector(reloadData) name:UIContentSizeCategoryDidChangeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputbarDidMove:) name:SLKTextInputbarDidMoveNotification object:nil];
    
    // Register a SLKTextView subclass, if you need any special appearance and/or behavior customisation.
//    [self registerClassForTextView:[MessageTextView class]];
    
#if DEBUG_CUSTOM_TYPING_INDICATOR
    // Register a UIView subclass, conforming to SLKTypingIndicatorProtocol, to use a custom typing indicator view.
//    [self registerClassForTypingIndicatorView:[TypingIndicatorView class]];
#endif
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inverted = NO;
    self.bounces = YES;
    self.shakeToClearEnabled = YES;
    self.keyboardPanningEnabled = YES;
    self.shouldScrollToBottomAfterKeyboardShows = NO;

    self.textInputbar.autoHideRightButton = YES;
    self.textInputbar.maxCharCount = 140;
    self.textInputbar.counterStyle = SLKCounterStyleSplit;
    self.textInputbar.counterPosition = SLKCounterPositionTop;
    
    
    [self.textInputbar.editorTitle setTextColor:[UIColor darkGrayColor]];
    [self.textInputbar.editorLeftButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
    [self.textInputbar.editorRightButton setTintColor:[UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]];
    
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (0==indexPath.row) {
        DetailTitleTableViewCell *cell = (DetailTitleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DETAIL_TITLE_CELL"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"DetailTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"DETAIL_TITLE_CELL"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"DETAIL_TITLE_CELL"];
        }
        return cell;
    } else if (1==indexPath.row) {
        DetailAuthorTableViewCell *cell = (DetailAuthorTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DETAIL_AUTHOR_CELL"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"DetailAuthorTableViewCell" bundle:nil] forCellReuseIdentifier:@"DETAIL_AUTHOR_CELL"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"DETAIL_AUTHOR_CELL"];
        }
        return cell;
    } else if (2==indexPath.row) {
        DetailTimeTableViewCell *cell = (DetailTimeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DETAIL_TIME_CELL"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"DetailTimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"DETAIL_TIME_CELL"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"DETAIL_TIME_CELL"];
        }
        return cell;
    } else if (3==indexPath.row) {
        DetailDescriptionTableViewCell *cell = (DetailDescriptionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DETAIL_DESCRIPTION_CELL"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"DetailDescriptionTableViewCell" bundle:nil] forCellReuseIdentifier:@"DETAIL_DESCRIPTION_CELL"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"DETAIL_DESCRIPTION_CELL"];
        }
        return cell;
    } else if (4==indexPath.row) {
        DetailContentsTableViewCell *cell = (DetailContentsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DETAIL_CONTENTS_CELL"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"DetailContentsTableViewCell" bundle:nil] forCellReuseIdentifier:@"DETAIL_CONTENTS_CELL"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"DETAIL_CONTENTS_CELL"];
        }
        return cell;
    } else {
        DetailVotingTableViewCell *cell = (DetailVotingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DETAIL_VOTING_CELL"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"DetailVotingTableViewCell" bundle:nil] forCellReuseIdentifier:@"DETAIL_VOTING_CELL"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"DETAIL_VOTING_CELL"];
        }
        return cell;
    }
}





#pragma mark - UITableViewDelegate Methods

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

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Since SLKTextViewController uses UIScrollViewDelegate to update a few things, it is important that if you ovveride this method, to call super.
    [super scrollViewDidScroll:scrollView];
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
