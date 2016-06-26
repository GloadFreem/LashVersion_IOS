//
//  MineCollectionInvestorBaseModel.h
//  company
//
//  Created by Eugene on 16/6/15.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MineCollectionUsersbyuserid,MineCollectionAuthentics,MineCollectionIdentiytype,MineCollectionAuthenticstatus,MineCollectionCity,MineCollectionProvince;
@interface MineCollectionInvestorBaseModel : NSObject



@property (nonatomic, strong) MineCollectionUsersbyuserid *usersByUserId;

@property (nonatomic, assign) NSInteger collecteId;


@end
@interface MineCollectionUsersbyuserid : NSObject

@property (nonatomic, strong) NSArray<MineCollectionAuthentics *> *authentics;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *headSculpture;

@end

@interface MineCollectionAuthentics : NSObject

@property (nonatomic, strong) MineCollectionAuthenticstatus *authenticstatus;

@property (nonatomic, copy) NSString *introduce;

@property (nonatomic, assign) NSInteger authId;

@property (nonatomic, copy) NSString *identiyCarA;

@property (nonatomic, copy) NSString *position;

@property (nonatomic, copy) NSString *identiyCarB;

@property (nonatomic, copy) NSString *buinessLicence;

@property (nonatomic, copy) NSString *companyAddress;

@property (nonatomic, copy) NSString *buinessLicenceNo;

@property (nonatomic, strong) MineCollectionCity *city;

@property (nonatomic, strong) MineCollectionIdentiytype *identiytype;

@property (nonatomic, copy) NSString *companyName;

@property (nonatomic, copy) NSString *companyIntroduce;

@property (nonatomic, strong) NSArray *autrhrecords;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *identiyCarNo;

@end

@interface MineCollectionIdentiytype : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger identiyTypeId;

@end

@interface MineCollectionAuthenticstatus : NSObject

@property (nonatomic, assign) NSInteger statusId;

@property (nonatomic, copy) NSString *name;

@end

@interface MineCollectionCity : NSObject

@property (nonatomic, assign) NSInteger cityId;

@property (nonatomic, assign) BOOL isInvlid;

@property (nonatomic, strong) MineCollectionProvince *province;

@property (nonatomic, copy) NSString *name;

@end

@interface MineCollectionProvince : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger provinceId;

@property (nonatomic, assign) BOOL isInvlid;

@end

