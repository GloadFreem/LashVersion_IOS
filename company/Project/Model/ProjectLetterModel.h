//
//  ProjectLetterModel.h
//  JinZhiT
//
//  Created by Eugene on 16/5/21.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectLetterModel : NSObject


@property (nonatomic, copy) NSString *title ;
@property (nonatomic, copy) NSString *secondTitle;
@property (nonatomic, copy) NSString *time;

@property (nonatomic, assign) BOOL selectedStatus;


@end
