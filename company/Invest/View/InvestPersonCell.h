//
//  InvestPersonCell.h
//  JinZhiT
//
//  Created by Eugene on 16/5/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "InvestListModel.h"
@class InvestPersonCell;

@protocol InvestPersonCellDelegate <NSObject>

-(void)didClickCommitBtn:(InvestPersonCell*)cell andModel:(InvestListModel*)model andIndexPath:(NSIndexPath*)indexPath;

-(void)didClickAttentionBtn:(InvestPersonCell*)cell andModel:(InvestListModel*)model andIndexPath:(NSIndexPath*)indexPath;

@end


@interface InvestPersonCell : UITableViewCell

@property (nonatomic, weak) id<InvestPersonCellDelegate>delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) InvestListModel *model;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet UIButton *middleBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *name;


@property (weak, nonatomic) IBOutlet UILabel *position;

@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *companyAddress;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnArray;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIButton *cimmitBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *companyNameWidth;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
