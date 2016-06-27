//
//  BannerViewController.h
//  JinZhiTou
//
//  Created by air on 15/8/13.
//  Copyright (c) 2015年 金指投. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
@interface YeePayViewController : RootViewController
@property(assign,nonatomic)int type;
@property(retain,nonatomic)NSURL* url;
@property(assign,nonatomic)bool canBack;
@property(assign, nonatomic) PayStatus state;
@property(retain,nonatomic)NSDictionary* dic;
@property(retain,nonatomic)UIWebView* webView;
@property(retain,nonatomic)NSString* titleStr;
@property(retain,nonatomic)NSDictionary* PostPramDic;
@property (nonatomic, copy) NSString *startPageImage;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *abbrevName;

@property (nonatomic, copy) NSString *tradeCode;
@property (nonatomic, copy) NSString *chargePartner;
@property (nonatomic, copy) NSString *drawPartner;

@property (nonatomic, copy) NSString *center;

@end
