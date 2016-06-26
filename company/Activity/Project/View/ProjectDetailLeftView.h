//
//  ProjectDetailLeftView.h
//  JinZhiT
//
//  Created by Eugene on 16/5/14.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectDetailLeftView : UIView<UITableViewDelegate, UITableViewDataSource>


@property (nonatomic, assign) CGFloat height;

-(CGFloat)calculateHeight;

@end