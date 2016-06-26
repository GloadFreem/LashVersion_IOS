//
//  PlatformIdentityVC.h
//  JinZhiT
//
//  Created by Eugene on 16/5/25.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlatformIdentityVC : UIViewController

@property (nonatomic, copy) NSString *identifyType;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *identifyLabel;

@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;

@end
