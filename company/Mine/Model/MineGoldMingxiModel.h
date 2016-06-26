//
//  MineGoldMingxiModel.h
//  JinZhiT
//
//  Created by Eugene on 16/5/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Rewardtradetype;
@interface MineGoldMingxiModel : NSObject


@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) Rewardtradetype *rewardtradetype;

@property (nonatomic, copy) NSString *tradeDate;

@property (nonatomic, assign) BOOL isShow;


@end

@interface Rewardtradetype : NSObject

@property (nonatomic, copy) NSString *name;

@end

