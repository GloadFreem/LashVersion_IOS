//
//  MineViewController.h
//  JinZhiT
//
//  Created by Eugene on 16/5/21.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineViewController : RootViewController

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *company;

@property (nonatomic, copy) NSString *companyS;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *iconStr;

@end
