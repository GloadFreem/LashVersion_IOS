//
//  ProjectDetailSceneCellModel.h
//  company
//
//  Created by Eugene on 16/6/18.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectDetailSceneCellModel : NSObject

@property (nonatomic, assign) BOOL flag;

@property (nonatomic, copy) NSString *iconImage;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *time;

@property (assign, nonatomic)BOOL isShowTime;

@end
