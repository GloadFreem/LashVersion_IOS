//
//  UITableViewCustomView.h
//  company
//
//  Created by Eugene on 16/8/12.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCustomView : UITableView

@property (nonatomic, assign) BOOL isNone;
@property (nonatomic, assign) NSString *emptyImgFileName;
@property (nonatomic, copy) NSString *content;

@end
