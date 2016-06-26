//
//  ProjectNoRoadCell.h
//  JinZhiT
//
//  Created by Eugene on 16/5/9.
//  Copyright © 2016年 Eugene. All rights reserved.
//


//---------------------------------首页预选项目cell--------------------------


#import <UIKit/UIKit.h>
#import "ProjectListProModel.h"

@interface ProjectNoRoadCell : UITableViewCell

@property (nonatomic, strong) ProjectListProModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *projectLabel;
@property (weak, nonatomic) IBOutlet UILabel *companyLabel;
@property (weak, nonatomic) IBOutlet UILabel *personNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;


@property (weak, nonatomic) IBOutlet UIButton *middleBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnArray;


@end
