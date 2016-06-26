//
//  InvestViewController.h
//  JinZhiT
//
//  Created by Eugene on 16/5/3.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    SegmentSelectLine = 0,//选中时为横线的样式
    SegmentCaver = 1,//选中时view的状态
    
}SelectType;

@interface InvestViewController : UIViewController

@property (nonatomic,strong) UIColor *lineColor;
@property (nonatomic,assign) SelectType type;

@end
