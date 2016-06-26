//
//  ProjectBannerModel.h
//  JinZhiT
//
//  Created by Eugene on 16/5/8.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Extr,BannerRoadshows,BannerRoadshowplan,Body;

@interface ProjectBannerModel : NSObject



@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) Extr *extr;

@property (nonatomic, strong) Body *body;



@end
@interface Extr : NSObject

@property (nonatomic, strong) NSArray<BannerRoadshows *> *roadshows;

@property (nonatomic, copy) NSString *industoryType;

@property (nonatomic, assign) NSInteger projectId;

@end

@interface BannerRoadshows : NSObject

@property (nonatomic, strong) BannerRoadshowplan *roadshowplan;

@end

@interface BannerRoadshowplan : NSObject

@property (nonatomic, assign) NSInteger financedMount;

@property (nonatomic, assign) NSInteger financeTotal;

@end

@interface Body : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, assign) NSInteger bannerId;

@end

