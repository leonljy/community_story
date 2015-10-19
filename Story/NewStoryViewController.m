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
#import <AssetsLibrary/AssetsLibrary.h>

@interface NewStoryViewController () <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelDescriptionLength;
@property (weak, nonatomic) IBOutlet UILabel *labelFirstSentenceLength;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPhoto;

@end

typedef enum {
    TAG_TEXTVIEW_DESCRIPTION = 0,
    TAG_TEXTVIEW_FIRST_SENTENCE
}TagTextView;

@implementation NewStoryViewController{
    BOOL isKeyboardOpened;
    UIImagePickerController *imagePickerViewController;
}
@synthesize titleTextField;
@synthesize descriptionTextView;
@synthesize prologueTextView;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [descriptionTextView setTag:TAG_TEXTVIEW_DESCRIPTION];
    [prologueTextView setTag:TAG_TEXTVIEW_FIRST_SENTENCE];
    isKeyboardOpened = NO;
    [self.imageViewPhoto setContentMode:UIViewContentModeScaleAspectFill];
    [self.imageViewPhoto setClipsToBounds:YES];
}

- (IBAction)saveNewStory:(id)sender {
    PFObject *newStory = [PFObject objectWithClassName:STORY_CLASSNAME];
    newStory[STORY_KEY_TITLE] = titleTextField.text;
    newStory[STORY_KEY_DESCRIPTION] = descriptionTextView.text;
    newStory[STORY_KEY_FIRST_SENTENCE] = prologueTextView.text;
    [newStory saveNewStoryWithSuccessBlock:^(id responseObject) {
        [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(NSError *error) {
        
    }];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSLog(@"textFieldShouldBeginEditing");
    if(textView == self.descriptionTextView){
        return YES;
    }
    CGFloat keyboardHeight = [self keyboardHeight];
    
    [UIView animateWithDuration:2.5 delay:0.0 options:(7 << 16) animations:^{
        CGRect frame = self.view.frame;
        self.view.frame = CGRectMake(frame.origin.x, frame.origin.y - keyboardHeight, frame.size.width, frame.size.height+keyboardHeight);
    } completion:^(BOOL finished) {
        isKeyboardOpened = YES;
    }];
    return YES;
}

-(CGFloat)keyboardHeight{
    CGFloat keyboardHeight;
    BOOL isSmallerThanIphoneSixPlus = [[UIScreen mainScreen] bounds].size.height < 730;
    if(isSmallerThanIphoneSixPlus){
        keyboardHeight = 216.0;
    }else{
        keyboardHeight = 226.0;
    }
    return keyboardHeight;
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"DidEndediting");
    if(textView == self.descriptionTextView){
        return;
    }
    
    [self hideKeyboard];
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
- (IBAction)handleHideKeyboard:(id)sender {
    if(isKeyboardOpened){
        [self.prologueTextView resignFirstResponder];
    }
}

-(void)hideKeyboard{
    CGFloat keyboardHeight = [self keyboardHeight];
    
    [UIView animateWithDuration:2.5 delay:0.0 options:(7 << 16) animations:^{
        CGRect frame = self.view.frame;
        self.view.frame = CGRectMake(frame.origin.x, frame.origin.y + keyboardHeight, frame.size.width, frame.size.height-keyboardHeight);
    } completion:^(BOOL finished) {
        isKeyboardOpened = NO;
    }];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)handleCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)handlePhoto:(id)sender {
    NSLog(@"handlePhoto");

    imagePickerViewController = [[UIImagePickerController alloc] init];
    imagePickerViewController.delegate = self;
    [imagePickerViewController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:imagePickerViewController animated:YES completion:^{
        
    }];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"Info: %@", info);
    NSURL *picURL = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
    NSString *stringUrl = picURL.absoluteString;
    NSURL *asssetURL = [NSURL URLWithString:stringUrl];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    __block UIImage *returnValue = nil;
    [library assetForURL:asssetURL resultBlock:^(ALAsset *asset) {
        returnValue = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
        [self.imageViewPhoto setImage:returnValue];
        [imagePickerViewController dismissViewControllerAnimated:YES completion:^{
            
        }];
    } failureBlock:^(NSError *error) {
    }];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [imagePickerViewController dismissViewControllerAnimated:YES
     completion:^{
     
     }];
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
