//
//  MineActivityListModel.h
//  company
//
//  Created by Eugene on 16/6/15.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineActivityListModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, assign) NSInteger memberLimit;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *distance;

@end
