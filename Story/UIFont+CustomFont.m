//
//  UIFont+CustomFont.m
//  At
//
//  Created by Leonljy on 2015. 9. 1..
//  Copyright (c) 2015년 Favorie. All rights reserved.
//

#import "UIFont+CustomFont.h"
#import <objc/runtime.h>

@implementation UIFont (CustomFont)
+(UIFont *)regularFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Montserrat-Light" size:size];
}

+(UIFont *)boldFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Montserrat-Regular" size:size];
}

+(void)load
{
    SEL original = @selector(systemFontOfSize:);
    SEL modified = @selector(regularFontWithSize:);
    SEL originalBold = @selector(boldSystemFontOfSize:);
    SEL modifiedBold = @selector(boldFontWithSize:);
    
    Method originalMethod = class_getClassMethod(self, original);
    Method modifiedMethod = class_getClassMethod(self, modified);
    method_exchangeImplementations(originalMethod, modifiedMethod);
    
    Method originalBoldMethod = class_getClassMethod(self, originalBold);
    Method modifiedBoldMethod = class_getClassMethod(self, modifiedBold);
    method_exchangeImplementations(originalBoldMethod, modifiedBoldMethod);
}
@end
