//
//  ActivityDetailHeaderCell.h
//  JinZhiT
//
//  Created by Eugene on 16/5/20.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ActivityDetailHeaderModel.h"

@class ActivityDetailHeaderModel;

@interface ActivityDetailHeaderCell : UITableViewCell


@property (nonatomic, strong) ActivityDetailHeaderModel *model;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath *indexPath);

@end
