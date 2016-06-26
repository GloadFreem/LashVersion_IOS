//
//  InvestViewController.h
//  JinZhiT
//
//  Created by Eugene on 16/5/3.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvestListModel.h"
#import "OrganizationSecondModel.h"

typedef enum{
    
    SegmentSelectLine = 0,//选中时为横线的样式
    SegmentCaver = 1,//选中时view的状态
    
}SelectType;

@interface InvestViewController : RootViewController

@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic,assign) SelectType type;

@property (nonatomic, strong) InvestListModel *investModel;
@property (nonatomic, strong) OrganizationSecondModel *organizationModel;


@property (nonatomic, strong) UITableView *tableView; //当前biao


@property (nonatomic, strong) NSMutableArray *investPersonArray; //投资人模型数组
@property (nonatomic, strong) NSMutableArray *investOrganizationSecondArray; //第二个数组

@property (nonatomic, strong) NSMutableArray *thinkTankArray; //智囊团模型数组


@end
