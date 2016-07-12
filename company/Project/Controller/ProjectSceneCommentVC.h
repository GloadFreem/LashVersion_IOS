//
//  ProjectSceneCommentVC.h
//  company
//
//  Created by Eugene on 16/6/21.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectDetailSceneView.h"

@interface ProjectSceneCommentVC : RootViewController

@property (nonatomic, assign) NSInteger sceneId;
@property (nonatomic, copy) NSString *scenePartner;

@property (nonatomic, strong) ProjectDetailSceneView *scene;

@property (nonatomic, copy) NSString *authenticName;
@property (nonatomic, copy) NSString *identiyTypeId;

@end
