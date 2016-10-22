//
//  TankModel.h
//  company
//
//  Created by Eugene on 2016/10/18.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ContentType : NSObject

@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, copy) NSString *name;
@end

@interface TankModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *oringl;
@property (nonatomic, copy) NSString *publicDate;
@property (nonatomic, strong) ContentType *webcontentType;
@property (nonatomic, strong) NSArray *images;


@end
