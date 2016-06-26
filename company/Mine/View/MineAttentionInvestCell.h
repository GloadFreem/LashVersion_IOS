//
//  MineAttentionInvestCell.h
//  JinZhiT
//
//  Created by Eugene on 16/5/23.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineCollectionListModel.h"


@interface MineAttentionInvestCell : UITableViewCell

@property (nonatomic, strong) MineCollectionListModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *position;

@property (weak, nonatomic) IBOutlet UIImageView *statusImage;
@property (weak, nonatomic) IBOutlet UILabel *company;

@property (weak, nonatomic) IBOutlet UILabel *address;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonArray;

@end
