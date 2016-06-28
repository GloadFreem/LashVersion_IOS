//
//  MineAlertView.h
//  company
//
//  Created by Eugene on 16/6/28.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MineAlertView;

@protocol MineAlertViewDelegate <NSObject>

@optional

-(void)didClickBtnInView:(MineAlertView*)view andIndex:(NSInteger)index;

@end

@interface MineAlertView : UIView

@property (nonatomic, assign) id<MineAlertViewDelegate>delegate;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIView *alertView;

-(void)createAlertViewWithBtnTitleArray:(NSArray*)titleArray andContent:(NSString*)content;

@end
