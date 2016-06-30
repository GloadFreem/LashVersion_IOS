//
//  MineProjectCommitRecordBaseModel.h
//  company
//
//  Created by Eugene on 16/6/30.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CommitRecord,CommitStatus,CommitUser,CommitAuthentics,CommitIdentiytype;
@interface MineProjectCommitRecordBaseModel : NSObject



@property (nonatomic, strong) CommitRecord *record;

@property (nonatomic, strong) CommitUser *user;


@end
@interface CommitRecord : NSObject

@property (nonatomic, assign) NSInteger recordId;

@property (nonatomic, strong) CommitStatus *status;

@property (nonatomic, copy) NSString *recordDate;

@end

@interface CommitStatus : NSObject

@property (nonatomic, assign) NSInteger recordId;

@property (nonatomic, copy) NSString *name;

@end

@interface CommitUser : NSObject

@property (nonatomic, strong) NSArray<CommitAuthentics *> *authentics;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *headSculpture;

@end

@interface CommitAuthentics : NSObject

@property (nonatomic, copy) NSString *position;

@property (nonatomic, strong) CommitIdentiytype *identiytype;

@property (nonatomic, copy) NSString *companyAddress;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *companyName;

@property (nonatomic, assign) NSInteger authId;

@end

@interface CommitIdentiytype : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger identiyTypeId;

@end

