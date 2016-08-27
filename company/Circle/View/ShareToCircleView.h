//
//  ShareToCircleView.h
//  company
//
//  Created by Eugene on 16/8/26.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShareToCircleView;

@protocol ShareToCircleViewDelegate <NSObject>

-(void)clickBtnInView:(ShareToCircleView*)view andIndex:(NSInteger)index content:(NSString*)content;


@end


@interface ShareToCircleView : UIView

@property (nonatomic, weak) id<ShareToCircleViewDelegate>delegate;


@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@property (weak, nonatomic) IBOutlet UIButton *certainBtn;

-(void)instancetationShareToCircleViewWithimage:(NSString*)image title:(NSString*)title content:(NSString*)content;


@end
