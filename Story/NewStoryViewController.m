//
//  NewStoryViewController.m
//  Story
//
//  Created by john kim on 10/1/15.
//  Copyright © 2015 Favorie&John. All rights reserved.
//

#import "NewStoryViewController.h"
#import <Parse/Parse.h>
#import "PFObject+Story.h"
#import "NovelistConstants.h"

@interface NewStoryViewController () <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelDescriptionLength;
@property (weak, nonatomic) IBOutlet UILabel *labelFirstSentenceLength;

@end

typedef enum {
    TAG_TEXTVIEW_DESCRIPTION = 0,
    TAG_TEXTVIEW_FIRST_SENTENCE
}TagTextView;

@implementation NewStoryViewController
@synthesize titleTextField;
@synthesize descriptionTextView;
@synthesize prologueTextView;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [descriptionTextView setTag:TAG_TEXTVIEW_DESCRIPTION];
    [prologueTextView setTag:TAG_TEXTVIEW_FIRST_SENTENCE];
    
}

- (IBAction)saveNewStory:(id)sender {
    PFObject *newStory = [PFObject objectWithClassName:STORY_CLASSNAME];
    newStory[STORY_KEY_TITLE] = titleTextField.text;
    newStory[STORY_KEY_DESCRIPTION] = descriptionTextView.text;
    newStory[STORY_KEY_FIRST_SENTENCE] = prologueTextView.text;
    newStory[STORY_KEY_TEXT] = prologueTextView.text;
    [newStory saveNewStoryWithSuccessBlock:^(id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(NSError *error) {
        
    }];
}

-(void)textViewDidChange:(UITextView *)textView{
    NSString *text = textView.text;
    NSInteger lengthLimit = [NovelistConstants lengthLimit];
    
    if(lengthLimit < text.length){
        text = [text substringToIndex:lengthLimit];
        textView.text = text;
    }
    
    switch (textView.tag) {
        case TAG_TEXTVIEW_DESCRIPTION:{
            [_labelDescriptionLength setText:[NSString stringWithFormat:@"%ld / %ld", text.length, lengthLimit]];
            break;
        }
        case TAG_TEXTVIEW_FIRST_SENTENCE:{
            [_labelFirstSentenceLength setText:[NSString stringWithFormat:@"%ld / %ld", text.length, lengthLimit]];
            break;
        }
        default:
            break;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
