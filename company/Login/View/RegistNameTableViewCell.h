//
//  RegistNameTableViewCell.h
//  JinZhiT
//
//  Created by Eugene on 16/5/6.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface RegistNameTableViewCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UIButton *leftButton;

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint * rightLabelHeight;



-(CGFloat)getCellHeight;

@end
