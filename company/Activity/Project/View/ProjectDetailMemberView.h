//
//  ProjectDetailMemberView.h
//  JinZhiT
//
//  Created by Eugene on 16/5/13.
//  Copyright © 2016年 Eugene. All rights reserved.
//


//---------------------------------详情页成员分页视图--------------------------


#import <UIKit/UIKit.h>

@interface ProjectDetailMemberView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;//头像
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;//职位
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//名字

@property (weak, nonatomic) IBOutlet UILabel *emailLabel;//邮箱

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;//电话

@property (weak, nonatomic) IBOutlet UILabel *companyType;//公司类型




@property (assign, nonatomic) CGFloat viewHeight;


+(ProjectDetailMemberView*)instancetationProjectDetailMemberView;
@end
