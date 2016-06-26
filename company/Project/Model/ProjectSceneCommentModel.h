//
//  ProjectSceneCommentModel.h
//  company
//
//  Created by Eugene on 16/6/19.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CommentUsers;
@interface ProjectSceneCommentModel : NSObject



@property (nonatomic, assign) BOOL flag;

@property (nonatomic, strong) CommentUsers *users;

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSString *commentDate;

@property (nonatomic, assign) NSInteger commentId;




@end

@interface CommentUsers : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, copy) NSString *headSculpture;

@end

