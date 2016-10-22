//
//  TankHeaderModel.h
//  company
//
//  Created by Eugene on 2016/10/20.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contenttype : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger typeId;

@end

@interface Webcontenttype : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger typeId;

@end

@interface TankHeaderModel : NSObject

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, assign) NSInteger flag;
@property (nonatomic, copy) NSString *orignal;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, assign) NSInteger recordId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) Contenttype *contenttype;
@property (nonatomic, strong) Webcontenttype *webcontenttype;
@property (nonatomic, strong) NSArray *webcontentimageses;

@end
