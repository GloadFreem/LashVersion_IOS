//
//  ProjectLetterModel.h
//  JinZhiT
//
//  Created by Eugene on 16/5/21.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectLetterModel : NSObject

@property (nonatomic, copy) NSString *iconImage;
@property (nonatomic, copy) NSString *titleLabel ;
@property (nonatomic, copy) NSString *secondTitle;

@property (nonatomic, assign) BOOL selectedStatus;


@end
