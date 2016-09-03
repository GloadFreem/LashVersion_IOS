//
//  ActivityBottomView.h
//  company
//
//  Created by LiLe on 16/8/22.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActivityBottomViewDelegate <NSObject>

@optional

-(void)startShareB;
-(void)didClickLikeButton:(UIButton *)btn;
-(void)didClickCommentButton;
-(void)attendAction;

@end

@interface ActivityBottomView : UIView

@property (nonatomic, strong) UIButton *signUpBtn;

@property (nonatomic, assign) id<ActivityBottomViewDelegate> delegate;
@property (nonatomic, assign) BOOL flag;

@property (nonatomic, assign) BOOL attend;

@property (nonatomic, assign) BOOL isExpired;

@end
