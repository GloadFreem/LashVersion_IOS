//
//  MineProjectCommitRecordCell.h
//  company
//
//  Created by Eugene on 16/6/30.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MineProjectCommitRecordBaseModel.h"

@interface MineProjectCommitRecordCell : UITableViewCell

@property (nonatomic, strong) MineProjectCommitRecordBaseModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *statuslabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
