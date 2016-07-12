//
//  ProjectPrepareDetailHeaderView.m
//  company
//
//  Created by Eugene on 16/6/22.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ProjectPrepareDetailHeaderView.h"

@implementation ProjectPrepareDetailHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self createUI];
    }
    return self;
    
}


-(void)createUI
{
    self.backgroundColor = color(61, 153, 130, 1);
    
    _icon = [UIImageView new];
    _icon.layer.cornerRadius = 43;
    _icon.layer.masksToBounds = YES;
    _icon.layer.borderColor = [UIColor whiteColor].CGColor;
    _icon.layer.borderWidth = 3;
    _icon.contentMode = UIViewContentModeScaleAspectFill;
    
    _projectName = [UILabel new];
    _projectName.font = BGFont(18);
    _projectName.textColor = [UIColor whiteColor];
    _projectName.textAlignment = NSTextAlignmentCenter;
    
    _companyName = [UILabel new];
    _companyName.font = BGFont(15);
    _companyName.textColor = [UIColor whiteColor];
    _companyName.textAlignment = NSTextAlignmentCenter;
    
    _address = [UILabel new];
    _address.font = BGFont(15);
    _address.textAlignment = NSTextAlignmentCenter;
    _address.textColor = [UIColor whiteColor];
    
    NSArray *views = @[_icon, _projectName, _companyName, _address];
    
    [self sd_addSubviews:views];
    
    _icon.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(self,8)
    .widthIs(86)
    .heightIs(86);
    
    _projectName.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(_icon,15)
    .heightIs(18);
    [_projectName setSingleLineAutoResizeWithMaxWidth:150];
    
    _companyName.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(_projectName,10)
    .heightIs(15);
    [_companyName setSingleLineAutoResizeWithMaxWidth:200];
    
    _address.sd_layout
    .centerXEqualToView(self)
    .topSpaceToView(_companyName,10)
    .heightIs(15);
    [_address setSingleLineAutoResizeWithMaxWidth:150];
    
    [self setupAutoHeightWithBottomView:_address bottomMargin:17];
    
}

-(void)setModel:(ProjectDetailBaseMOdel *)model
{
    _model = model;
    [_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.project.startPageImage]] placeholderImage:[UIImage imageNamed:@"placeholderIcon"]];
    
    _projectName.text = model.project.abbrevName;
    _companyName.text = model.project.fullName;
    _address.text = model.project.address;
    
}
@end
