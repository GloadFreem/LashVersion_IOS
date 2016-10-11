//
//  MineAttentionVC.h
//  JinZhiT
//
//  Created by Eugene on 16/5/23.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectListProModel.h"
#import "MineCollectionProjectModel.h"
#import "MineCollectionListModel.h"

@interface MineAttentionVC : RootViewController

@property (nonatomic, strong) NSMutableArray *projectArray;
@property (nonatomic, strong) NSMutableArray *investArray;
@property (nonatomic, strong) NSMutableArray *temProjectArray;
@property (nonatomic, strong) NSMutableArray *temInvestArray;

@property (nonatomic, assign) BOOL isChange;
@property (nonatomic, strong) UITableViewCustomView *tableView; //当前biao
@property (nonatomic, strong) UITableViewCustomView *projectTableView;  //项目视图
@property (nonatomic, strong) UITableViewCustomView *investTableView;  //投资视图

@property (nonatomic, strong) NSMutableArray *identifyArray;
@property (nonatomic, strong) NSMutableArray *statusArray;

@property (nonatomic, strong) MineCollectionListModel *selectedListModel;
@property (nonatomic, strong) ProjectListProModel *selectedProjectModel;

-(void)startLoadData;

@end
