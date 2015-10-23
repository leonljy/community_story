//
//  UIColor+Tool.h
//  Story
//
//  Created by Leonljy on 2015. 10. 19..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Tool)
+(UIColor *)colorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue;
+(UIColor *)colorGrayWith:(CGFloat)rgb;
+(UIColor *)colorGrayWith:(CGFloat)rgb alpha:(CGFloat)alpha;
+(UIColor *)colorBlueBrand;
@end
