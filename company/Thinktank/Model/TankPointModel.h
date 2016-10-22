//
//  TankPointModel.h
//  company
//
//  Created by Eugene on 2016/10/22.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface contentType : NSObject

@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, copy) NSString *name;

@end

@interface TankPointModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *publicDate;
@property (nonatomic, copy) NSString *oringl;
@property (nonatomic, assign) NSInteger tag;

@property (nonatomic, strong) contentType *webcontenttype;

@property (nonatomic, strong) NSArray *originalImgs;

@property (nonatomic, assign) NSInteger infoId;


@end
