//
//  IdentityTableViewCell.h
//  JinZhiT
//
//  Created by Eugene on 16/5/6.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IdentityTableViewCell;
@protocol IdentityTableViewCellDelegate <NSObject>

-(void)didClickBtnInCell:(IdentityTableViewCell*)cell andTag:(NSInteger)tag;


@end



@interface IdentityTableViewCell : UITableViewCell

@property (nonatomic, assign) id<IdentityTableViewCellDelegate>delegate;

@property (nonatomic, strong) UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;


@end
