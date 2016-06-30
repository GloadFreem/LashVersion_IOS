//
//  MineProjectCenterProCell.h
//  company
//
//  Created by Eugene on 16/6/29.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectListProModel.h"

@class MineProjectCenterProCell;

@protocol MineProjectCenterProCellDelegate <NSObject>

@optional

-(void)didClickRecordBtnInCenterCell:(MineProjectCenterProCell*)cell andIndexPath:(NSIndexPath*)indexPath;

-(void)didClickDetailBtnInCenterCell:(MineProjectCenterProCell*)cell andIndexPath:(NSIndexPath*)indexPath;

@end

@interface MineProjectCenterProCell : UITableViewCell

@property (nonatomic, assign) id<MineProjectCenterProCellDelegate>delagate;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) ProjectListProModel *model;

@property (nonatomic, strong) NSMutableArray *labelArray;

@end
