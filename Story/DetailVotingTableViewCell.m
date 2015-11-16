//
//  DetailVotingTableViewCell.m
//  Story
//
//  Created by Kwanghwi Kim on 2015. 10. 5..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "DetailVotingTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIColor+Tool.h"
#import "NovelistConstants.h"

@implementation DetailVotingTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.labelNewSentence setFont:[UIFont systemFontOfSize:[NovelistConstants getTextFontSize]]];
    [self.labelUsername setFont:[UIFont systemFontOfSize:[NovelistConstants getLabelFontSize]]];
    [self.labelVoteCount setFont:[UIFont systemFontOfSize:[NovelistConstants getSmallTextSize]]];
    
    [self.labelNewSentence setTextColor:[UIColor colorTextGrey]];
    [self.labelUsername setTextColor:[UIColor blackColor]];
    [self.labelVoteCount setTextColor:[UIColor blackColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)handleUp:(id)sender {
    [self disableButtons];
    if(self.buttonUp.selected){
        [self.sentence cancelUpVoteWithSuccessBlock:^(id responseObject) {
            [self enableButtons];
            [self.buttonUp setSelected:NO];
            [self reloadSentence];
        } failureBlock:^(NSError *error) {
            [self enableButtons];
        }];
    }else{
        if(self.buttonDown.selected){
            [self.sentence cancelDownVoteWithSuccessBlock:^(id responseObject) {
                [self.buttonDown setSelected:NO];
                [self.sentence upVoteWithSuccessBlock:^(id responseObject) {
                    [self.buttonUp setSelected:YES];
                    [self enableButtons];
                    [self reloadSentence];
                } failureBlock:^(NSError *error) {
                    [self reloadSentence];
                    [self enableButtons];
                }];
            } failureBlock:^(NSError *error) {
                    [self enableButtons];
            }];
        }else{
            [self.sentence upVoteWithSuccessBlock:^(id responseObject) {
                [self enableButtons];
                [self.buttonUp setSelected:YES];
                [self reloadSentence];
            } failureBlock:^(NSError *error) {
                [self enableButtons];
            }];
        }
    }
}

- (IBAction)handleDown:(id)sender {
    [self disableButtons];
    if(self.buttonDown.selected){
        [self.sentence cancelDownVoteWithSuccessBlock:^(id responseObject) {
            [self enableButtons];
            [self.buttonDown setSelected:NO];
            [self reloadSentence];
        } failureBlock:^(NSError *error) {
            [self enableButtons];
        }];
    }else{
        if(self.buttonUp.selected){
            [self.sentence cancelUpVoteWithSuccessBlock:^(id responseObject) {
                [self.buttonUp setSelected:NO];
                [self.sentence downVoteWithSuccessBlock:^(id responseObject) {
                    [self.buttonDown setSelected:YES];
                    [self enableButtons];
                    [self reloadSentence];
                } failureBlock:^(NSError *error) {
                    [self reloadSentence];
                    [self enableButtons];
                }];
            } failureBlock:^(NSError *error) {
                [self enableButtons];
            }];
        }else{
            [self.sentence downVoteWithSuccessBlock:^(id responseObject) {
                [self enableButtons];
                [self.buttonDown setSelected:YES];
                [self reloadSentence];
            } failureBlock:^(NSError *error) {
                [self enableButtons];
            }];
        }
    }
}


-(void)reloadSentence{
    PFQuery *query  = [PFQuery queryWithClassName:SENTENCE_CLASSNAME];
    [query getObjectInBackgroundWithId:self.sentence.objectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if(error){
            
        }else{
            self.sentence = object;
            [self setVotedStatus];
        }
    }];
}


-(void)disableButtons{
    [self.buttonDown setEnabled:NO];
    [self.buttonUp setEnabled:NO];
}

-(void)enableButtons{
    [self.buttonDown setEnabled:YES];
    [self.buttonUp setEnabled:YES];
}

-(void)setSentenceImageViewWithFrame:(CGRect)frame{
    if(nil==self.imageViewSentence){
        self.imageViewSentence = [[UIImageView alloc] initWithFrame:frame];
        [self.imageViewSentence setClipsToBounds:YES];
        [self.imageViewSentence setContentMode:UIViewContentModeScaleAspectFill];
        [self.viewContentBackground addSubview:self.imageViewSentence];
    }
    PFFile *image = self.sentence[SENTENCE_KEY_IMAGE];
    [self.imageViewSentence sd_setImageWithURL:[NSURL URLWithString:image.url] placeholderImage:[UIImage imageNamed:@"placeHolder"]];
}

-(void)setTextContent{
    self.labelNewSentence.text = self.sentence[SENTENCE_KEY_TEXT];
    [self.labelUsername setText:self.sentence[SENTENCE_KEY_WRITER_NAME]];
}
-(void)setVotedStatus{
    NSNumber *voteCount = self.sentence[SENTENCE_KEY_VOTE_POINT];
    self.labelVoteCount.text = voteCount.stringValue;
    if([self.sentence[SENTENCE_KEY_UPVOTED_USERS] containsObject:[PFUser currentUser]]){
        [self.buttonUp setSelected:YES];
        [self.buttonDown setSelected:NO];
    }else if([self.sentence[SENTENCE_KEY_DOWNVOTED_USERS] containsObject:[PFUser currentUser]]){
        [self.buttonUp setSelected:NO];
        [self.buttonDown setSelected:YES];
    }else{
        [self.buttonUp setSelected:NO];
        [self.buttonDown setSelected:NO];
    }
}
@end
