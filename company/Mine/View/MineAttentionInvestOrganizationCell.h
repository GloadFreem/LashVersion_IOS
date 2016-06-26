//
//  MineAttentionInvestOrganizationCell.h
//  JinZhiT
//
//  Created by Eugene on 16/5/23.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MineCollectionListModel.h"

@interface MineAttentionInvestOrganizationCell : UITableViewCell

@property (nonatomic, strong) MineCollectionListModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnArray;

@end
