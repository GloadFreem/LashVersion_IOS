//
//  ProjectPrepareDetailVC.h
//  company
//
//  Created by Eugene on 16/6/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MineAttentionVC.h"
#import "ProjectListProModel.h"

@interface ProjectPrepareDetailVC : RootViewController

@property (nonatomic, assign) NSInteger projectId;

@property (nonatomic, strong) MineAttentionVC *attentionVC;

@property (nonatomic, strong) ProjectListProModel *model;

@property (nonatomic, strong) UITableView *tableView;

@end
