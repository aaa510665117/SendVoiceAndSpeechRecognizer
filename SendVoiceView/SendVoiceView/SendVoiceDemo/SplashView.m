//
//  SplashAnimateView.m
//  SkyEmergency
//
//  Created by ZY on 15/10/19.
//  Copyright © 2015年 ZY. All rights reserved.
//

#import "SplashView.h"

//圆与圆之间的距离，屏幕中含有四个圆，因此，设定为屏幕宽度的一半再除以四
#define RADIUS_DISTANCE     (self.frame.size.width/6.0)

@interface SplashView()
{
    NSTimer *_timer;//定时器
    NSInteger _count;//定时器计数
    NSMutableArray * colorArray;
}

@property(nonatomic, strong)NSArray * splashColor;

@end

@implementation SplashView

@synthesize myColor = _myColor;

-(id)initWithFrame:(CGRect)frame withSplashColor:(NSArray*)color
{
    self = [self initWithFrame:frame];
    if(self)
    {
        _splashColor = [[NSArray alloc]initWithArray:color];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        
        colorArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = [UIColor clearColor];
}

-(void)setMyColor:(NSArray *)myColor
{
    _myColor = myColor;
    _splashColor = [[NSArray alloc]initWithArray:myColor];
}

- (void)animate:(BOOL)animate;
{
    if (animate) {//开始动画，启动timer，可以通过timeInterval设定动画的快慢
        if (!_timer) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(reDraw:) userInfo:nil repeats:YES];
        }
    }else//结束动画，销毁timer
    {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)reDraw:(NSTimer *)t
{
    _count ++;
    _count = _count % (int)((self.frame.size.height-40)*0.5);
    
    [self setNeedsDisplayInRect:self.frame];    //通知系统刷新界面
}

//重写重绘方法
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
//    [self drawCircle:context];
    [self drawCircleB:context];
}

-(void)drawCircleB:(CGContextRef)context{
    
    CGPoint center = self.center;
    float radiusA = RADIUS_DISTANCE*1.0 ;
    float radius = RADIUS_DISTANCE*1.3 ;
    float radius0 = RADIUS_DISTANCE*1.6 ;
    float radius1 = RADIUS_DISTANCE*1.9 ;
    float radius2 = RADIUS_DISTANCE*2.2 ;
    float radius3 = RADIUS_DISTANCE*2.5 ;
    

    //获取红色值
    long r = [[_splashColor objectAtIndex:0] integerValue];
    //获取绿色值
    long g = [[_splashColor objectAtIndex:1] integerValue];
    //获取蓝色值
    long b = [[_splashColor objectAtIndex:2] integerValue];
    
    //绘制第一个圆
    //设置颜色为(255,100,100),透明度根据timer计数器计算，范围从1变化至0.7
    CGContextSetRGBStrokeColor(context, r/255.0, g/255.0, b/255.0, 0.7 + 0.4*(RADIUS_DISTANCE-_count)/RADIUS_DISTANCE);
    //宽度范围由2变化至3
    CGContextSetLineWidth(context, 5.0+_count );
    //绘制
    CGContextAddEllipseInRect(context, CGRectMake(center.x - radiusA, center.y - radiusA, 2*radiusA, 2*radiusA));
    CGContextStrokePath(context);

    //绘制第一个圆
    //设置颜色为(255,100,100),透明度根据timer计数器计算，范围从1变化至0.7
    CGContextSetRGBStrokeColor(context, r/255.0, g/255.0, b/255.0, 0.6 + 0.4*(RADIUS_DISTANCE-_count)/RADIUS_DISTANCE);
    //宽度范围由2变化至3
    CGContextSetLineWidth(context, 5.0+_count );
    //绘制
    CGContextAddEllipseInRect(context, CGRectMake(center.x - radius, center.y - radius, 2*radius, 2*radius));
    CGContextStrokePath(context);

    
    //绘制第一个圆
    //设置颜色为(255,100,100),透明度根据timer计数器计算，范围从1变化至0.7
    CGContextSetRGBStrokeColor(context, r/255.0, g/255.0, b/255.0, 0.5 + 0.3*(RADIUS_DISTANCE-_count)/RADIUS_DISTANCE);
    //宽度范围由2变化至3
    CGContextSetLineWidth(context, 5.0+_count );
    //绘制
    CGContextAddEllipseInRect(context, CGRectMake(center.x - radius0, center.y - radius0, 2*radius0, 2*radius0));
    CGContextStrokePath(context);
    
    //绘制第二个圆
    //设置颜色为(255,100,100),透明度根据timer计数器计算，范围从0.7变化至0.4
    CGContextSetRGBStrokeColor(context, r/255.0, g/255.0, b/255.0, 0.4 + 0.3*(RADIUS_DISTANCE-_count)/RADIUS_DISTANCE);
    //宽度范围由3变化至4
    CGContextSetLineWidth(context, 6.0+_count );
    CGContextAddEllipseInRect(context, CGRectMake(center.x - radius1, center.y - radius1, 2*radius1, 2*radius1));
    CGContextStrokePath(context);
    //
    //绘制第三个圆
    //设置颜色为(255,100,100),透明度根据timer计数器计算，范围从0.4变化至0.2
    CGContextSetRGBStrokeColor(context, r/255.0, g/255.0, b/255.0, 0.2 + 0.2*(RADIUS_DISTANCE-_count)/RADIUS_DISTANCE);
    //宽度范围由4变化至5
    CGContextSetLineWidth(context, 6.0+_count );
    CGContextAddEllipseInRect(context, CGRectMake(center.x - radius2, center.y - radius2, 2*radius2, 2*radius2));
    CGContextStrokePath(context);
    
    //绘制第四个圆
    //设置颜色为(255,100,100),透明度根据timer计数器计算，范围从0.2变化至0
    CGContextSetRGBStrokeColor(context, r/255.0, g/255.0, b/255.0, 0.0 + 0.2*(RADIUS_DISTANCE-_count)/RADIUS_DISTANCE);
    //宽度范围由5变化至6
    CGContextSetLineWidth(context, 7.0+_count );
    CGContextAddEllipseInRect(context, CGRectMake(center.x - radius3, center.y - radius3, 2*radius3, 2*radius3));
    CGContextStrokePath(context);

}

//画圆
-(void)drawCircle:(CGContextRef)context
{
    //定义四个半径，
    //第一个圆的半径为RADIUS_DISTANCE，变化范围为RADIUS_DISTANCE到RADIUS_DISTANCE+_count;
    //第二个圆的半径为RADIUS_DISTANCE*2，变化范围为RADIUS_DISTANCE*2到RADIUS_DISTANCE*2+_count;
    //第三个圆的半径为RADIUS_DISTANCE*3，变化范围为RADIUS_DISTANCE*3到RADIUS_DISTANCE*3+_count;
    //第四个圆的半径为RADIUS_DISTANCE*4，变化范围为RADIUS_DISTANCE*4到RADIUS_DISTANCE*4+_count;
    CGPoint center = self.center;
    float radius0 = RADIUS_DISTANCE*1 + _count;
    float radius1 = RADIUS_DISTANCE*2 + _count;
    float radius2 = RADIUS_DISTANCE*3 + _count;
    float radius3 = RADIUS_DISTANCE*4 + _count;
    
    //绘制第一个圆
    //设置颜色为(255,100,100),透明度根据timer计数器计算，范围从1变化至0.7
    CGContextSetRGBStrokeColor(context, 221/255.0, 64/255.0, 59/255.0, 0.7 + 0.3*(RADIUS_DISTANCE-_count)/RADIUS_DISTANCE);
    //宽度范围由2变化至3
    CGContextSetLineWidth(context, 2.0 + 1*_count/RADIUS_DISTANCE);
    //绘制
    CGContextAddEllipseInRect(context, CGRectMake(center.x - radius0, center.y - radius0, 2*radius0, 2*radius0));
    CGContextStrokePath(context);
//
    //绘制第二个圆
    //设置颜色为(255,100,100),透明度根据timer计数器计算，范围从0.7变化至0.4
    CGContextSetRGBStrokeColor(context, 221/255.0, 64/255.0, 59/255.0, 0.4 + 0.3*(RADIUS_DISTANCE-_count)/RADIUS_DISTANCE);
    //宽度范围由3变化至4
    CGContextSetLineWidth(context, 3.0 + 1*_count/RADIUS_DISTANCE);
    CGContextAddEllipseInRect(context, CGRectMake(center.x - radius1, center.y - radius1, 2*radius1, 2*radius1));
    CGContextStrokePath(context);
//
    //绘制第三个圆
    //设置颜色为(255,100,100),透明度根据timer计数器计算，范围从0.4变化至0.2
    CGContextSetRGBStrokeColor(context, 221/255.0, 64/255.0, 59/255.0, 0.2 + 0.2*(RADIUS_DISTANCE-_count)/RADIUS_DISTANCE);
    //宽度范围由4变化至5
    CGContextSetLineWidth(context, 4.0 + 1*_count/RADIUS_DISTANCE);
    CGContextAddEllipseInRect(context, CGRectMake(center.x - radius2, center.y - radius2, 2*radius2, 2*radius2));
    CGContextStrokePath(context);

    //绘制第四个圆
    //设置颜色为(255,100,100),透明度根据timer计数器计算，范围从0.2变化至0
    CGContextSetRGBStrokeColor(context, 221/255.0, 64/255.0, 59/255.0, 0.0 + 0.2*(RADIUS_DISTANCE-_count)/RADIUS_DISTANCE);
    //宽度范围由5变化至6
    CGContextSetLineWidth(context, 5.0 + 1*_count/RADIUS_DISTANCE);
    CGContextAddEllipseInRect(context, CGRectMake(center.x - radius3, center.y - radius3, 2*radius3, 2*radius3));
    CGContextStrokePath(context);
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
