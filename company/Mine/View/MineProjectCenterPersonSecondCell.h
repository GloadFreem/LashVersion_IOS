//
//  MineProjectCenterPersonSecondCell.h
//  JinZhiT
//
//  Created by Eugene on 16/5/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProjectListProModel.h"

@class MineProjectCenterPersonSecondCell;

@protocol MineProjectCenterPersonSecondCellDelegate <NSObject>

@optional

-(void)didClickIgnoreBtnInSecondCell:(MineProjectCenterPersonSecondCell*)cell andIndexPath:(NSIndexPath*)indexPath;

-(void)didClickInspectBtnInSecondCell:(MineProjectCenterPersonSecondCell*)cell andIndexPath:(NSIndexPath*)indexPath;


@end


@interface MineProjectCenterPersonSecondCell : UITableViewCell

@property (nonatomic, assign) id<MineProjectCenterPersonSecondCellDelegate>delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) ProjectListProModel *model;

@property (nonatomic, strong) NSMutableArray *labelArray;

@end
