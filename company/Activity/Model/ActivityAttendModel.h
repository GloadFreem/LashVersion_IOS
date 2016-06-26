//
//  ActivityCommentModel.h
//  company
//
//  Created by air on 16/6/14.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ActivityUsers,ActivityAuthentics;
@interface ActivityAttendModel : NSObject

@property (nonatomic, strong) ActivityUsers *users;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) NSInteger attendUid;

@property (nonatomic, copy) NSString *enrollDate;

@end
@interface ActivityUsers : NSObject

@property (nonatomic, strong) NSArray<ActivityAuthentics *> *authentics;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *headSculpture;

@end

@interface ActivityAuthentics : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *companyName;

@property (nonatomic, copy) NSString *position;

@end

