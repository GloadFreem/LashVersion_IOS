//
//  ProjectDetailSceneMessageCell.h
//  JinZhiT
//
//  Created by Eugene on 16/5/11.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProjectDetailSceneCellModel.h"
@interface ProjectDetailSceneMessageCell : UITableViewCell

@property (nonatomic, strong) ProjectDetailSceneCellModel *model;

@property (strong, nonatomic)  UIImageView *iconImage;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic)  UILabel *contentLabel;

@property (strong, nonatomic)  UILabel *timeLabel;

@property (strong, nonatomic) UIView * contentBGView;
@property (strong, nonatomic) UIView * timeBGView;

@end
