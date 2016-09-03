//
//  ShareToCircleView.m
//  company
//
//  Created by Eugene on 16/8/26.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "ShareToCircleView.h"

@implementation ShareToCircleView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self= [super initWithFrame:frame]) {
        
    }
    return self;
}
-(void)instancetationShareToCircleViewWithimage:(NSString*)image title:(NSString*)title content:(NSString*)content
{
    _titleLabel.text = title;
    _contentLabel.text = content;
//    NSLog(@"%@",content);
    [_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",image]] placeholderImage:[UIImage imageNamed:@"placeholderImage"]];
    
}

-(void)awakeFromNib
{
    _cancleBtn.layer.borderColor = colorGray.CGColor;
    _cancleBtn.layer.borderWidth = 0.5;
    _certainBtn.layer.borderColor = colorGray.CGColor;
    _certainBtn.layer.borderWidth = 0.5;
    
}

- (IBAction)btnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnInView:andIndex:content:)]) {
        [self.delegate clickBtnInView:self andIndex:sender.tag content:_textView.text];
        
        [_textView resignFirstResponder];
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
