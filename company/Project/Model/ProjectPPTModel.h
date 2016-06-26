//
//  ProjectPPTModel.h
//  company
//
//  Created by Eugene on 16/6/19.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectPPTModel : NSObject


@property (nonatomic, assign) NSInteger playTime;

@property (nonatomic, assign) NSInteger playId;

@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, assign) NSInteger startTime;

@property (nonatomic, assign) NSInteger endTime;

@property (nonatomic, assign) NSInteger sortIndex;

@end
