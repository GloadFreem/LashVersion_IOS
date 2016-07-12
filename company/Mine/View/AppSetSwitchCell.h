//
//  AppSetSwitchCell.h
//  JinZhiT
//
//  Created by Eugene on 16/5/25.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppSetSwitchCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UILabel *titlelabel;


@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;

@end
