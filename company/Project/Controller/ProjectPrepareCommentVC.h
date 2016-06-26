//
//  ProjectPrepareCommentVC.h
//  company
//
//  Created by Eugene on 16/6/21.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProjectPrepareFooterCommentView.h"

@interface ProjectPrepareCommentVC : RootViewController

@property (nonatomic, assign) NSInteger projectId;

@property (nonatomic, assign) NSInteger sceneId;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) ProjectPrepareFooterCommentView *footerCommentView;

@end
