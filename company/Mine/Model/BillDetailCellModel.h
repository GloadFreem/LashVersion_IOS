//
//  BillDetailCellModel.h
//  company
//
//  Created by Eugene on 16/6/27.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Record,Tradestatus,Tradetype;
@interface BillDetailCellModel : NSObject



@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) Record *record;

@property (nonatomic, assign) BOOL isShow;

@end
@interface Record : NSObject

@property (nonatomic, assign) NSInteger amount;

@property (nonatomic, assign) NSInteger tradeId;

@property (nonatomic, copy) NSString *tradeDate;

@property (nonatomic, strong) Tradetype *tradetype;

@property (nonatomic, copy) NSString *tradeCode;

@property (nonatomic, strong) Tradestatus *tradestatus;

@end

@interface Tradestatus : NSObject

@property (nonatomic, copy) NSString *name;

@end

@interface Tradetype : NSObject

@property (nonatomic, copy) NSString *name;

@end

