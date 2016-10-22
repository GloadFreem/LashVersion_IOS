//
//  GENENavTabBar.h
//  Company
//
//  Created by Eugene on 2016/10/12.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GENENavTabBarDelegate <NSObject>

@optional

- (void)itemDidSelectedWithIndex:(NSInteger)index;

@end

@interface GENENavTabBar : UIView

@property (nonatomic,weak) id<GENENavTabBarDelegate> delegate;
@property (nonatomic, assign) NSInteger currentIndex;    //
@property (nonatomic, assign) NSInteger unchangedToIndex;    //
@property (nonatomic, strong) NSArray *totalItemTitles;    //
@property (nonatomic, strong) NSArray *selectedItemTitles;    //
@property (nonatomic, assign) NSInteger selectedToIndex;    //
@property (nonatomic, strong) UIColor *lineColor;    //

@end
