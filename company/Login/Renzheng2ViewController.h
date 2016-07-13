//
//  Renzheng2ViewController.h
//  JinZhiT
//
//  Created by Eugene on 16/5/6.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Renzheng2ViewController : RootViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel; // 标题label



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;  //下一步按钮

@property (nonatomic, strong) NSMutableDictionary *dicData;

@property (nonatomic, copy) NSString *identifyType; //身份类型

@property (nonatomic, copy) NSString *identiyCarNo;//身份证号
@property (nonatomic, copy) NSString *companyAddress;//公司地址
@property (nonatomic, copy) NSString *name;     //姓名
@property (nonatomic, copy) NSString *companyName;  //公司名字
@property (nonatomic, copy) NSString *position;     //
@property (nonatomic, copy) NSString *investField;   // 投资领域
@property (nonatomic, copy) NSString *industoryId; //行业类型ID
@property (nonatomic, copy) NSString *cityId;  //城市 ID

@property (nonatomic, assign) BOOL isCerity;

@end
