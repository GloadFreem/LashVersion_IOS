//
//  ZMView.m
//  进度视图01-15
//
//  Created by 张志敏 on 16/1/15.
//  Copyright © 2016年 张志敏. All rights reserved.
//

#import "ZMProgressView.h"
#define angle2Arc(angle) (angle * M_PI /180)
//设置文字缩放比例
#define FontScale MIN(self.bounds.size.height, self.bounds.size.width)/100.f
@interface ZMProgressView ()

/**
 *  弧度
 */
@property (nonatomic,assign)CGFloat angle;

/**
 *  圆心
 */
@property (nonatomic,assign)CGPoint circleCenter;

/**
 *  屏帧定时器
 */
@property (nonatomic,strong)CADisplayLink *link;


/**
 *  定时器变量
 */
@property (nonatomic,assign)CGFloat value;

/**
 *  中间变量，用于动画时候数字的变化
 */
@property (nonatomic,assign)CGFloat desValue ;


@end

@implementation ZMProgressView


-(instancetype)init{
    if (self = [super init]) {
        [self defaultColor];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self defaultColor];
    }
    return self;
}

-(instancetype)initWithLineColor:(UIColor*)lineColor
                       loopColor:(UIColor*)loopColor{
    if (self = [super init]) {
        self.lineColor = lineColor;
        self.loopColor = loopColor;
    }
    return self;
}

-(void)defaultColor{
    _lineColor = orangeColor;
    _loopColor = btnCray;
}

- (void)drawRect:(CGRect)rect {

    _circleCenter = CGPointMake(rect.size.width*0.5 , rect.size.height*0.5 );
    
    CGFloat radius = MIN(rect.size.height, rect.size.width) * 0.5;
    
    //画内圆
    UIBezierPath* arc2 = [UIBezierPath bezierPathWithArcCenter:_circleCenter
                                                        radius:radius*0.9
                                                    startAngle:0
                                                      endAngle:2*M_PI
                                                     clockwise:YES];
    [arc2 setLineWidth:radius*0.15];
    [self.loopColor set];

    [arc2 stroke];
  
    //画弧线
    UIBezierPath* path = [UIBezierPath
                          bezierPathWithArcCenter:_circleCenter
                          radius:radius*0.9
                          startAngle:M_PI_2
                          endAngle:angle2Arc(self.angle)+M_PI_2
                          clockwise:YES];
    [self.lineColor set];
    [path setLineCapStyle:kCGLineCapRound];
    path.lineWidth = radius* 0.11;
    [path stroke];
    
    CGPoint StartCircleCenter  = CGPointMake(_circleCenter.x + radius*0.9 * cosf(M_PI_2),
                                             _circleCenter.y + radius*0.9 * sinf(M_PI_2));
    UIBezierPath* startCircle = [UIBezierPath
                                 bezierPathWithArcCenter:StartCircleCenter
                                 radius:radius*0.09
                                 startAngle:0
                                 endAngle:2*M_PI
                                 clockwise:YES];
    
    [startCircle fill];
    
    [self drawText];
   
    
}

/**
 *  绘制文字
 */
-(void)drawText{
    
    //绘制标题
    NSMutableAttributedString* title = [[NSMutableAttributedString alloc] initWithString:self.title];
    NSRange titleRange = NSMakeRange(0, title.string.length);
    [title addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:10]
                  range:titleRange];
    
    [title addAttribute:NSForegroundColorAttributeName
                  value:self.titleColor
                  range:titleRange];
    
    CGRect titleRect = [title boundingRectWithSize:self.bounds.size
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                           context:nil];
    
    CGFloat titleX = _circleCenter.x  - titleRect.size.width * 0.5;
    CGFloat titleY = _circleCenter.y -  titleRect.size.height * 1.5;
    
    [title drawAtPoint:CGPointMake(titleX, titleY)];

    //
    NSMutableAttributedString* precentStr;
    if(_percent-_desValue>=1)
    {
        precentStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.0f%@",_desValue,self.percentUnit]];
    }else{
        precentStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.0f%@",_percent,self.percentUnit]];
    }
    NSRange precentRange = NSMakeRange(0, precentStr.string.length);
    
    [precentStr addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:15]
                       range:precentRange];
    
    [precentStr addAttribute:NSForegroundColorAttributeName
                       value:self.percentColor
                       range:precentRange];
    
    CGRect precentRect = [precentStr boundingRectWithSize:self.bounds.size
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                  context:nil];
    
    CGFloat precentX = _circleCenter.x - precentRect.size.width * 0.5;
    CGFloat precentY = _circleCenter.y - 2;
    
    [precentStr drawAtPoint:CGPointMake(precentX, precentY)];
}



-(void)setPercent:(CGFloat)precent{
    if (precent>100) {
        precent = 100;
    }
    _percent = precent;
   
    if (self.animatable) {
        self.link.paused = NO;
    }else{
         _angle = _percent /100 * 360;
        _desValue = _percent;
        [self setNeedsDisplay];
    }
}


/**
 *  屏帧动画
 */
-(void)animateprecent{
    if (self.value < self.percent) {
        
        self.value ++;
        _desValue = _value;
        _angle = self.value /100.0 * 360;
        
        [self setNeedsDisplay];
    }
    else{
        self.link.paused = YES;
        self.value = 0;
    }
}



#pragma makr - 懒加载定时器
-(CADisplayLink *)link{
    if (_link == nil && self.animatable == YES) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(animateprecent)];
        _link.frameInterval = 1 ;
        [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _link;
}

#pragma mark - 设置默认颜色
-(UIColor *)titleColor{
    if (_titleColor == nil) {
        _titleColor = [UIColor darkTextColor];
    }
    return _titleColor;
}

-(UIColor*)percentColor{
    if (_percentColor == nil) {
        _percentColor = orangeColor;
    }
    return _percentColor;
}

#pragma mark - 懒加载title
-(NSString *)title{
    if (_title == nil) {
        _title = @"";
    }
    return _title;
}

#pragma mark - 懒加载单位
-(NSString *)percentUnit{
    if (_percentUnit == nil) {
        _percentUnit = @"";
    }
    return _percentUnit;
}

-(void)dealloc{
    [self.link invalidate];
    self.link = nil;
    NSLog(@"dealloc");
}



@end
