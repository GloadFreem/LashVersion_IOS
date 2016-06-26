//
//  ProjectDetailBaseMOdel.h
//  company
//
//  Created by Eugene on 16/6/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DetailProject,DetailFinancestatus,DetailRoadshows,DetailRoadshowplan,DetailTeams,DetailProjectimageses,DetailExtr;
@interface ProjectDetailBaseMOdel : NSObject


@property (nonatomic, strong) DetailProject *project;

@property (nonatomic, strong) NSArray<DetailExtr *> *extr;


@end
@interface DetailProject : NSObject

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) NSInteger timeLeft;

@property (nonatomic, strong) DetailFinancestatus *financestatus;

@property (nonatomic, copy) NSString *startPageImage;

@property (nonatomic, strong) NSArray<DetailRoadshows *> *roadshows;

@property (nonatomic, copy) NSString *industoryType;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *fullName;

@property (nonatomic, assign) NSInteger projectId;

@property (nonatomic, assign) BOOL collected;

@property (nonatomic, assign) NSInteger collectionCount;

@property (nonatomic, assign) NSInteger commentCount;

@property (nonatomic, copy) NSString *abbrevName;

@property (nonatomic, assign) NSInteger projectType;

@property (nonatomic, strong) NSArray<DetailTeams *> *teams;

@property (nonatomic, strong) NSArray<DetailProjectimageses *> *projectimageses;

@property (nonatomic, copy) NSString *borrowerUserNumber;

@end

@interface DetailFinancestatus : NSObject

@property (nonatomic, copy) NSString *name;

@end

@interface DetailRoadshows : NSObject

@property (nonatomic, assign) NSInteger roadShowId;

@property (nonatomic, strong) DetailRoadshowplan *roadshowplan;

@end

@interface DetailRoadshowplan : NSObject

@property (nonatomic, assign) NSInteger financingId;

@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, assign) NSInteger financeTotal;

@property (nonatomic, assign) NSInteger financedMount;

@property (nonatomic, copy) NSString *beginDate;

@property (nonatomic, assign) float limitAmount;

@property (nonatomic, copy) NSString *profit;

@end

@interface DetailTeams : NSObject

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *introduce;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *company;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger personId;

@end

@interface DetailProjectimageses : NSObject

@property (nonatomic, assign) NSInteger projectImageId;

@property (nonatomic, copy) NSString *imageUrl;

@end

@interface DetailExtr : NSObject

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) NSInteger buinessPlanId;

@end

