//
//  ProfileViewController.m
//  Story
//
//  Created by john kim on 10/1/15.
//  Copyright © 2015 Favorie&John. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProfileUserCell.h"
#import "PFUser+User.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "PFObject+Story.h"
#import "PFObject+Sentence.h"
#import "ProfileContributeCell.h"
#import "NovelistConstants.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *contributes;
@property (strong, nonatomic) NSDictionary *othersStories;
@end

typedef enum{
    SECTION_PROFILE=0,
    SECTION_CONTRIBUTES,
    SECTION_COUNT
}profileSection;
@implementation ProfileViewController{
    CGFloat marginLeftRight;
    CGFloat marginTopBottom;
    CGFloat heightLabel;
    CGFloat heightImageStory;
    NSInteger fontSizeStory;
    UIRefreshControl *refreshControl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reloadContributes) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:refreshControl];
    [self reloadContributes];
}

-(void)reloadContributes{
    [PFUser contributedCurrentUserWithSuccessBlock:^(NSArray *objects) {
//        NSLog(@"Objects: %@", objects);7
        NSMutableDictionary *othersStories = [NSMutableDictionary dictionary];
        NSMutableArray *contributes = [NSMutableArray array];
        for(PFObject *object in objects){
            if([object.parseClassName isEqualToString:STORY_CLASSNAME]){
                if(object[STORY_KEY_OWNER] == [PFUser currentUser]){
                    [contributes addObject:object];
                }else{
                    [othersStories setObject:object forKey:object.objectId];
                }
            }else{
                [contributes addObject:object];
            }
        }
        self.contributes = contributes;
        self.othersStories = othersStories;
        [self.tableView reloadData];
        [refreshControl endRefreshing];
    } failureBlock:^(NSError *error) {
        [refreshControl endRefreshing];
    }];
}


-(void)initializeConstants{
    marginLeftRight = [NovelistConstants getMarginLeftRight];
    marginTopBottom = [NovelistConstants getMarginTopBottom];
    heightLabel = [NovelistConstants getLabelSingleHeight];
    fontSizeStory = [NovelistConstants getTextFontSize];
    heightImageStory = [NovelistConstants getImageHeight];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return SECTION_COUNT;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case SECTION_PROFILE:
            return 1;
            break;
        case SECTION_CONTRIBUTES:
            return [self.contributes count];
            break;
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    switch (indexPath.section) {
        case SECTION_PROFILE:{
            ProfileUserCell *profileCell = [tableView dequeueReusableCellWithIdentifier:@"CELL_USER_PROFILE"];
            [profileCell.buttonLogout addTarget:self action:@selector(handleLogout) forControlEvents:UIControlEventTouchUpInside];
            [profileCell.labelUsername setText:[[PFUser currentUser] username]];
            [profileCell.labelUserDescription setText:[[PFUser currentUser] email]];
            cell = profileCell;
            break;
        }
        case SECTION_CONTRIBUTES:{
            ProfileContributeCell *contributeCell = [tableView dequeueReusableCellWithIdentifier:@"CELL_PROFILE_CONTRIBUTE_SMALL"];
            PFObject *object = [self.contributes objectAtIndex:indexPath.row];
            NSString *name;
            NSString *content;
            
            if([object.parseClassName isEqualToString:STORY_CLASSNAME]){
                name = object[STORY_KEY_TITLE];
                content = object[STORY_KEY_FIRST_SENTENCE];
                [contributeCell setStoryInfoWithStory:object];
                PFFile *image = object[STORY_KEY_IMAGE];
                [contributeCell.imageViewContent sd_setImageWithURL:[NSURL URLWithString:image.url] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
            }else{
                NSString *objectId = ((PFObject *)object[SENTENCE_KEY_STORY]).objectId;
                PFObject *story = [self.othersStories objectForKey:objectId];
                [contributeCell setStoryInfoWithStory:story];
                name = story[STORY_KEY_TITLE];
                content = object[SENTENCE_KEY_TEXT];
                PFFile *image;
                if(nil==object[SENTENCE_KEY_IMAGE]){
                    image = story[STORY_KEY_IMAGE];
                }else{
                    image = object[SENTENCE_KEY_IMAGE];
                }
                [contributeCell.imageViewContent sd_setImageWithURL:[NSURL URLWithString:image.url] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
            }

            [contributeCell.labelName setText:name];
            [contributeCell.labelSentence setText:content];
            cell = contributeCell;
            break;
        }
        default:
            break;
    }
    return cell;
}

#pragma mark - Dynamic TableViewCell Height

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch(indexPath.section){
        case SECTION_PROFILE:{
            return 200;
            break;
        }
        case SECTION_CONTRIBUTES:{
            return 75;
            break;
        }
        default:
            return 0;
            break;
            
    }
    
    return 0;
}

/*
-(CGFloat)heightForSentence:(NSInteger)row{
    CGSize viewSize = self.view.frame.size;
    CGRect rect = CGRectMake(marginLeftRight, marginTopBottom, viewSize.width - (marginLeftRight * 2), viewSize.height - (marginTopBottom
                                                                                                                          *2));
    UILabel *label = [self labelForHeightWithRect:rect];
//    PFObject *sentence = [self.sentences objectAtIndex:row];
//    [label setText:sentence[SENTENCE_KEY_TEXT]];
    
    CGFloat height = [self getLabelHeight:label];
//    if(nil==[sentence objectForKey:SENTENCE_KEY_IMAGE]){
//        height += ( 2 * marginTopBottom);
//    }else{
//        height += ( 3 * marginTopBottom + heightImageStory);
//    }
    return height;
}
//
//
//-(CGFloat)heightForDescriptionCell{
//    CGSize viewSize = self.view.frame.size;
//    CGRect rect = CGRectMake(marginLeftRight, marginTopBottom, viewSize.width - (marginLeftRight * 2), viewSize.height - (marginTopBottom
//                                                                                                                          *2));
//    UILabel *label = [self labelForHeightWithRect:rect];
////    [label setText:self.story[STORY_KEY_DESCRIPTION]];
//    
//    CGFloat height = [self getLabelHeight:label];
//    
//    return height + heightLabel + (marginTopBottom * 2);
//}

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

*/
#pragma mark - Event Handler

-(void)handleLogout{
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if(error){
            
        }else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
            LoginViewController *loginVieWController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            [UIView transitionWithView:appDelegate.window
                              duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromLeft
                            animations:^{
                                [appDelegate.window setRootViewController:loginVieWController];
                            }
                            completion:nil];
        }
    }];
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
