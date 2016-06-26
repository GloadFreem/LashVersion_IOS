//
//  MineCollectionInvestModel.h
//  company
//
//  Created by Eugene on 16/6/26.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Usersbyusercollectedid,MAuthentics,MIdentiytype,MCity,MProvince,MAuthenticstatus;
@interface MineCollectionInvestModel : NSObject




@property (nonatomic, strong) Usersbyusercollectedid *usersByUserCollectedId;

@property (nonatomic, assign) NSInteger collecteId;


@end
@interface Usersbyusercollectedid : NSObject

@property (nonatomic, strong) NSArray<MAuthentics *> *authentics;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *headSculpture;

@end

@interface MAuthentics : NSObject

@property (nonatomic, assign) NSInteger authId;

@property (nonatomic, strong) MCity *city;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *introduce;

@property (nonatomic, strong) MIdentiytype *identiytype;

@property (nonatomic, copy) NSString *companyName;

@property (nonatomic, strong) MAuthenticstatus *authenticstatus;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *industoryArea;

@end

@interface MIdentiytype : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger identiyTypeId;

@end

@interface MCity : NSObject

@property (nonatomic, assign) NSInteger cityId;

@property (nonatomic, assign) BOOL isInvlid;

@property (nonatomic, strong) MProvince *province;

@property (nonatomic, copy) NSString *name;

@end

@interface MProvince : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger provinceId;

@property (nonatomic, assign) BOOL isInvlid;

@end

@interface MAuthenticstatus : NSObject

@property (nonatomic, assign) NSInteger statusId;

@property (nonatomic, copy) NSString *name;

@end

