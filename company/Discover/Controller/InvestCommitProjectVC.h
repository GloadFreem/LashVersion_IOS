//
//  InvestCommitProjectVC.h
//  JinZhiT
//
//  Created by Eugene on 16/5/27.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvestListModel.h"

#import "InvestViewController.h"

@interface InvestCommitProjectVC : RootViewController

@property (nonatomic, strong) InvestListModel *model;

@property (nonatomic, strong) InvestViewController *viewController;

@end
