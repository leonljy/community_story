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
#import <Photos/Photos.h>

@interface NewStoryViewController () <UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *labelDescriptionLength;
@property (weak, nonatomic) IBOutlet UILabel *labelFirstSentenceLength;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPhoto;
@property (weak, nonatomic) IBOutlet UILabel *labelCategorytitle;
@property (weak, nonatomic) IBOutlet UILabel *labelCategoryDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelCategoryPrologue;
@property (weak, nonatomic) IBOutlet UILabel *labelCategorySelectPhoto;
@property (weak, nonatomic) IBOutlet UIView *viewSelectPhotoBackground;

@end

typedef enum {
    TAG_TEXTVIEW_DESCRIPTION = 0,
    TAG_TEXTVIEW_FIRST_SENTENCE
}TagTextView;

@implementation NewStoryViewController{
    BOOL isKeyboardOpened;
    BOOL isImageSet;
    UIImagePickerController *imagePickerViewController;
}
@synthesize titleTextField;
@synthesize descriptionTextView;
@synthesize prologueTextView;



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setContentsFont];
    [self setTextFieldRadious];
    
    [descriptionTextView setTag:TAG_TEXTVIEW_DESCRIPTION];
    [prologueTextView setTag:TAG_TEXTVIEW_FIRST_SENTENCE];
    isKeyboardOpened = NO;
    isImageSet = NO;
    [self.imageViewPhoto setContentMode:UIViewContentModeScaleAspectFill];
    [self.imageViewPhoto setClipsToBounds:YES];
}

-(void)setTextFieldContentSize{
    
}
-(void)setTextFieldRadious{
    CGFloat radius = 5.0f;
    self.titleTextField.layer.masksToBounds = YES;
    self.titleTextField.layer.cornerRadius = radius;
    self.descriptionTextView.layer.masksToBounds = YES;
    self.descriptionTextView.layer.cornerRadius = radius;
    self.prologueTextView.layer.masksToBounds = YES;
    self.prologueTextView.layer.cornerRadius = radius;
    
    self.viewSelectPhotoBackground.layer.masksToBounds = YES;
    self.viewSelectPhotoBackground.layer.cornerRadius = radius;
}
-(void)setContentsFont{
    NSInteger fontSize = 14;
    NSInteger smallFontSize = 10;
    [self.labelCategoryDescription setFont:[UIFont systemFontOfSize:fontSize]];
    [self.labelCategoryPrologue setFont:[UIFont systemFontOfSize:fontSize]];
    [self.labelCategorySelectPhoto setFont:[UIFont systemFontOfSize:fontSize]];
    [self.labelCategorytitle setFont:[UIFont systemFontOfSize:fontSize]];
    
    [self.labelDescriptionLength setFont:[UIFont systemFontOfSize:smallFontSize]];
    [self.labelFirstSentenceLength setFont:[UIFont systemFontOfSize:smallFontSize]];
    
    [self.titleTextField setFont:[UIFont systemFontOfSize:fontSize]];
    [self.descriptionTextView setFont:[UIFont systemFontOfSize:fontSize]];
    [self.prologueTextView setFont:[UIFont systemFontOfSize:fontSize]];
}

- (IBAction)saveNewStory:(id)sender {
    PFObject *newStory = [PFObject objectWithClassName:STORY_CLASSNAME];
    newStory[STORY_KEY_TITLE] = titleTextField.text;
    newStory[STORY_KEY_DESCRIPTION] = descriptionTextView.text;
    newStory[STORY_KEY_FIRST_SENTENCE] = prologueTextView.text;
    
    if(isImageSet){
        NSData *imageData = UIImagePNGRepresentation(self.imageViewPhoto.image);
        PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
        newStory[STORY_KEY_IMAGE] = imageFile;
    }
    
    [newStory saveNewStoryWithSuccessBlock:^(id responseObject) {
        [self dismissViewControllerAnimated:YES completion:nil];
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
    }else{
        [self.descriptionTextView resignFirstResponder];
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
            [self.imageViewPhoto setImage:result];
            isImageSet = YES;
            [picker dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
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
