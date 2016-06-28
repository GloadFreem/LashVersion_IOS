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

@property (nonatomic, assign) BOOL isChange;
@property (nonatomic, strong) UITableView *tableView; //当前biao

-(void)startLoadData;

@end
