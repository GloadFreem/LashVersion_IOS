//
//  noNetView.h
//  company
//
//  Created by Eugene on 16/8/19.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>


@class noNetView;

@protocol noNetViewDelegate <NSObject>

@optional

-(void)didClickBtnInView;

@end

@interface noNetView : UIView

@property (nonatomic, weak) id<noNetViewDelegate> delegate;

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *btn;

@end
