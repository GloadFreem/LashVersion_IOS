//
//  ProjectTagBaseModel.h
//  company
//
//  Created by Eugene on 2016/11/22.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ProjectTagModel;
@interface ProjectTagBaseModel : NSObject

@property (nonatomic, copy) NSString *cKey;
@property (nonatomic, copy) NSString *cName;
@property (nonatomic, strong) NSArray<ProjectTagModel *> *cData;
@end

@interface ProjectTagModel : NSObject

@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign) NSUInteger itemKey;

@end
