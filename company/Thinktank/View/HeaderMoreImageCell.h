//
//  HeaderMoreImageCell.h
//  company
//
//  Created by Eugene on 2016/10/18.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TankPointModel.h"
#import "TankHeaderModel.h"
@interface HeaderMoreImageCell : UITableViewCell

@property (nonatomic, strong) TankPointModel *pointModel;

@property (nonatomic, strong) TankHeaderModel *headerModel;
@end
