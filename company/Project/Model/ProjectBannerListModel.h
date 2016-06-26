//
//  ProjectBannerListModel.h
//  company
//
//  Created by Eugene on 16/6/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectBannerListModel : NSObject

@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger bannerId;
@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *industoryType;
@property (nonatomic, assign) NSInteger projectId;
@property (nonatomic, assign) NSInteger financeTotal;
@property (nonatomic, assign) NSInteger financedMount;
@property (nonatomic, copy) NSString *type;

@end
