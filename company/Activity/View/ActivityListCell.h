//
//  ActivityListCell.h
//  company
//
//  Created by Eugene on 16/8/8.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ActivityViewModel.h"

@interface ActivityListCell : UITableViewCell

@property (nonatomic, strong) ActivityViewModel *model;

@end
