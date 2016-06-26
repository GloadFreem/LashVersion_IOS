//
//  ActivityCell.h
//  JinZhiT
//
//  Created by Eugene on 16/5/19.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityViewModel.h"
@protocol ActivityViewDelegate <NSObject>

-(void)attendAction:(id)model;

@end

@interface ActivityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIButton *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *countlabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UIButton *signUpBtn;

@property (weak, nonatomic) IBOutlet UIImageView *expiredImage;

@property(weak,nonatomic)ActivityViewModel * model;

@property(nonatomic,retain) id delegate;
@end

