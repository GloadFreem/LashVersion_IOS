//
//  ActivityBlackCoverView.h
//  company
//
//  Created by Eugene on 16/6/16.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActivityBlackCoverView;

@protocol ActivityBlackCoverViewDelegate <NSObject>

-(void)clickBtnInBlackView:(ActivityBlackCoverView*)view andIndex:(NSInteger)index content:(NSString*)content;

@end

@interface ActivityBlackCoverView : UIView
@property (strong, nonatomic) IBOutlet UIView *backView;

@property (nonatomic, weak) id<ActivityBlackCoverViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextView *textView;


@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@property (weak, nonatomic) IBOutlet UIButton *certainBtn;

+(ActivityBlackCoverView*)instancetationActivityBlackCoverView;

@end
