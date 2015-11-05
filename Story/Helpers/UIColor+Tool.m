//
//  UIColor+Tool.m
//  Story
//
//  Created by Leonljy on 2015. 10. 19..
//  Copyright © 2015년 Favorie&John. All rights reserved.
//

#import "UIColor+Tool.h"

@implementation UIColor (Tool)

+(UIColor *)colorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue{
    return [UIColor colorWithRed:((CGFloat)red)/255.f green:((CGFloat)green)/255.f blue:((CGFloat)blue)/255.f alpha:1.0];
}
+(UIColor *)colorGrayWith:(CGFloat)rgb{
    return [UIColor colorWithRed:rgb/255.f green:rgb/255.f blue:rgb/255.f alpha:1.0];
}
+(UIColor *)colorGrayWith:(CGFloat)rgb alpha:(CGFloat)alpha{
    return [UIColor colorWithRed:rgb/255.f green:rgb/255.f blue:rgb/255.f alpha:alpha];
}

+(UIColor *)colorBlueBrand{
    return [self colorWithR:8 G:78 B:156];
}

+(UIColor *)colorRedBrand{
    return [self colorWithR:215 G:65 B:100];
}

+(UIColor *)colorTabbarTint{
    return [self colorRedBrand];
}
@end
