//
//  MineCollectionProjectModel.h
//  company
//
//  Created by Eugene on 16/6/26.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MineFinancestatus,MineRoadshows,MineRoadshowplan;

@interface MineCollectionProjectModel : NSObject

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) NSInteger timeLeft;

@property (nonatomic, strong) MineFinancestatus *financestatus;

@property (nonatomic, copy) NSString *startPageImage;

@property (nonatomic, strong) NSArray<MineRoadshows *> *roadshows;

@property (nonatomic, copy) NSString *industoryType;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *fullName;

@property (nonatomic, assign) NSInteger projectId;

@property (nonatomic, assign) NSInteger collectionCount;

@property (nonatomic, copy) NSString *abbrevName;

@property (nonatomic, assign) NSInteger projectType;



@end

@interface MineFinancestatus : NSObject

@property (nonatomic, copy) NSString *name;

@end

@interface MineRoadshows : NSObject

@property (nonatomic, assign) NSInteger roadShowId;

@property (nonatomic, strong) MineRoadshowplan *roadshowplan;

@end

@interface MineRoadshowplan : NSObject

@property (nonatomic, copy) NSString *profit;

@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, copy) NSString *beginDate;

@property (nonatomic, assign) NSInteger limitAmount;

@property (nonatomic, assign) NSInteger financingId;

@property (nonatomic, assign) NSInteger financeTotal;

@property (nonatomic, assign) NSInteger financedMount;

@end

