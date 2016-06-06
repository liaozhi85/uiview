//
//  drawBp.m
//  bpAndHr
//
//  Created by 唐晟炜 on 16/5/24.
//  Copyright © 2016年 廖智. All rights reserved.
//

#import "drawBp.h"
@interface drawBp ()
@property (nonatomic,strong)NSValue *bpPoint;
@end
@implementation drawBp
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.arrayBpPoint = [[NSMutableArray alloc] initWithCapacity:501];
        self.backgroundColor = [UIColor whiteColor];
        self.ima = [UIImage imageNamed:@"bp.png"];//设置背景图片
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self.ima drawInRect:rect];
    if (self.arrayBpPoint.count != 0) {
    CGContextRef conf = UIGraphicsGetCurrentContext();
    /* 以下为实时血压图*/
    CGContextSaveGState(conf);
    UIColor *lineColor = [UIColor colorWithRed:0 green:255.f/255.f blue:0 alpha:1];//设置柱形的颜色。
    CGContextSetFillColorWithColor(conf, lineColor.CGColor);
    self.bpPoint = [self.arrayBpPoint objectAtIndex:0];
    CGContextMoveToPoint(conf, [self.bpPoint CGPointValue].x, [self.bpPoint CGPointValue].y);
    CGContextAddLineToPoint(conf, [self.bpPoint CGPointValue].x, self.frame.size.height*(457.0/500));
    CGContextAddLineToPoint(conf, [self.bpPoint CGPointValue].x+self.frame.size.width*(10.0/100), self.frame.size.height*(457.0/500));
    CGContextAddLineToPoint(conf, [self.bpPoint CGPointValue].x+self.frame.size.width*(10.0/100), [self.bpPoint CGPointValue].y);
    CGContextDrawPath(conf, kCGPathFill);
    CGContextRestoreGState(conf);
        
    }
                            
}

- (void)clearBp {
    [self.arrayBpPoint removeAllObjects];
}


@end
