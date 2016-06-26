//
//  ProjectPrepareHeaderCell.h
//  company
//
//  Created by Eugene on 16/6/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectPrepareDetailHeaderModel.h"
@interface ProjectPrepareHeaderCell : UITableViewCell

@property (nonatomic, strong) ProjectPrepareDetailHeaderModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *projectImage;


@property (weak, nonatomic) IBOutlet UILabel *projectLabel;

@property (weak, nonatomic) IBOutlet UILabel *companyLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end
