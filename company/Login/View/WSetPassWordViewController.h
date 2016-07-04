//
//  WSetPassWordViewController.h
//  JinZhiT
//
//  Created by Eugene on 16/6/1.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSetPassWordViewController : RootViewController

@property (weak, nonatomic) IBOutlet UITextField *firstTextField;


@property (weak, nonatomic) IBOutlet UITextField *secondTextField;


@property (weak, nonatomic) IBOutlet UIButton *cerfityBtn;

@property (nonatomic, copy) NSString *telephone;
@property (nonatomic, copy) NSString *certifyNum;
@property (nonatomic, copy) NSString *ringCode;

@property (nonatomic, copy) NSString *identifyType;

@end
