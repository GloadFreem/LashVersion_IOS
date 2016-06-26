//
//  CircleDetailCommentCell.h
//  JinZhiT
//
//  Created by Eugene on 16/6/1.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CircleDetailCommentModel.h"
@interface CircleDetailCommentCell : UITableViewCell

@property (nonatomic, strong) CircleDetailCommentModel *model;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *bottomLine;


@end
