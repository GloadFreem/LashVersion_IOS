//
//  ThinkTankCell.h
//  JinZhiT
//
//  Created by Eugene on 16/5/18.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvestListModel.h"


@class ThinkTankCell;

@protocol ThinkTankCellDelegate <NSObject>

-(void)didClickAttentionBtnInCell:(ThinkTankCell*)cell andModel:(InvestListModel*)model;

@end

@interface ThinkTankCell : UITableViewCell

@property (nonatomic, weak) id<ThinkTankCellDelegate>delegate;

@property (nonatomic, strong) InvestListModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *position;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *companyAddress;

@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *companyNameWidth;


+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
