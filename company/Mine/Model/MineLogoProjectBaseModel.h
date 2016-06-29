//
//  MineLogoProjectBaseModel.h
//  company
//
//  Created by Eugene on 16/6/29.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LogoFinancestatus,LogoRoadshows,LogoRoadshowplan;
@interface MineLogoProjectBaseModel : NSObject



@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) NSInteger timeLeft;

@property (nonatomic, strong) LogoFinancestatus *financestatus;

@property (nonatomic, copy) NSString *startPageImage;

@property (nonatomic, strong) NSArray<LogoRoadshows *> *roadshows;

@property (nonatomic, copy) NSString *industoryType;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *fullName;

@property (nonatomic, assign) NSInteger projectId;

@property (nonatomic, assign) NSInteger collectionCount;

@property (nonatomic, copy) NSString *abbrevName;

@property (nonatomic, assign) NSInteger projectType;


@end

@interface LogoFinancestatus : NSObject

@property (nonatomic, copy) NSString *name;

@end

@interface LogoRoadshows : NSObject

@property (nonatomic, assign) NSInteger roadShowId;

@property (nonatomic, strong) LogoRoadshowplan *roadshowplan;

@end

@interface LogoRoadshowplan : NSObject

@property (nonatomic, copy) NSString *profit;

@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, copy) NSString *beginDate;

@property (nonatomic, assign) NSInteger limitAmount;

@property (nonatomic, assign) NSInteger financingId;

@property (nonatomic, assign) NSInteger financeTotal;

@property (nonatomic, assign) NSInteger financedMount;

@end

