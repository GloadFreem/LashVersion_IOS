//
//  ProjectSceneOtherCell.h
//  company
//
//  Created by Eugene on 16/7/7.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProjectDetailSceneCellModel.h"

@interface ProjectSceneOtherCell : UITableViewCell

@property (nonatomic, strong) ProjectDetailSceneCellModel *model;

@property (strong, nonatomic)  UIImageView *iconImage;

@property (strong, nonatomic) UILabel *nameLabel;

@property (strong, nonatomic)  UILabel *contentLabel;

@property (strong, nonatomic)  UILabel *timeLabel;

@end
