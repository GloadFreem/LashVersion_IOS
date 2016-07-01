//
//  ProjectLetterCell.h
//  JinZhiT
//
//  Created by Eugene on 16/5/21.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectLetterModel.h"

#import "LetterBaseModel.h"
@interface ProjectLetterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTitle;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeftSpace;
@property (weak, nonatomic) IBOutlet UIImageView *redPointImage;

//@property (nonatomic, strong) ProjectLetterModel *model;     //

@property (nonatomic, strong) LetterBaseModel *model;

-(void)relayoutCellWithModel:(LetterBaseModel*)model;


@end
