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

-(void)customizeUIElements{
    [self customizeUINavigationBar];
    [self customizeTabBar];
    
}

-(void)customizeUINavigationBar{
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:15]}];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor blackColor]];
}

-(void)customizeBarButtons{
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
}

-(void)customizeTabBar{
//    [[UITabBar appearance] setBarTintColor:[UIColor colorGrayWith:50]];
    [[UITabBar appearance] setTintColor:[UIColor colorTabbarTint]];
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -5)];
}

-(void)customizeStatusBar{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
