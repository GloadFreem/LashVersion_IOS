//
//  MineProjectCenterYuXuanCell.h
//  company
//
//  Created by Eugene on 16/6/29.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProjectListProModel.h"
@class MineProjectCenterYuXuanCell;

@protocol MineProjectCenterYuXuanCellDelegate <NSObject>

@optional

-(void)didClickRecordBtnInTheCell:(MineProjectCenterYuXuanCell*)cell andIndexPath:(NSIndexPath*)indexPath;
-(void)didClickDetailBtnInTheCell:(MineProjectCenterYuXuanCell*)cell andIndexPath:(NSIndexPath*)indexPath;


@end

@interface MineProjectCenterYuXuanCell : UITableViewCell

@property (nonatomic, assign) id<MineProjectCenterYuXuanCellDelegate>delegate;

@property (nonatomic, strong) NSIndexPath *indexpath;

@property (nonatomic, strong) ProjectListProModel *model;

@property (nonatomic, strong) NSMutableArray *labelArray;

@end
