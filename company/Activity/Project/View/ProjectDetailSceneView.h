//
//  ProjectDetailSceneView.h
//  JinZhiT
//
//  Created by Eugene on 16/5/16.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectDetailSceneView : UIView<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end
