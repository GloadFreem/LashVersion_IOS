//
//  ActionDetailModel.h
//  company
//
//  Created by air on 16/6/14.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Actionimages;

@interface ActionDetailModel : NSObject
@property (nonatomic, strong) NSArray<NSString *> *actionprises;

@property (nonatomic, copy) NSString * startPageImage;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic ,assign)NSString * address;
@property (nonatomic, copy) NSString * endTime;

@property (nonatomic, assign) NSInteger memberLimit;

@property (nonatomic, assign) Boolean flag;

@property (nonatomic, assign) NSInteger actionId;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *startTime;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) Boolean attended;
@property (nonatomic, strong) NSArray<Actionimages *> *actionimages;
@property (nonatomic, strong) NSArray *actionintroduces;
@end



@interface Actionimages : NSObject

@property (nonatomic, assign) NSInteger imgId;

@property (nonatomic, copy) NSString *url;

@end


//@interface Actionintroduces : NSObject
///** 序号 */
//@property (nonatomic, assign) NSInteger introduceId;
///** 类型：0为文字，1为图片 */
//@property (nonatomic, assign) NSInteger type;
///** 文字内容或图片链接 */
//@property (nonatomic, copy) NSString *content;
//
//@end

