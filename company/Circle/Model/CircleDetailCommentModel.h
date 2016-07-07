//
//  CircleDetailCommentModel.h
//  JinZhiT
//
//  Created by Eugene on 16/6/1.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CircleDetailCommentModel : NSObject

@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic, copy) NSString *iconImageStr;
@property (nonatomic, copy) NSString *nameStr;

@property (nonatomic, copy) NSString *contentStr;
@property (nonatomic, copy) NSString *publicDate;

@end
