//
//  TankViewController.h
//  company
//
//  Created by Eugene on 2016/10/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GENENavTabBar;

@interface TankViewController : UIViewController

@property (nonatomic, assign)   BOOL        scrollAnimation;            // Default value: NO
@property (nonatomic, assign)   BOOL        mainViewBounces;            // Default value: NO

@property (nonatomic, strong)   NSArray     *subViewControllers;        // An array of children view controllers

@property (nonatomic, strong)   UIColor     *navTabBarColor;            // Could not set [UIColor clear], if you set, NavTabbar will show initialize color
@property (nonatomic, strong)   UIColor     *navTabBarLineColor;

@property (nonatomic, assign) NSInteger unchangedToIndex;

@property (nonatomic, assign) NSInteger selectedToIndex;

@end
