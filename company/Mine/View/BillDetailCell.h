//
//  BillDetailCell.h
//  company
//
//  Created by Eugene on 16/6/18.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BillDetailCellModel.h"
@interface BillDetailCell : UITableViewCell

@property (nonatomic, strong) UIImageView *topLine;

@property (nonatomic, strong) BillDetailCellModel *model;

@end
