//
//  PhoneCerityViewController.m
//  JinZhiT
//
//  Created by Eugene on 16/5/7.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "PhoneCerityViewController.h"

@interface PhoneCerityViewController ()

@end

@implementation PhoneCerityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    _certifyBtn.layer.cornerRadius = 5;
    _certifyBtn.layer.masksToBounds = YES;
    
    _nextStepBtn.layer.cornerRadius = 22;
    _nextStepBtn.layer.masksToBounds = 5;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
