//
//  CircleDetailHeaderView.h
//  JinZhiT
//
//  Created by Eugene on 16/6/1.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleListModel.h"

@class CircleDetailHeaderView;
@protocol CircleDetailHeaderViewDelegate <NSObject>

@optional

-(void)didClickPraiseBtn:(CircleDetailHeaderView*)view model:(CircleListModel*)model;

@end
@interface CircleDetailHeaderView : UIView

@property (nonatomic, weak) id<CircleDetailHeaderViewDelegate> delegate;

@property (nonatomic, strong) CircleListModel *model;
@property (nonatomic, strong) UIButton *praiseBtn;

@end
