//
//  CircleContentView.h
//  company
//
//  Created by Eugene on 16/8/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CircleContentView;

@protocol CircleContentViewDelegate <NSObject>

-(void)didClickContentView;

@end

@interface CircleContentView : UIView


@property (nonatomic, weak) id<CircleContentViewDelegate>delegate;

@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *contentLabelText;
@property (nonatomic, strong) NSString *titleLabelText;

@property (nonatomic, assign) BOOL isHidden;

@end
