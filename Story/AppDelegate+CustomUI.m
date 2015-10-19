//
//  AppDelegate+CustomUI.m
//  At
//
//  Created by Leonljy on 2015. 3. 5..
//  Copyright (c) 2015년 Favorie. All rights reserved.
//

#import "AppDelegate+CustomUI.h"
#import "UIColor+Tool.h"

@implementation AppDelegate (CustomUI)

-(void)customizeUINavigationBar{
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorGrayWith:50]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

-(void)customizeBarButtons{
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
}

-(void)customizeUIElements{
    [self customizeUINavigationBar];
//    [self customizeBarButtons];
}
@end
