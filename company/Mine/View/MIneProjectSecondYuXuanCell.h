//
//  MIneProjectSecondYuXuanCell.h
//  company
//
//  Created by Eugene on 16/6/29.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProjectListProModel.h"

@class MIneProjectSecondYuXuanCell;

@protocol MIneProjectSecondYuXuanCellDelegate <NSObject>

@optional

-(void)didClickIgnoreBtnInTheCell:(MIneProjectSecondYuXuanCell*)cell andindexPath:(NSIndexPath*)indexPath;
-(void)didClickInspectBtnInTheCell:(MIneProjectSecondYuXuanCell*)cell andIndexPath:(NSIndexPath*)indexPath;


@end

@interface MIneProjectSecondYuXuanCell : UITableViewCell

@property (nonatomic, assign) id<MIneProjectSecondYuXuanCellDelegate>delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) ProjectListProModel *model;

@property (nonatomic, strong) NSMutableArray *labelArray;

@end
