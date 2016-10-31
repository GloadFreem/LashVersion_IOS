//
//  UITableViewCustomView.m
//  company
//
//  Created by Eugene on 16/8/12.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "UITableViewCustomView.h"

@interface UITableViewCustomView ()
{
    UIView* view;
    UILabel* label;
    UIImageView* emptyImgView;
}

@end

@implementation UITableViewCustomView

-(void)setIsNone:(BOOL)isNone
{
    self->_isNone = isNone;
    if (isNone) {
        view = [self viewWithTag:100001];
        if (!view) {
            view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH(self), HEIGHT(self))];
            view.tag = 100001;
            CGFloat height = HEIGHT(self)/2-140;
//            NSLog(@"打印---%f",height);
            if (height < 0) {
                height = 25.0*HEIGHTCONFIG;
            }
            emptyImgView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH(self)/2-75, height, 150, 115)];
            emptyImgView.image = [UIImage imageNamed:@"noData"];
            emptyImgView.contentMode = UIViewContentModeScaleAspectFill;
            [view addSubview:emptyImgView];
            [self addSubview:view];
        }
        self.separatorStyle = UITableViewCellSelectionStyleNone;
        view.alpha = 1;
    }else{
        view = [self viewWithTag:100001];
        if (view) {
            view.alpha = 0;
        }
        self.separatorStyle = UITableViewCellSelectionStyleNone;
    }
}

-(void)setEmptyImgFileName:(NSString *)emptyImgFileName
{
    self->_emptyImgFileName = emptyImgFileName;
    if ([TDUtil isValidString:self.emptyImgFileName]) {
        emptyImgView.image  = IMAGE(self.emptyImgFileName, @"png");
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
