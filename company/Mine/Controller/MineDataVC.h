//
//  MineDataVC.h
//  JinZhiT
//
//  Created by Eugene on 16/5/25.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenticInfoBaseModel.h"

@interface MineDataVC : RootViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) AuthenticInfoBaseModel *authenticModel;

@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *address;

@property (nonatomic, assign) NSInteger identiyTypeId;
@property (nonatomic, assign) NSInteger authId;
@end
