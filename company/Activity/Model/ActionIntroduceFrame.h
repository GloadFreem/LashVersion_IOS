//
//  ActionIntroduceFrame.h
//  company
//
//  Created by LiLe on 16/8/25.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ActionIntroduce;

@interface ActionIntroduceFrame : NSObject

@property (nonatomic, strong) ActionIntroduce *actionIntro;

/** 活动介绍的文字 */
@property (nonatomic, assign, readonly) CGRect contextLF;

/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

/** tableView的高度 */
@property (nonatomic, assign) CGFloat tableViewH;

@end
