//
//  ActionComment.h
//  company
//
//  Created by air on 16/6/14.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class commentUser;
@interface ActionComment : NSObject



@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) NSInteger commentId;

@property (nonatomic, strong) commentUser *usersByUserId;


@end
@interface commentUser : NSObject

@property (nonatomic, assign) NSInteger userId;

@end

