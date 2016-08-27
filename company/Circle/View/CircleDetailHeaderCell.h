//
//  CircleDetailHeaderCell.h
//  company
//
//  Created by Eugene on 16/6/12.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleListModel.h"
#import "CircleContentView.h"

@class CircleDetailHeaderCell;


@protocol CircleDetailHeaderCellDelegate <NSObject>

-(void)didClickPraiseBtn:(CircleDetailHeaderCell*)cell model:(CircleListModel*)model;

-(void)didClickContentBtnInCell:(CircleDetailHeaderCell*)cell andModel:(CircleListModel*)model;

@end

@interface CircleDetailHeaderCell : UITableViewCell<CircleContentViewDelegate>


@property (nonatomic, weak) id<CircleDetailHeaderCellDelegate>delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) CircleListModel *model;
@property (nonatomic, strong) UIButton *praiseBtn;

@end
