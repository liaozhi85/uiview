//
//  drawHr.m
//  bpAndHr
//
//  Created by 唐晟炜 on 16/5/24.
//  Copyright © 2016年 廖智. All rights reserved.
//

#import "drawHr.h"
@interface drawHr ()
@property (nonatomic,strong)NSValue *HrPoint1;
@property (nonatomic,strong)NSValue *HrPoint2;
@property (nonatomic,strong)NSValue *HrPoint3;
@end
@implementation drawHr
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.arrayHrPoint = [[NSMutableArray alloc] initWithCapacity:501];
        self.backgroundColor = [UIColor whiteColor];
        self.ima = [UIImage imageNamed:@"方格图.jpg"];//设置背景图片
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self.ima drawInRect:rect];
    CGContextRef conf = UIGraphicsGetCurrentContext();
    if (self.arrayHrPoint.count != 0) {
        
    /* 此部分给波形图增加渐变色（诺不需要，可注释）*/
        
    if ([self.arrayHrPoint count] > 1 ) {
        CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
        CGFloat colors[] =
        {
            0,1,0, 0.5,
            1,1,1, 0.5,
        };//设置渐变颜色：RGB值的表示，R为红，G为绿，B为蓝。0.5表示透明度
        CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colors, NULL, sizeof(colors)/(sizeof(colors[0])*4));//创建RGB渐变色:参数含义，用RGB值创建2种渐变色的空间。
        CGColorSpaceRelease(rgb);//只要用了create，new的就要release。
        
        CGContextSaveGState(conf);
        self.HrPoint1 = [self.arrayHrPoint objectAtIndex:0];
        CGContextMoveToPoint(conf, [self.HrPoint1 CGPointValue].x, [self.HrPoint1 CGPointValue].y);
        
        for (int i=1; i < self.arrayHrPoint.count; i++) {
            self.HrPoint2 = [self.arrayHrPoint objectAtIndex:i];
            CGContextAddLineToPoint(conf, [self.HrPoint2 CGPointValue].x,[self.HrPoint2 CGPointValue].y);
        }
        
        CGContextAddLineToPoint(conf, [self.HrPoint2 CGPointValue].x,self.frame.size.height);
        CGContextAddLineToPoint(conf, [self.HrPoint1 CGPointValue].x,self.frame.size.height);
        CGContextClip(conf);
        CGContextDrawLinearGradient(conf, gradient, CGPointMake(0, 0), CGPointMake(0, self.frame.size.height), kCGGradientDrawsAfterEndLocation);
        CGContextRestoreGState(conf);
    }
     /* 以上部分给波形图增加渐变色（诺不需要，可注释）*/
     
     /* 以下部分为画实时心率图*/
        UIColor *lineColor = [UIColor colorWithRed:0 green:255.f/255.f blue:0 alpha:1];//设置线的颜色。
        CGContextSaveGState(conf);
        CGContextSetAllowsAntialiasing(conf,false);//是否消除锯齿
        CGContextSetLineWidth(conf,1.5f);//设置线的宽度
        CGContextSetStrokeColorWithColor(conf, lineColor.CGColor);//设置线条颜色
        CGContextBeginPath(conf);
        
        self.HrPoint1 = [self.arrayHrPoint objectAtIndex:0];
        CGContextMoveToPoint(conf, [self.HrPoint1 CGPointValue].x, [self.HrPoint2 CGPointValue].y);
        
        
    for (int i=1; i < self.arrayHrPoint.count; i++) {
       
        self.HrPoint2 = [self.arrayHrPoint objectAtIndex:i];
        CGContextAddLineToPoint(conf, [self.HrPoint2 CGPointValue].x, [self.HrPoint2 CGPointValue].y);
        
        CGPoint p = CGPointMake([self.HrPoint2 CGPointValue].x-(self.frame.size.width*(2.5/240)), [self.HrPoint2 CGPointValue].y);
        self.HrPoint2 = [NSValue valueWithCGPoint:p];
        [self.arrayHrPoint replaceObjectAtIndex:i withObject:self.HrPoint2];
    }
    CGContextDrawPath(conf, kCGPathStroke);//绘制路径
    CGContextRestoreGState(conf);
    
    CGPoint p = CGPointMake([self.HrPoint1 CGPointValue].x-(self.frame.size.width*(2.5/240)), [self.HrPoint1 CGPointValue].y);
    self.HrPoint1 = [NSValue valueWithCGPoint:p];
    [self.arrayHrPoint replaceObjectAtIndex:0 withObject:self.HrPoint1];
    }
    
}
-(void)clearHr {
    [self.arrayHrPoint removeAllObjects];
}

@end
