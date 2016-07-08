//
//  ProjectPrepareHeaderCell.m
//  company
//
//  Created by Eugene on 16/6/17.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectPrepareHeaderCell.h"

@implementation ProjectPrepareHeaderCell




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _projectImage.layer.cornerRadius =43;
    _projectImage.layer.masksToBounds = YES;
    _projectImage.layer.borderColor = [UIColor whiteColor].CGColor;
    _projectImage.layer.borderWidth = 3;
}

-(void)setModel:(ProjectPrepareDetailHeaderModel *)model
{
    _model = model;
    
    [_projectImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.startPageImage]] placeholderImage:[UIImage imageNamed:@"placeholderIcon"]];
    _projectLabel.text = model.abbrevName;
    _companyLabel.text = model.fullName;
    _addressLabel.text = model.address;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
