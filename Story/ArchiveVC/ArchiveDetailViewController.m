//
//  ArchiveDetailViewController.m
//  Story
//
//  Created by Leonljy on 2015. 11. 3..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "ArchiveDetailViewController.h"
#import "ArchiveTitleCell.h"
#import "ArchiveDescriptionCell.h"
#import "ArchiveDividerCell.h"
#import "ArchiveStoryCell.h"
#import "ArchiveContributesCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PFObject+Sentence.h"
#import "PFUser+User.h"
#import "NovelistConstants.h"

@interface ArchiveDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong ,nonatomic) NSArray *sentences;
@property (strong ,nonatomic) NSArray *writers;
@property (strong, nonatomic) NSMutableSet *writersSet;
@end

typedef enum{
    SECTION_STORY_INFO=0,
    SECTION_STORY,
    SECTION_DIVIDER,
    SECTION_CONTRIBUTES,
    SECTION_DIVIDER_SECOND,
    SECTION_COUNT
}archiveSection;
typedef enum {
    CELL_ARCHIVE_TITLE =0,
    CELL_ARCHIVE_DESCRIPTION,
    CELL_ARCHIVE_DIVIDER,
    CELL_ARCHIVE_PROLOGUE,
    CELL_ARCHIVE_STORY,
    CELL_ARCHIVE_CONTRIBUTES
}archiveCell;

@implementation ArchiveDetailViewController{
    CGFloat marginLeftRight;
    CGFloat marginTopBottom;
    CGFloat heightLabel;
    CGFloat heightImageStory;
    NSInteger fontSizeStory;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = self.story[STORY_KEY_TITLE];
    [self initializeConstants];
    [self reloadSentences];
}

-(void)initializeConstants{
    marginLeftRight = [NovelistConstants getMarginLeftRight];
    marginTopBottom = [NovelistConstants getMarginTopBottom];
    heightLabel = [NovelistConstants getLabelSingleHeight];
    fontSizeStory = [NovelistConstants getTextFontSize];
    heightImageStory = [NovelistConstants getImageHeight];
}

-(void)reloadSentences{
    [PFObject sentencesForArchivedStory:self.story successBlock:^(NSArray *objects) {
        self.sentences = objects;
        self.writersSet = [NSMutableSet set];
        for(PFObject *sentence in self.sentences){
            [self.writersSet addObject:sentence[SENTENCE_KEY_WRITER_NAME]];
        }
        self.writers = [self.writersSet allObjects];
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return SECTION_COUNT;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case SECTION_STORY_INFO:
            return 4;
            break;
        case SECTION_STORY:
            return [self.sentences count];
            break;
        case SECTION_DIVIDER:
            return 1;
            break;
        case SECTION_CONTRIBUTES:
            return [self.writers count];
            break;
        case SECTION_DIVIDER_SECOND:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    switch(indexPath.section){
        case SECTION_STORY_INFO:{
            if(CELL_ARCHIVE_TITLE == indexPath.row){
                ArchiveTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ARCHIVE_TITLE"];
                [titleCell setContents:self.story];
                PFUser *user = [PFUser currentUser];
                if([user[USER_KEY_BOOKMARKED_STORIES] containsObject:self.story]){
                    [titleCell.buttonBookmark setSelected:YES];
                }else{
                    [titleCell.buttonBookmark setSelected:NO];
                }
                cell = titleCell;
            }else if(CELL_ARCHIVE_DESCRIPTION == indexPath.row){
                ArchiveDescriptionCell *descriptionCell = (ArchiveDescriptionCell *)[tableView dequeueReusableCellWithIdentifier:@"CELL_ARCHIVE_DESCRIPTION"];
                [descriptionCell setContents:self.story];
                cell = descriptionCell;
            }else if(CELL_ARCHIVE_DIVIDER == indexPath.row){
                cell = (ArchiveDividerCell *)[tableView dequeueReusableCellWithIdentifier:@"CELL_ARCHIVE_DIVIDER"];
            }else if(CELL_ARCHIVE_PROLOGUE == indexPath.row){
                ArchiveStoryCell *storyCell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ARCHIVE_STORY"];
                [storyCell setPrologue:self.story[STORY_KEY_FIRST_SENTENCE]];
                cell = storyCell;
            }
            break;
        }
        case SECTION_STORY:{
            PFObject *sentence = [self.sentences objectAtIndex:indexPath.row];
            ArchiveStoryCell *storyCell;
            if(nil==sentence[SENTENCE_KEY_IMAGE]){
                storyCell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ARCHIVE_STORY"];
            }else{
                storyCell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ARCHIVE_STORY_IMAGE"];
            }
            [storyCell setContents:sentence];
            cell = storyCell;
            break;
        }
        case SECTION_DIVIDER:{
            cell = (ArchiveDividerCell *)[tableView dequeueReusableCellWithIdentifier:@"CELL_ARCHIVE_DIVIDER"];
            break;
        }
        case SECTION_CONTRIBUTES:{
            ArchiveContributesCell *contributesCell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ARCHIVE_CONTRIBUTES"];
            NSString *writerName = [self.writers objectAtIndex:indexPath.row];
            [contributesCell setContents:writerName];
            cell = contributesCell;
            break;
        }
        case SECTION_DIVIDER_SECOND:
            cell = (ArchiveDividerCell *)[tableView dequeueReusableCellWithIdentifier:@"CELL_ARCHIVE_DIVIDER"];
            break;
        default:
            break;
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch(indexPath.section){
        case SECTION_STORY_INFO:{
            if(CELL_ARCHIVE_TITLE == indexPath.row){
                return 225;
            }else if(CELL_ARCHIVE_DESCRIPTION == indexPath.row){
                CGFloat height = [self heightForDescriptionCell];
                return height;
            }else if(CELL_ARCHIVE_DIVIDER == indexPath.row){
                return 50;
            }else if(CELL_ARCHIVE_PROLOGUE == indexPath.row){
                return [self heightForPrologue];
            }
            break;
        }
        case SECTION_STORY:{
            return [self heightForSentence:indexPath.row];
            break;
        }
        case SECTION_CONTRIBUTES:{
            return 22;
            break;
        }
        case SECTION_DIVIDER:{
            return 50;
        }
        case SECTION_DIVIDER_SECOND:{
            return 50;
        }
        default:
            return 0;
            break;
            
    }
    
    return 0;
}

-(CGFloat)heightForPrologue{
    CGSize viewSize = self.view.frame.size;
    CGRect rect = CGRectMake(marginLeftRight, marginTopBottom, viewSize.width - (marginLeftRight * 2), viewSize.height - (marginTopBottom
                                                                                                                          *2));
    UILabel *label = [self labelForHeightWithRect:rect];
    [label setText:self.story[STORY_KEY_FIRST_SENTENCE]];
    
    CGFloat height = [self getLabelHeight:label];
    height += marginTopBottom * 2;
    return height;
}

-(CGFloat)heightForSentence:(NSInteger)row{
    CGSize viewSize = self.view.frame.size;
    CGRect rect = CGRectMake(marginLeftRight, marginTopBottom, viewSize.width - (marginLeftRight * 2), viewSize.height - (marginTopBottom
                                                                                                                          *2));
    UILabel *label = [self labelForHeightWithRect:rect];
    PFObject *sentence = [self.sentences objectAtIndex:row];
    [label setText:sentence[SENTENCE_KEY_TEXT]];
    
    CGFloat height = [self getLabelHeight:label];
    if(nil==[sentence objectForKey:SENTENCE_KEY_IMAGE]){
        height += ( 2 * marginTopBottom);
    }else{
        height += ( 3 * marginTopBottom + heightImageStory);
    }
    return height;
}

-(CGFloat)heightForDescriptionCell{
    CGSize viewSize = self.view.frame.size;
    CGRect rect = CGRectMake(marginLeftRight, marginTopBottom, viewSize.width - (marginLeftRight * 2), viewSize.height - (marginTopBottom
                                                                                                                                    *2));
    UILabel *label = [self labelForHeightWithRect:rect];
    [label setText:self.story[STORY_KEY_DESCRIPTION]];
    
    CGFloat height = [self getLabelHeight:label];
    
    return height + heightLabel + (marginTopBottom * 3) + 3;
}

-(UILabel *)labelForHeightWithRect:(CGRect)rect{
    UILabel *label = [UILabel new];
    [label setFrame:rect];
    [label setNumberOfLines:0];
    [label setLineBreakMode:NSLineBreakByWordWrapping];
    [label setFont:[UIFont systemFontOfSize:fontSizeStory]];
    return label;
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
- (IBAction)handleBookmark:(id)sender {
    UIButton *buttonBookmark = (UIButton *)sender;
    [buttonBookmark setEnabled:NO];
    if(buttonBookmark.selected){
        [self.story cancelBookmarkWithSuccessBlock:^(id responseObject) {
            [buttonBookmark setEnabled:YES];
            [buttonBookmark setSelected:NO];
        } failureBlock:^(NSError *error) {
            [buttonBookmark setEnabled:YES];
        }];
    }else{
        [self.story bookmarkWithSuccessBlock:^(id responseObject) {
            [buttonBookmark setEnabled:YES];
            [buttonBookmark setSelected:YES];
        } failureBlock:^(NSError *error) {
            [buttonBookmark setEnabled:YES];
        }];
    }
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
