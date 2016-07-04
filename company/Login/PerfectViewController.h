//
//  PerfectViewController.h
//  JinZhiT
//
//  Created by Eugene on 16/5/5.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerfectViewController : RootViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, copy) NSString *btnTitle;

@property (nonatomic, copy) NSString *wxIcon;

@end
