//
//  MineGoldMingxiCell.h
//  JinZhiT
//
//  Created by Eugene on 16/5/24.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineGoldMingxiModel.h"
@interface MineGoldMingxiCell : UITableViewCell
{
    UIView *_topContainerView;
    
}
@property (nonatomic, strong) UIImageView *topLine;
@property (nonatomic, strong) MineGoldMingxiModel*model;



@end
