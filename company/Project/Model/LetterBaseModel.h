//
//  LetterBaseModel.h
//  company
//
//  Created by Eugene on 16/6/30.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Messagetype;
@interface LetterBaseModel : NSObject



@property (nonatomic, assign) NSInteger messageId;

@property (nonatomic, strong) Messagetype *messagetype;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) BOOL isRead;

@property (nonatomic, copy) NSString *messageDate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, assign) BOOL selectedStatus;

@end
@interface Messagetype : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger messageTypeId;

@end

