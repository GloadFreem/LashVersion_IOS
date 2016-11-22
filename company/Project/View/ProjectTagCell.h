//
//  ProjectTagCell.h
//  company
//
//  Created by Eugene on 2016/11/21.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKTagView.h"
@interface ProjectTagCell : UITableViewCell

@property (nonatomic, strong) SKTagView *tagView;
@property (nonatomic, strong) UILabel *categoryLabel;

@property (nonatomic, assign) CGFloat cellHeight;

-(CGFloat)getCellHeight;

@end
