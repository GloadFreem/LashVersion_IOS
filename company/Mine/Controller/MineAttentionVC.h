//
//  MineAttentionVC.h
//  JinZhiT
//
//  Created by Eugene on 16/5/23.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineAttentionVC : RootViewController

@property (nonatomic, strong) NSMutableArray *projectArray;
@property (nonatomic, strong) NSMutableArray *investArray;
@property (nonatomic, strong) NSMutableArray *temProjectArray;
@property (nonatomic, strong) NSMutableArray *temInvestArray;

@property (nonatomic, assign) BOOL isChange;
@property (nonatomic, strong) UITableViewCustomView *tableView; //当前biao

-(void)startLoadData;

@end
