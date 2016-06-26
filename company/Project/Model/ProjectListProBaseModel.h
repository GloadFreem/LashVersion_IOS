//
//  ProjectListProBaseModel.h
//  company
//
//  Created by Eugene on 16/6/15.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Project,Financestatus,Roadshows,Roadshowplan;
@interface ProjectListProBaseModel : NSObject



@property (nonatomic, assign) NSInteger collectionId;

@property (nonatomic, strong) Project *project;

@end

@interface Project : NSObject

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, assign) NSInteger timeLeft;

@property (nonatomic, strong) Financestatus *financestatus;

@property (nonatomic, copy) NSString *startPageImage;

@property (nonatomic, strong) NSArray<Roadshows *> *roadshows;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *fullName;

@property (nonatomic, assign) NSInteger projectId;

@property (nonatomic, assign) NSInteger collectionCount;

@property (nonatomic, copy) NSString *abbrevName;

@property (nonatomic, assign) NSInteger projectType;

@property (nonatomic, copy) NSString *industoryType;

@end

@interface Financestatus : NSObject

@property (nonatomic, copy) NSString *name;

@end

@interface Roadshows : NSObject

@property (nonatomic, assign) NSInteger roadShowId;

@property (nonatomic, strong) Roadshowplan *roadshowplan;

@end

@interface Roadshowplan : NSObject

@property (nonatomic, assign) NSInteger financingId;

@property (nonatomic, copy) NSString *endDate;

@property (nonatomic, assign) NSInteger financeTotal;

@property (nonatomic, assign) NSInteger financedMount;

@property (nonatomic, copy) NSString *beginDate;

@end

