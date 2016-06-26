//
//  ProjectDetailLeftHeaderCell.h
//  JinZhiT
//
//  Created by Eugene on 16/6/1.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProjectDetailLeftHeaderModel.h"

@interface ProjectDetailLeftHeaderCell : UITableViewCell

@property (nonatomic, strong) ProjectDetailLeftHeaderModel *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);


@end
