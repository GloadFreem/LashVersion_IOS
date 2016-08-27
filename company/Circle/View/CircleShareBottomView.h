//
//  CircleShareBottomView.h
//  company
//
//  Created by Eugene on 16/6/12.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CircleShareBottomView;

@protocol CircleShareBottomViewDelegate <NSObject>

- (void)sendShareBtnWithView:(CircleShareBottomView *)view index:(int)index;

@end

@interface CircleShareBottomView : UIView

@property (nonatomic, strong) UIView *shareView;
@property (nonatomic,assign) id<CircleShareBottomViewDelegate>delegate;

- (void)createShareViewWithTitleArray:(NSArray *)titleArr imageArray:(NSArray *)imageArr;

- (void)createShareCircleViewWithTitleArray:(NSArray *)titleArr imageArray:(NSArray *)imageArr;

@end
