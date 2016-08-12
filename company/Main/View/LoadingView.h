//
//  LoadingView.h
//  company
//
//  Created by Eugene on 16/8/11.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingViewDelegate.h"

@interface LoadingView : UIView
{
    UILabel *_labelMessage;
    UIImageView *_imageView;
    UIButton *_refreshBtn;
}

@property (nonatomic, strong) UIView *view;
@property (nonatomic, assign) BOOL isError;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL isTransparent;
@property (nonatomic, assign) id<LoadingViewDelegate> delegate;


@end
