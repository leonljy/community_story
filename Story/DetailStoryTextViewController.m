//
//  DetailStoryTextViewController.m
//  Story
//
//  Created by Kwanghwi Kim on 2015. 10. 6..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "DetailStoryTextViewController.h"
#import "DetailTitleTableViewCell.h"
#import "DetailDescriptionTableViewCell.h"
#import "DetailContentsTableViewCell.h"
#import "DetailVotingTableViewCell.h"
#import "DetailFirstSentenceTableViewCell.h"
#import "PFUser+User.h"
#import "PFObject+Sentence.h"
#import "NSDate+Tool.h"
#import <Photos/Photos.h>
#import "UIColor+Tool.h"
#import "NovelistConstants.h"


@interface DetailStoryTextViewController () <UIAlertViewDelegate>
@property (strong, nonatomic) NSArray *sentencesToShow;
@property (strong, nonatomic) NSMutableArray *selectedSentences;
@property (strong, nonatomic) NSTimer *timerDeadline;
@property UILabel *labelTimer;
@property (strong, nonatomic) UIButton *buttonEnd;
@property BOOL isEndSentence;
@property (nonatomic, strong) UIWindow *pipWindow;
@end

typedef enum {
    CELL_TITLE = 0,
    CELL_DESCRIPTION,
    CELL_FIRST_SENTENCE
}cellDetail;

typedef enum{
    SECTION_STORY_DETAIL=0,
    SECTION_STORY_CONTENT,
    SECTION_VOTING
}sectionDetail;

@implementation DetailStoryTextViewController{
    UIImagePickerController *imagePickerViewController;
    UIImageView *imageViewComment;
    BOOL callImagePicker;
    CGFloat marginStoryLeftRight;
    CGFloat marginTopBottom;
    CGFloat heightUserName;
    CGFloat marginSentence;
    CGFloat widthViewVote;
    NSInteger fontSizeStory;
    CGFloat heightImage;
    NSMutableDictionary *sentenceHeights;
    NSMutableDictionary *storyHeights;
}

static NSString *KEY_FIRST_END = @"isFirstEnd";

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
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputbarDidMove:) name:SLKTextInputbarDid Notification object:nil];
    
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
    [self setTitle:self.story[STORY_KEY_TITLE]];
    [self initializeConstants];
    [self initializeProperties];
    [self initializeInputBar];
    [self reloadSentences];
    [self addRightButton];
    [self initializeTimer];
}

-(void)addRightButton{
    UIBarButtonItem *buttonRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reloadSentences)];
    [self.navigationItem setRightBarButtonItem:buttonRefresh];
}

- (void)viewWillDisappear:(BOOL)animated{
    if(callImagePicker){
        [_pipWindow setHidden:YES];
    }else{
        [self hidePIPWindow];
    }
}


-(void)initializeConstants{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.isEndSentence = NO;
    callImagePicker = NO;
    
    marginStoryLeftRight = [NovelistConstants getMarginLeftRight];
    marginTopBottom = [NovelistConstants getMarginTopBottom];
    fontSizeStory = [NovelistConstants getTextFontSize];
    heightUserName = [NovelistConstants getLabelSingleHeight];
    marginSentence = [NovelistConstants getSpaceBetweenElements];
    widthViewVote = 53.0f;
    heightImage = [NovelistConstants getImageHeight];
}



-(void)initializeTimer{
    NSTimeInterval oneSec = 1;
    self.timerDeadline = [NSTimer scheduledTimerWithTimeInterval:oneSec target:self selector:@selector(handleTimerDeadline:) userInfo:nil repeats:YES];
    [self.timerDeadline fire];
}

-(void)handleTimerDeadline:(id)sender{
    NSDate *deadline = self.story[STORY_KEY_DEADLINE];
    NSTimeInterval difference = [deadline timeIntervalSinceNow];
    if(0 <= difference){
        [self.labelTimer setText:[deadline remainTime]];
    }else{
        [self.labelTimer setText:@"Now processing please wait"];
    }
}
-(void)reloadSentences{
    [PFObject sentencesForDetailStory:self.story successBlock:^(NSArray *objects) {
        NSMutableArray *sentences = [NSMutableArray array];
        self.selectedSentences = [NSMutableArray array];
        for(PFObject *sentence in objects){
            if([self.story[STORY_KEY_CURRENTSEQUENCE] integerValue] > [sentence[SENTENCE_KEY_SEQUENCE] integerValue]){
                [self.selectedSentences addObject:sentence];
            }else{
                [sentences addObject:sentence];
            }
        }
        
        NSSortDescriptor *sequenceDescr = [[NSSortDescriptor alloc] initWithKey:SENTENCE_KEY_VOTE_POINT ascending:NO];
        NSSortDescriptor *createdAtDescr = [[NSSortDescriptor alloc] initWithKey:SENTENCE_KEY_CREATED_AT ascending:YES];
        NSArray *sortDescriptors = @[sequenceDescr, createdAtDescr];
        self.sentencesToShow = [NSArray arrayWithArray:[sentences sortedArrayUsingDescriptors:sortDescriptors]];
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

-(void)initializeProperties{
    self.inverted = NO;
    self.bounces = YES;
    self.shakeToClearEnabled = YES;
    self.keyboardPanningEnabled = YES;
    self.shouldScrollToBottomAfterKeyboardShows = NO;
    [self.leftButton setImage:[UIImage imageNamed:@"buttonCamera"] forState:UIControlStateNormal];
    [self.leftButton setTintColor:[UIColor grayColor]];
    [self initializeRightButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textInputbarDidMove:) name:SLKTextInputbarDidMoveNotification object:nil];
}

-(void)initializeRightButton{
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightButton setTitle:@"SEND" forState:UIControlStateNormal];
    [self.rightButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"buttonSendBlue"] forState:UIControlStateNormal];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"buttonSendGrey"] forState:UIControlStateDisabled];
//    [self.rightButton setBackgroundColor:[UIColor colorBlueBrand]];
//    self.rightButton.layer.masksToBounds = YES;
//    self.rightButton.layer.cornerRadius = 5.0;
}

-(void)initializeInputBar{
    self.textInputbar.autoHideRightButton = NO;
    self.textInputbar.maxCharCount = 140;
    self.textInputbar.counterStyle = SLKCounterStyleSplit;
    self.textInputbar.counterPosition = SLKCounterPositionTop;
    UIEdgeInsets originInsets = self.textInputbar.textView.textContainerInset;
    [self.textInputbar.textView setTextContainerInset:UIEdgeInsetsMake(originInsets.top, originInsets.left+40, originInsets.bottom, originInsets.right)];
    [self initializeEndButton];
}

-(void)initializeEndButton{
    _buttonEnd = [[UIButton alloc] initWithFrame:CGRectMake(5, 0, 40, 35)];
    [_buttonEnd.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [_buttonEnd setTitle:@"END |" forState:UIControlStateNormal];
    [_buttonEnd addTarget:self action:@selector(handleEnd:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonEnd setBackgroundColor:[UIColor clearColor]];
    [_buttonEnd setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_buttonEnd setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [self.textInputbar.textView addSubview:_buttonEnd];
}

-(void)handleEnd:(id)sender{
    NSLog(@"HandleEnd");
    _buttonEnd.selected = !_buttonEnd.selected;
    
    if(_buttonEnd.selected){
        [self.rightButton setTitle:NSLocalizedString(@"DetailStoryTextVC.Button.Finish", @"Finish") forState:UIControlStateNormal];
        self.isEndSentence = YES;
        if(![[NSUserDefaults standardUserDefaults] boolForKey:KEY_FIRST_END]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"DetailStoryTextVC.AlertView.End.Title", @"Title") message:NSLocalizedString(@"DetailStoryTextVC.AlertView.End.Message", @"Message") delegate:self cancelButtonTitle:NSLocalizedString(@"DetailStoryTextVC.AlertView.End.CancelButton", @"Cancel") otherButtonTitles:nil, nil];
            [alertView show];
        }
    }else{
        [self.rightButton setTitle:NSLocalizedString(@"DetailStoryTextVC.Button.Send", @"Send") forState:UIControlStateNormal];
        self.isEndSentence = YES;
    }
}

-(void)alertViewCancel:(UIAlertView *)alertView{
    NSLog(@"AlertView Cancel");
//    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KEY_FIRST_END];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.sentencesToShow.count > 0) {
        return 3;
    } else {
        return 2;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (SECTION_STORY_DETAIL == section) {
        return 3;
    } else if(SECTION_STORY_CONTENT ==  section){
        storyHeights = [NSMutableDictionary dictionary];
        return self.selectedSentences.count;
    }else{
        sentenceHeights = [NSMutableDictionary dictionary];
        return self.sentencesToShow.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (SECTION_STORY_DETAIL == indexPath.section) {
        if (CELL_TITLE==indexPath.row) {
            DetailTitleTableViewCell *cell = (DetailTitleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DETAIL_TITLE_CELL"];
            if (!cell) {
                [tableView registerNib:[UINib nibWithNibName:@"DetailTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"DETAIL_TITLE_CELL"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"DETAIL_TITLE_CELL"];
            }
            cell.labelTitle.text = self.story[STORY_KEY_TITLE];
            cell.story = self.story;
            PFUser *user = [PFUser currentUser];
            NSArray *bookmarkedStory = user[USER_KEY_BOOKMARKED_STORIES];
            [cell.buttonBookmark setSelected:[bookmarkedStory containsObject:self.story]];
            [cell setStoryPhoto];
            self.labelTimer = cell.labelTimeClock;
            [self handleTimerDeadline:nil];
            return cell;
        } else if (CELL_DESCRIPTION==indexPath.row) {
            DetailDescriptionTableViewCell *cell = (DetailDescriptionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DETAIL_DESCRIPTION_CELL"];
            if (!cell) {
                [tableView registerNib:[UINib nibWithNibName:@"DetailDescriptionTableViewCell" bundle:nil] forCellReuseIdentifier:@"DETAIL_DESCRIPTION_CELL"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"DETAIL_DESCRIPTION_CELL"];
            }
            cell.labelDescription.text = self.story[STORY_KEY_DESCRIPTION];
            return cell;
        } else{
            DetailFirstSentenceTableViewCell *cell = (DetailFirstSentenceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DETAIL_FIRST_SENTENCE_CELL"];
            if (!cell) {
                [tableView registerNib:[UINib nibWithNibName:@"DetailFirstSentenceTableViewCell" bundle:nil] forCellReuseIdentifier:@"DETAIL_FIRST_SENTENCE_CELL"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"DETAIL_FIRST_SENTENCE_CELL"];
            }
            cell.labelContents.text = self.story[STORY_KEY_FIRST_SENTENCE];
            return cell;
        }
    } else if (SECTION_STORY_CONTENT == indexPath.section){
        DetailContentsTableViewCell *cell = (DetailContentsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DETAIL_CONTENTS_CELL"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"DetailContentsTableViewCell" bundle:nil] forCellReuseIdentifier:@"DETAIL_CONTENTS_CELL"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"DETAIL_CONTENTS_CELL"];
        }
        PFObject *selectedSentence = [self.selectedSentences objectAtIndex:indexPath.row];
        cell.labelContents.text = selectedSentence[SENTENCE_KEY_TEXT];
        
        if(nil!=[selectedSentence objectForKey:SENTENCE_KEY_IMAGE]){
            cell.constraintBottom.constant = heightImage + marginSentence + marginTopBottom;
            CGFloat sentenceHeight = [[storyHeights objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]] floatValue];
            CGFloat y = marginTopBottom + sentenceHeight + marginSentence;
            CGRect frameImageView = CGRectMake(marginStoryLeftRight, y, [self getLabelWidthForStoryText], heightImage);
            [cell setSentenceImageViewWithFrame:frameImageView sentence:selectedSentence];
        }else{
            cell.constraintBottom.constant = marginTopBottom;
            [cell.imageViewSentence removeFromSuperview];
            cell.imageViewSentence = nil;
        }
        return cell;
    }else{
        DetailVotingTableViewCell *cell = (DetailVotingTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DETAIL_VOTING_CELL"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"DetailVotingTableViewCell" bundle:nil] forCellReuseIdentifier:@"DETAIL_VOTING_CELL"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"DETAIL_VOTING_CELL"];
        }
        PFObject *sentence = [self.sentencesToShow objectAtIndex:indexPath.row];
        cell.sentence = sentence;
        [cell setTextContent];
        [cell setVotedStatus];

        if(nil!=[sentence objectForKey:SENTENCE_KEY_IMAGE]){
            cell.constraintBottomMargin.constant = heightImage + marginSentence + marginTopBottom;
            CGFloat sentenceHeight = [[sentenceHeights objectForKey:[NSString stringWithFormat:@"%ld", indexPath.row]] floatValue];
            CGFloat y = marginTopBottom + heightUserName + marginSentence + sentenceHeight + marginSentence;
            CGRect frameImageView = CGRectMake(marginStoryLeftRight, y, [self getLabelWidthForSentenceCell], heightImage);
            [cell setSentenceImageViewWithFrame:frameImageView];
        }else{
            cell.constraintBottomMargin.constant = marginTopBottom;
            [cell.imageViewSentence removeFromSuperview];
            cell.imageViewSentence = nil;
        }
        
        return cell;
    }
}


#pragma mark - UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (SECTION_STORY_DETAIL == indexPath.section) {
        if (CELL_TITLE == indexPath.row) {
            return 200;
        } else {
            return [self heightForFirstSentenceCell];
        }
    } else if(SECTION_STORY_CONTENT == indexPath.section){
        return [self heightForStoryTextCell:indexPath.row];
    }else{
        return [self heightForSentencesCell:indexPath.row];
    }
}

-(CGFloat)heightForFirstSentenceCell{
    CGSize viewSize = self.view.frame.size;
    CGRect rect = CGRectMake(marginStoryLeftRight, marginTopBottom, viewSize.width - (marginStoryLeftRight * 2), viewSize.height - (marginTopBottom
                                                                                                                                    *2));
    UILabel *label = [self labelForHeightWithRect:rect];
    [label setText:self.story[STORY_KEY_FIRST_SENTENCE]];
    
    CGFloat height = [self getLabelHeight:label];
    
    return height + ( 2 * marginTopBottom ) + heightUserName + marginSentence;
}

-(CGFloat)heightForStoryTextCell:(NSInteger)row{
    CGSize viewSize = self.view.frame.size;
    CGRect rect = CGRectMake(marginStoryLeftRight, marginTopBottom, viewSize.width - (marginStoryLeftRight * 2), viewSize.height - (marginTopBottom
                                                                                                                              *2));
    PFObject *selectedSentence = [self.selectedSentences objectAtIndex:row];
 
    UILabel *label = [self labelForHeightWithRect:rect];
    [label setText:selectedSentence[SENTENCE_KEY_TEXT]];
    
    CGFloat height = [self getLabelHeight:label];
    [storyHeights setObject:[NSNumber numberWithFloat:height] forKey:[NSString stringWithFormat:@"%ld", row]];
    
    
    if(nil==[selectedSentence objectForKey:SENTENCE_KEY_IMAGE]){
        height += ( 2 * marginTopBottom );
    }else{
        height += ( 2 * marginTopBottom + marginSentence + heightImage);
    }
    
    return height;
}

-(UILabel *)labelForHeightWithRect:(CGRect)rect{
    UILabel *label = [UILabel new];
    [label setFrame:rect];
    [label setNumberOfLines:0];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setFont:[UIFont systemFontOfSize:fontSizeStory]];
    return label;
}


-(CGFloat)heightForSentencesCell:(NSInteger)row{
    CGRect rect = CGRectMake(marginStoryLeftRight, marginTopBottom, [self getLabelWidthForSentenceCell], self.view.frame.size.height - (marginTopBottom * 2));
    
    UILabel *label = [self labelForHeightWithRect:rect];
    PFObject *sentence = [self.sentencesToShow objectAtIndex:row];
    [label setText:sentence[SENTENCE_KEY_TEXT]];
    
    CGFloat height = [self getLabelHeight:label];
    [sentenceHeights setObject:[NSNumber numberWithFloat:height] forKey:[NSString stringWithFormat:@"%ld", row]];
    
    if(nil==[sentence objectForKey:SENTENCE_KEY_IMAGE]){
        height += ( 2 * marginTopBottom + heightUserName + marginSentence);
    }else{
        height += ( 2 * marginTopBottom + heightUserName + 2 * marginSentence + heightImage);
    }
    
    if(height <= 100){
        return 100;
    }
    
    return height;
}
-(CGFloat)getLabelWidthForStoryText{
    return self.view.frame.size.width - (marginStoryLeftRight * 2);
}

-(CGFloat)getLabelWidthForSentenceCell{
    return self.view.frame.size.width - marginStoryLeftRight - widthViewVote;
}
- (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, 20000.0f);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
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
    [super didChangeKeyboardStatus:status];
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
    NSLog(@"didPressLeftButton");
    callImagePicker = YES;
    imagePickerViewController = [[UIImagePickerController alloc] init];
    imagePickerViewController.delegate = (id)self;
    [imagePickerViewController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:imagePickerViewController animated:YES completion:^{
    }];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    NSLog(@"Info: %@", info);
    NSURL *picURL = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    NSString *stringUrl = picURL.absoluteString;
    NSURL *asssetURL = [NSURL URLWithString:stringUrl];
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    [fetchOptions setFetchLimit:1];
    [fetchOptions setIncludeAssetSourceTypes:PHAssetSourceTypeNone];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithALAssetURLs:@[asssetURL] options:fetchOptions];
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [fetchResult enumerateObjectsUsingBlock:^(PHAsset *phAsset, NSUInteger idx, BOOL * _Nonnull stop) {
        PHImageRequestOptions *requestOptions = [PHImageRequestOptions new];
        [requestOptions setDeliveryMode:PHImageRequestOptionsDeliveryModeOpportunistic];
        [requestOptions setNetworkAccessAllowed:YES];
        [requestOptions setSynchronous:NO];
        [imageManager requestImageForAsset:phAsset targetSize:CGSizeMake(320, 480) contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            [self showPIPWindow:result];
            callImagePicker = NO;
            [self.rightButton setEnabled:YES];
            [picker dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [imagePickerViewController dismissViewControllerAnimated:YES
                                                  completion:^{
                                                      if(_pipWindow){
                                                          [_pipWindow setHidden:NO];
                                                      }
                                                      callImagePicker = NO;
                                                    
                                                  }];
}

- (void)showPIPWindow:(UIImage *)image
{
    if(!_pipWindow){
        CGRect frame = CGRectMake(CGRectGetWidth(self.view.frame) - 60.0, 0.0, 50.0, 50.0);
        frame.origin.y = CGRectGetMinY(self.textInputbar.frame) - 60.0;
        
        _pipWindow = [[UIWindow alloc] initWithFrame:frame];
        _pipWindow.backgroundColor = [UIColor blackColor];
        _pipWindow.layer.cornerRadius = 10.0;
        _pipWindow.layer.masksToBounds = YES;
        _pipWindow.hidden = NO;
        _pipWindow.alpha = 0.0;
        
        [[UIApplication sharedApplication].keyWindow addSubview:_pipWindow];
        
        [UIView animateWithDuration:0.25
                         animations:^{
                             _pipWindow.alpha = 1.0;
                         }];
        imageViewComment = [[UIImageView alloc] initWithFrame:_pipWindow.bounds];
        [imageViewComment setContentMode:UIViewContentModeScaleAspectFill];
        [imageViewComment setClipsToBounds:YES];
        [_pipWindow addSubview:imageViewComment];
    }
    [imageViewComment setImage:image];
    [_pipWindow setHidden:NO];
}

- (void)hidePIPWindow
{
    if(_pipWindow){
        [UIView animateWithDuration:0.3
                         animations:^{
                             _pipWindow.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             _pipWindow.hidden = YES;
                             _pipWindow = nil;
                         }];
    }
}

- (void)textInputbarDidMove:(NSNotification *)note
{
    if (!_pipWindow) {
        return;
    }
    
    CGRect frame = self.pipWindow.frame;
    frame.origin.y = [note.userInfo[@"origin"] CGPointValue].y - 60.0;
    
    self.pipWindow.frame = frame;
}



- (void)didPressRightButton:(id)sender{
    // Notifies the view controller when the right button's action has been triggered, manually or by using the keyboard return key.
    
    // This little trick validates any pending auto-correction or auto-spelling just after hitting the 'Send' button
    [self.textView refreshFirstResponder];
    [self hidePIPWindow];
    
    PFObject *sentence = [PFObject objectWithClassName:SENTENCE_CLASSNAME];
    sentence[SENTENCE_KEY_STORY] = self.story;
    sentence[SENTENCE_KEY_END_SENTENCE] = [NSNumber numberWithBool:NO];
    sentence[SENTENCE_KEY_TEXT] = self.textView.text;
    sentence[SENTENCE_KEY_END_SENTENCE] = [NSNumber numberWithBool:self.isEndSentence];
    sentence[SENTENCE_KEY_VOTE_POINT] = [NSNumber numberWithInt:0];
    if(imageViewComment){
        NSData *imageData = UIImagePNGRepresentation(imageViewComment.image);
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
        sentence[SENTENCE_KEY_IMAGE] = imageFile;
    }
    [sentence saveNewSentenceWithSuccessBlock:^(id responseObject) {
        imageViewComment = nil;
    } failureBlock:^(NSError *error) {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
        // Try Again!!
    }];
    
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.sentencesToShow.count inSection:SECTION_VOTING];
    UITableViewRowAnimation rowAnimation = UITableViewRowAnimationBottom;
    UITableViewScrollPosition scrollPosition = UITableViewScrollPositionBottom;
    [self.tableView beginUpdates];
    if (0==self.sentencesToShow.count) {
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:rowAnimation];
    }
    NSMutableArray *sentences = [NSMutableArray arrayWithArray:self.sentencesToShow];
    [sentences addObject:sentence];
    self.sentencesToShow = sentences;
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
