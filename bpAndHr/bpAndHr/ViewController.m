//
//  ViewController.m
//  bpAndHr
//
//  Created by 唐晟炜 on 16/5/24.
//  Copyright © 2016年 廖智. All rights reserved.
//

#import "ViewController.h"
#import "drawHr.h"
#import "drawBp.h"
@interface ViewController ()
@property (nonatomic,assign)CGRect drawHrFrame;
@property (nonatomic,assign)CGRect drawBpFrame;
@property (nonatomic,strong)NSTimer *timerHr;
@property (nonatomic,strong)NSTimer *timerBp;
@property (nonatomic,strong)drawHr *drawH;
@property (nonatomic,strong)drawBp *drawB;

- (IBAction)start:(UIButton *)btn;
- (IBAction)stop:(UIButton *)btn;
@end

@implementation ViewController
- (CGRect)drawHrFrame {
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    float bili[4] = {80.0/320.0,40.0/568.0,240.0/320.0,120.0/568.0};

    CGRect frame = CGRectMake(screenFrame.size.width*bili[0], screenFrame.size.height*bili[1], screenFrame.size.width*bili[2], screenFrame.size.height*bili[3]);
    
    return frame;
}
- (CGRect)drawBpFrame {
    CGRect screenFrame = [UIScreen mainScreen].bounds;
    float bili[3] = {30.0/568.0,100.0/320.0,500.0/568.0};
    CGRect frame = CGRectMake(0, screenFrame.size.height*bili[0], screenFrame.size.width*bili[1], screenFrame.size.height*bili[2]);
    return frame;
}
#pragma -mark drawHr为自定义的心率图控件，drawBp为自定义的血压器控件
- (void)viewDidLoad {
    [super viewDidLoad];
    self.drawH = [[drawHr alloc] initWithFrame:self.drawHrFrame];
    self.drawB = [[drawBp alloc] initWithFrame:self.drawBpFrame];
    [self.view addSubview:self.drawH];
    [self.view addSubview:self.drawB];
}

#pragma -mark 模拟生产实时的心跳值
- (void)addHrPoint {
        double r = rand()%21 - 10;
        double y = self.drawH.frame.size.height*(60.0/120.0) + r;
        CGPoint pointHr = CGPointMake(self.drawH.frame.size.width, y);
        NSValue *pointH = [NSValue valueWithCGPoint:pointHr];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.drawH.arrayHrPoint insertObject:pointH atIndex:0];
            [self.drawH setNeedsDisplay];
        });
}

#pragma -mark 模拟生产实时的血压值
- (void)addBpPoint {
        double r = rand()%140;
        double y = self.drawB.frame.size.height*(450.0/500.0) - r * (self.drawB.frame.size.height*(409.0/500.0))/300.0;
        CGPoint pointBp = CGPointMake(self.drawB.frame.size.width*(45.0/100.0), y);
        NSValue *pointB = [NSValue valueWithCGPoint:pointBp];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.drawB.arrayBpPoint insertObject:pointB atIndex:0];
            [self.drawB setNeedsDisplay];
        });
}

#pragma -mark 开启循环，模拟生产实时的心跳、血压值
- (IBAction)start:(UIButton *)btn {
    self.timerHr = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(addHrPoint) userInfo:nil repeats:YES];
    self.timerBp = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(addBpPoint) userInfo:nil repeats:YES];
}

- (IBAction)stop:(UIButton *)btn {
    [self.timerHr invalidate];
    [self.timerBp invalidate];
    [self.drawH clearHr];
    [self.drawB clearBp];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
