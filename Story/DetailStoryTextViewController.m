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

#import "PFUser+User.h"

@interface DetailStoryTextViewController ()
@property (strong, nonatomic) NSMutableArray *sentences;
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
    
    
    [PFObject currentSentencesForStory:self.story successBlock:^(NSArray *objects) {
        self.sentences = [NSMutableArray arrayWithArray:objects];
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.sentences.count > 0) {
        return 2;
    } else {
        return 1;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (0 == section) {
        return 5;
    } else {
        return self.sentences.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld %ld", indexPath.section, indexPath.row);
    if (0 == indexPath.section) {
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
        } else {
            DetailContentsTableViewCell *cell = (DetailContentsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DETAIL_CONTENTS_CELL"];
            if (!cell) {
                [tableView registerNib:[UINib nibWithNibName:@"DetailContentsTableViewCell" bundle:nil] forCellReuseIdentifier:@"DETAIL_CONTENTS_CELL"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"DETAIL_CONTENTS_CELL"];
            }
            return cell;
        }
    } else {
        DetailVotingTableViewCell *cell = (DetailVotingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DETAIL_VOTING_CELL"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"DetailVotingTableViewCell" bundle:nil] forCellReuseIdentifier:@"DETAIL_VOTING_CELL"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"DETAIL_VOTING_CELL"];
        }
        PFObject *sentence = [self.sentences objectAtIndex:indexPath.row];
        cell.labelNewSentence.text = sentence[SENTENCE_KEY_TEXT];
        NSNumber *voteCount = sentence[SENTENCE_KEY_VOTE_POINT];
        cell.labelVoteCount.text = voteCount.stringValue;
        return cell;
    }
}


#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            return 44;
        } else if (1==indexPath.row){
            return 44;
        } else if (2==indexPath.row){
            return 44;
        } else if (3==indexPath.row){
            return 150;
        } else {
            return 150;
        }
    } else {
        return 100;
    }
}

#pragma mark - Overriden Methods

- (BOOL)ignoreTextInputbarAdjustment{
    return [super ignoreTextInputbarAdjustment];
}

- (BOOL)forceTextInputbarAdjustmentForResponder:(UIResponder *)responder{
    // On iOS 9, returning YES helps keeping the input view visible when the keyboard if presented from another app when using multi-tasking on iPad.
    return SLK_IS_IPAD;
}

- (void)didChangeKeyboardStatus:(SLKKeyboardStatus)status{
    // Notifies the view controller that the keyboard changed status.
}

- (void)textWillUpdate{
    // Notifies the view controller that the text will update.
    
    [super textWillUpdate];
}

- (void)textDidUpdate:(BOOL)animated{
    // Notifies the view controller that the text did update.
    
    [super textDidUpdate:animated];
}

- (void)didPressLeftButton:(id)sender{
    // Notifies the view controller when the left button's action has been triggered, manually.
    
    [super didPressLeftButton:sender];
}

- (void)didPressRightButton:(id)sender{
    // Notifies the view controller when the right button's action has been triggered, manually or by using the keyboard return key.
    
    // This little trick validates any pending auto-correction or auto-spelling just after hitting the 'Send' button
    [self.textView refreshFirstResponder];
    
    PFObject *sentence = [PFObject objectWithClassName:SENTENCE_CLASSNAME];
    sentence[SENTENCE_KEY_STORY] = self.story;
    sentence[SENTENCE_KEY_END_SENTENCE] = [NSNumber numberWithBool:NO];
    sentence[SENTENCE_KEY_TEXT] = self.textView.text;
    
    [sentence saveNewSentenceWithSuccessBlock:^(id responseObject) {
        
    } failureBlock:^(NSError *error) {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.sentences.count inSection:1];
    UITableViewRowAnimation rowAnimation = UITableViewRowAnimationBottom;
    UITableViewScrollPosition scrollPosition = UITableViewScrollPositionBottom;
    [self.tableView beginUpdates];
    if (0==self.sentences.count) {
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:rowAnimation];
    }
    [self.sentences addObject:sentence];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:rowAnimation];
    [self.tableView endUpdates];
    
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:YES];
    
    // Fixes the cell from blinking (because of the transform, when using translucent cells)
    // See https://github.com/slackhq/SlackTextViewController/issues/94#issuecomment-69929927
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [super didPressRightButton:sender];
}

- (void)didPressArrowKey:(id)sender{
    [super didPressArrowKey:sender];
    
//    UIKeyCommand *keyCommand = (UIKeyCommand *)sender;
//    
//    if ([keyCommand.input isEqualToString:UIKeyInputUpArrow]) {
//        [self editLastMessage:nil];
//    }
}

- (NSString *)keyForTextCaching{
    return [[NSBundle mainBundle] bundleIdentifier];
}

- (void)didPasteMediaContent:(NSDictionary *)userInfo{
    // Notifies the view controller when the user has pasted a media (image, video, etc) inside of the text view.
    [super didPasteMediaContent:userInfo];
    
    SLKPastableMediaType mediaType = [userInfo[SLKTextViewPastedItemMediaType] integerValue];
    NSString *contentType = userInfo[SLKTextViewPastedItemContentType];
    id data = userInfo[SLKTextViewPastedItemData];
    
    NSLog(@"%s : %@ (type = %ld) | data : %@",__FUNCTION__, contentType, (unsigned long)mediaType, data);
}

- (void)willRequestUndo
{
    // Notifies the view controller when a user did shake the device to undo the typed text
    
    [super willRequestUndo];
}

- (void)didCommitTextEditing:(id)sender{
    // Notifies the view controller when tapped on the right "Accept" button for commiting the edited text
//    
//    Message *message = [Message new];
//    message.username = [LoremIpsum name];
//    message.text = [self.textView.text copy];
//    
//    [self.messages removeObjectAtIndex:0];
//    [self.messages insertObject:message atIndex:0];
//    [self.tableView reloadData];
    
    [super didCommitTextEditing:sender];
}

- (void)didCancelTextEditing:(id)sender{
    // Notifies the view controller when tapped on the left "Cancel" button
    
    [super didCancelTextEditing:sender];
}

- (BOOL)canPressRightButton{
    return [super canPressRightButton];
}

- (BOOL)canShowTypingIndicator{
#if DEBUG_CUSTOM_TYPING_INDICATOR
    return YES;
#else
    return [super canShowTypingIndicator];
#endif
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
