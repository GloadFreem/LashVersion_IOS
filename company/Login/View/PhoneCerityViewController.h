//
//  PhoneCerityViewController.h
//  JinZhiT
//
//  Created by Eugene on 16/5/7.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneCerityViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *certifyCodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *ringCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *certifyBtn;


@property (weak, nonatomic) IBOutlet UIButton *nextStepBtn;

@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;

@end
