//
//  InvestThinkTankDetailVC.h
//  JinZhiT
//
//  Created by Eugene on 16/5/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InvestViewController.h"

#import "MineAttentionVC.h"
#import "MineCollectionListModel.h"
@interface InvestThinkTankDetailVC : RootViewController

@property (nonatomic, assign) InvestViewController *viewController;

@property (nonatomic, copy) NSString *investorId;
@property (nonatomic, copy) NSString *attentionCount;

//@property (nonatomic, assign) BOOL collected;

@property (nonatomic, copy) NSString *investorCollectPartner;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) MineAttentionVC *attentionVC;
@property (nonatomic, strong) MineCollectionListModel *collectModel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isMine;

@property (nonatomic, assign) BOOL isCircle;

@end
