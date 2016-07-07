//
//  CircleListCell.h
//  JinZhiT
//
//  Created by Eugene on 16/5/26.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleListModel.h"

@class CircleListCell;
@protocol CircleListCellDelegate <NSObject>

-(void)didClickShareBtnInCell:(CircleListCell*)cell andModel:(CircleListModel*)model;
-(void)didClickCommentBtnInCell:(CircleListCell*)cell andModel:(CircleListModel*)model andIndexPath:(NSIndexPath*)indexPath;
-(void)didClickPraiseBtnInCell:(CircleListCell*)cell andModel:(CircleListModel*)model andIndexPath:(NSIndexPath*)indexPath;

-(void)didClickDeleteInCell:(CircleListCell*)cell andModel:(CircleListModel*)model andIndexPath:(NSIndexPath*)indexPath;

@end

@interface CircleListCell : UITableViewCell

@property (nonatomic, weak) id<CircleListCellDelegate> delegate;

@property (nonatomic, strong)  CircleListModel *model;
//
@property (nonatomic, strong) NSIndexPath *indexPath;    //
@property (nonatomic, copy) void (^moreButtonClickedBlock)(NSIndexPath*indexPath);  //
@property (nonatomic, strong) UIButton *praiseBtn;

@property (nonatomic, strong) UIButton *deleteBtn;
@end
