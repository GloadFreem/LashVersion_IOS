//
//  TankPointController.h
//  company
//
//  Created by Eugene on 2016/10/19.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TankPointController : RootViewController


@property (nonatomic, strong) UITableViewCustomView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSourceArray;

@property (nonatomic, strong) UISearchBar *searchBar;

@end
