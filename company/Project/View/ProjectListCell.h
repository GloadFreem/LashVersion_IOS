//
//  ProjectListCell.h
//  JinZhiT
//
//  Created by Eugene on 16/5/8.
//  Copyright © 2016年 Eugene. All rights reserved.
//


//---------------------------------首页路演项目cell--------------------------

#import <UIKit/UIKit.h>
#import "ProjectListProModel.h"
#import "ZMProgressView.h"

@interface ProjectListCell : UITableViewCell

@property (nonatomic, strong) ProjectListProModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *projectLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *personNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labelArray;

@property (weak, nonatomic) IBOutlet ZMProgressView *progressView;


@end
