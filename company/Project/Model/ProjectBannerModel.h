//
//  ProjectBannerModel.h
//  JinZhiT
//
//  Created by Eugene on 16/5/8.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>



@class Extr,BannerFinancestatus,BannerRoadshows,BannerRoadshowplan,Body;
@interface ProjectBannerModel : NSObject


@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) Extr *extr;

@property (nonatomic, strong) Body *body;



@end


@interface Extr : NSObject

@property (nonatomic, assign) NSInteger projectId;

@property (nonatomic, copy) NSString *borrowerUserNumber;

@property (nonatomic, strong) BannerFinancestatus *financestatus;

@property (nonatomic, copy) NSString *industoryType;

@property (nonatomic, strong) NSArray<BannerRoadshows *> *roadshows;

@end

@interface BannerFinancestatus : NSObject

@property (nonatomic, copy) NSString *name;

@end

@interface BannerRoadshows : NSObject

@property (nonatomic, strong) BannerRoadshowplan *roadshowplan;

@end

@interface BannerRoadshowplan : NSObject

@property (nonatomic, assign) NSInteger limitAmount;

@property (nonatomic, copy) NSString *profit;

@property (nonatomic, assign) NSInteger financeTotal;

@property (nonatomic, assign) NSInteger financedMount;

@end

@interface Body : NSObject

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) NSInteger bannerId;

@end

