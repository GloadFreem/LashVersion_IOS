//
//  ActivityDetailCommentCellModel.h
//  JinZhiT
//
//  Created by Eugene on 16/5/21.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ActivityDetailCellLikeItemModel, ActivityDetailCellCommentItemModel;

@interface ActivityDetailCommentCellModel : NSObject


@property (nonatomic, strong) NSMutableArray<ActivityDetailCellLikeItemModel*> *likeItemsArray;
@property (nonatomic, strong) NSMutableArray<ActivityDetailCellCommentItemModel*> *commentItemsArray;

@end

@interface ActivityDetailCellLikeItemModel: NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userId;

@end


@interface ActivityDetailCellCommentItemModel :NSObject

@property (nonatomic, copy) NSString *commentString;

@property (nonatomic, copy) NSString *firstUserName;
@property (nonatomic, copy) NSString *firstUserId;

@property (nonatomic, copy) NSString *secondUserName;
@property (nonatomic, copy) NSString *secondUserId;

@property (nonatomic, assign) NSInteger commentId;
@end