//
//  UISlider+_touch.m
//  company
//
//  Created by Eugene on 2016/9/26.
//  Copyright © 2016年 Eugene. All rights reserved.
//

#import "UISlider+_touch.h"
#import <objc/runtime.h>

static char *gestureKey;
static char *targetKey;
static char *actionStringKey;

@implementation UISlider (_touch)

- (void)addTapGestureWithTarget: (id)target action: (SEL)action
{
    id gesture =  objc_getAssociatedObject(self, &gestureKey);
    if (!gesture) {
        objc_setAssociatedObject(self, &targetKey, target, OBJC_ASSOCIATION_ASSIGN);
        objc_setAssociatedObject(self, &actionStringKey, NSStringFromSelector(action), OBJC_ASSOCIATION_RETAIN);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action: @selector(tap:)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
        objc_setAssociatedObject(self, &gestureKey, tap, OBJC_ASSOCIATION_RETAIN);
    }
}

- (void)tap: (UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationInView:self];
        float x = location.x;
        float r = x/self.frame.size.width;
        float value = (self.maximumValue-self.minimumValue) * r;
        [self setValue:value animated:YES];
        id target = objc_getAssociatedObject(self, &targetKey);
        if (target) {
            NSString *actionStr = objc_getAssociatedObject(self, &actionStringKey);
            SEL action  = NSSelectorFromString(actionStr);
            
            [target performSelector:action withObject:self];
        }
    }
}

- (void)dealloc
{
    UITapGestureRecognizer *tap;
    id gesture =  objc_getAssociatedObject(self, &gestureKey);
    if (gesture) {
        tap = (UITapGestureRecognizer*)gesture;
        [self removeGestureRecognizer:tap];
    }
}

@end
