//
//  ActivityDetailFooterView.h
//  JinZhiT
//
//  Created by Eugene on 16/6/3.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityDetailCommentCellModel.h"
#import "ActivityDetailCommentView.h"
#import "ActivityDetailFooterView.h"
@protocol ActivityCommentListFooterViewDelegate <NSObject>

@optional

-(void)didClickShowAllButton;
-(void)didClickLikeButton;
-(void)didClickCommentButton;

@end

@interface ActivityCommentListFooterView : UIView

@property (nonatomic, assign) Boolean isShowTopView; //是否展示顶部视图
@property (nonatomic, assign) id<ActivityCommentListFooterViewDelegate> delegate;


@property (nonatomic, copy) void (^didClickCommentLabelBlock)(NSString *commentId, CGRect rectInWindow);


@end
