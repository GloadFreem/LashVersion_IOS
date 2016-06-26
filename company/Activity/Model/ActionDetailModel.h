//
//  ActionDetailModel.h
//  company
//
//  Created by air on 16/6/14.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Actionimages;
@interface ActionDetailModel : NSObject
@property (nonatomic, strong) NSArray<NSString *> *actionprises;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic ,assign)NSString * address;
@property (nonatomic, copy) NSString * endTime;

@property (nonatomic, assign) NSInteger memberLimit;

@property (nonatomic, assign) NSInteger flag;

@property (nonatomic, assign) NSInteger actionId;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSArray<Actionimages *> *actionimages;

@end

@interface Actionimages : NSObject

@property (nonatomic, assign) NSInteger imgId;

@property (nonatomic, copy) NSString *url;

@end

