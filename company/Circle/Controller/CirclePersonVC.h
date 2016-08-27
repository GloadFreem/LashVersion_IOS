//
//  CirclePersonVC.h
//  company
//
//  Created by Eugene on 16/8/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CirclePersonVC : RootViewController

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *userId; //自己id
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableViewCustomView *tableView;

@end
