//
//  ProjectPreparePhotoView.h
//  company
//
//  Created by Eugene on 16/7/6.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ProjectDetailLeftHeaderModel.h"

@interface ProjectPreparePhotoView : UIView

@property (nonatomic, strong) ProjectDetailLeftHeaderModel *model;

@property (nonatomic, copy) void (^moreButtonClickedBlock)(Boolean flag);

@end
