//
//  SendVoiceView.m
//  SkyEmergency
//
//  Created by ZY on 15/10/28.
//  Copyright © 2015年 ZY. All rights reserved.
//

#import "SendVoiceView.h"
#import "SplashView.h"
//#import "UIImage+Blur.h"
#import "SOSAudioVoice.h"

@interface SendVoiceView()
{
    CGFloat sendBackSizeHigh;
    CGFloat voiceTextSizeHigh;
}
@property(nonatomic, strong)  UIImageView * blurImage;      //blurImage
@property (nonatomic, strong) UIView * voiceTextBack;       //语音识别文字Back
@property (nonatomic, strong) UILabel * voiceTextTitle;     //语音识别文字Title
@property (nonatomic, strong) UITextView * voiceTextView;   //语音识别文字View
@property (nonatomic, strong) UIView * sendBackView;        //发送背景view
@property (nonatomic, strong) UILabel * fingerWarnLabel;    //手指移动提示Label
@property (nonatomic, strong) UIImageView * recordBtn;      //录音按钮
@property (nonatomic, strong) UIButton * againBtn;          //重录按钮
@property (nonatomic, strong) UIButton * doneBtn;           //录音完成按钮
@property (nonatomic, strong) UILabel * timeLabel;          //发送时间Label
@property (nonatomic, strong) NSString * voiceTime;
@property (nonatomic, strong) UIView * splashView;          //发送按钮动画背景
@property (nonatomic, strong) SplashView * animation;       //动画view
@property (nonatomic, strong) SOSAudioVoice * audioVoice;

@property (nonatomic, assign) BOOL fingerIsEffect;          //手指是否有效

//触发部分
@property (nonatomic, strong)NSTimer * timerThred;                          //长按定时器
@end

@implementation SendVoiceView

//录音view
-(id)init
{
    self = [super init];
    if(self)
    {
        UIApplication *application = [UIApplication sharedApplication];
        if([[application keyWindow] viewWithTag:50001])
        {
            return nil;
        }
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor colorWithRed:1.000 green:1.000 blue:0.971 alpha:0.350];
        self.tag = 50001;
        voiceTextSizeHigh = 130;
        sendBackSizeHigh = 220;
        
        _blurImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        _blurImage.userInteractionEnabled = YES;
        _blurImage.backgroundColor = [UIColor clearColor];
        
        _voiceTextBack = [[UIView alloc]initWithFrame:CGRectMake(0, _blurImage.frame.size.height-sendBackSizeHigh-voiceTextSizeHigh, [UIScreen mainScreen].bounds.size.width, voiceTextSizeHigh)];
        [_blurImage addSubview:_voiceTextBack];
        
        _voiceTextTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
        _voiceTextTitle.backgroundColor = [UIColor colorWithRed:66/255.0 green:165/255.0 blue:249/255.0 alpha:1.0];
        _voiceTextTitle.text = @"语音识别";
        _voiceTextTitle.textAlignment = NSTextAlignmentCenter;
        _voiceTextTitle.textColor = [UIColor whiteColor];
        [_voiceTextBack addSubview:_voiceTextTitle];
        
        _voiceTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 30, _voiceTextBack.frame.size.width, 100)];
        _voiceTextView.backgroundColor = [UIColor whiteColor];
        _voiceTextView.font = [UIFont systemFontOfSize:15];
        _voiceTextView.text = @"";
        [_voiceTextBack addSubview:_voiceTextView];
        
        _sendBackView = [[UIView alloc]initWithFrame:CGRectMake(0, _blurImage.frame.size.height-sendBackSizeHigh, [UIScreen mainScreen].bounds.size.width, sendBackSizeHigh)];
        _sendBackView.backgroundColor = [UIColor whiteColor];
        [_blurImage addSubview:_sendBackView];
        
        _fingerWarnLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _sendBackView.frame.size.width, 30)];
        _fingerWarnLabel.backgroundColor = [UIColor colorWithRed:66/255.0 green:165/255.0 blue:249/255.0 alpha:1.0];
        _fingerWarnLabel.textAlignment = NSTextAlignmentCenter;
        _fingerWarnLabel.textColor = [UIColor whiteColor];
        _fingerWarnLabel.text = @"按下录制语音";
        [_sendBackView addSubview:_fingerWarnLabel];
        
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _fingerWarnLabel.frame.origin.y+_fingerWarnLabel.frame.size.height+5, _fingerWarnLabel.frame.size.width, 22)];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.text = @"00:00";
        [_sendBackView addSubview:_timeLabel];
        
        _splashView = [[UIView alloc]initWithFrame:CGRectMake(_sendBackView.frame.size.width/2-60, _sendBackView.frame.size.height/2-40, 120, 120)];
        _splashView.backgroundColor = [UIColor whiteColor];
        _splashView.userInteractionEnabled = NO;
        [_sendBackView addSubview:_splashView];

        _recordBtn = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
        _recordBtn.backgroundColor = [UIColor colorWithRed:66/255.0 green:165/255.0 blue:249/255.0 alpha:1.0];
        _recordBtn.userInteractionEnabled = YES;
        _recordBtn.layer.cornerRadius = _recordBtn.frame.size.width/2;
        _recordBtn.layer.masksToBounds = YES;
        UILongPressGestureRecognizer * gesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(clickRecordBtn:)];
        gesture.minimumPressDuration = 0.1;
        [_recordBtn addGestureRecognizer:gesture];
        [_sendBackView addSubview:_recordBtn];
        _recordBtn.center = CGPointMake(_splashView.center.x, _splashView.center.y);
        
        _againBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
        _againBtn.backgroundColor = [UIColor colorWithRed:238/255.0 green:100/255.0 blue:95/255.0 alpha:1.0];
        [_againBtn setTitle:@"重录" forState:UIControlStateNormal];
        _againBtn.layer.cornerRadius = _recordBtn.frame.size.width/2;
        [_againBtn addTarget:self action:@selector(clickAgainBtn) forControlEvents:UIControlEventTouchUpInside];
        [_sendBackView addSubview:_againBtn];
        _againBtn.hidden = YES;
        _againBtn.center = CGPointMake(_splashView.center.x-_sendBackView.frame.size.width/4, _splashView.center.y);

        _doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
        _doneBtn.backgroundColor = [UIColor colorWithRed:66/255.0 green:165/255.0 blue:249/255.0 alpha:1.0];
        [_doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        _doneBtn.layer.cornerRadius = _recordBtn.frame.size.width/2;
        [_doneBtn addTarget:self action:@selector(clickDoneBtn) forControlEvents:UIControlEventTouchUpInside];
        [_sendBackView addSubview:_doneBtn];
        _doneBtn.hidden = YES;
        _doneBtn.center = CGPointMake(_splashView.center.x+_sendBackView.frame.size.width/4, _splashView.center.y);
        
        _animation = [[SplashView alloc] initWithFrame:_splashView.bounds withSplashColor:[NSArray arrayWithObjects:@"66", @"165", @"249", nil]];
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer * gestureAlertView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        [_blurImage addGestureRecognizer:gestureAlertView];
        [self addSubview:_blurImage];
    }
    return self;
}

-(id)initWithPathName:(NSString *)pathName withSuccess:(CompleteAlert)completeAlert
{
    self = [self init];
    if(self)
    {
        _pathName = pathName;
        _completeAlert = completeAlert;
        //创建并执行新的线程
        _timerThred = [NSTimer scheduledTimerWithTimeInterval:20.0 target:self selector:@selector(timer_callback:) userInfo:nil repeats:YES];
        [_timerThred setFireDate:[NSDate distantFuture]];
    }
    return self;
}

-(void)timer_callback:(id)sender
{
    //时间超出
}

//点击录音按钮
-(void)clickRecordBtn:(id)sender
{
    //录音按钮
    SpeechRecognizerManager *manager = [SpeechRecognizerManager sharedSpeechRecognizerManager];
    manager.speechRecognizer.delegate=self;
    
    UIGestureRecognizer * gesture = (UIGestureRecognizer *)sender;
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        //开始录音
        NSLog(@"开始录音");
        _fingerIsEffect = YES;
        [_splashView addSubview:_animation];
        [_animation animate:YES];
        [_timerThred setFireDate:[NSDate dateWithTimeIntervalSinceNow:60]];
        
        _audioVoice = [[SOSAudioVoice alloc] initWithFileSaveName:_pathName];

        __weak typeof(self) ws = self;
        _audioVoice.voice = ^(CGFloat change, CGFloat currentTime) {
            __strong typeof(ws) ss = ws;
            ss.voiceTime = [NSString stringWithFormat:@"%.0f",currentTime];
            ss.timeLabel.text = [ss secondToOOOO:currentTime];//[NSString stringWithFormat:@"%.1f",currentTime];
        };
        
        //语音识别
        [manager speechRecognizerResult:^(NSString*testStr) {
            __strong typeof(ws) ss = ws;
            NSLog(@"识别内容:%@",testStr);
            ss.voiceTextView.text = [NSString stringWithFormat:@"%@", testStr];
        }];
        
        [_audioVoice start];
        _fingerWarnLabel.text = @"手指上滑，取消发送";
    }
    else if(gesture.state == UIGestureRecognizerStateChanged)
    {
        //移动
        CGPoint location = [gesture locationInView:[UIApplication sharedApplication].delegate.window];
        if(location.y < _sendBackView.frame.origin.y)
        {
            //手指在取消区域内
            _fingerIsEffect = NO;       //设置无效
            _fingerWarnLabel.text = @"松开手指，取消发送";
            _fingerWarnLabel.backgroundColor = [UIColor lightGrayColor];
        }
        else
        {
            _fingerIsEffect = YES;      //设置有效
            _fingerWarnLabel.text = @"手指上滑，取消发送";
            _fingerWarnLabel.backgroundColor = [UIColor colorWithRed:66/255.0 green:165/255.0 blue:249/255.0 alpha:1.0];
        }
    }
    else if(gesture.state == UIGestureRecognizerStateEnded)
    {
        [_animation animate:NO];
        [_animation removeFromSuperview];
        [_timerThred setFireDate:[NSDate distantFuture]];
        if(_fingerIsEffect == YES)
        {
            [_audioVoice over];     //结束录音
            _fingerWarnLabel.text = @"是否结束录音";
            [self endRecord];
//            [self hide];
//            _completeAlert(_pathName,_voiceTime);       //发送成功
        }
        else
        {
            [_audioVoice cancel];   //取消录音
            _fingerWarnLabel.text = @"按下录制语音";
            _fingerWarnLabel.backgroundColor = [UIColor colorWithRed:66/255.0 green:165/255.0 blue:249/255.0 alpha:1.0];
            _voiceTextView.text = @"";
        }
        _timeLabel.text = @"00:00";
        
        if([manager.audioEngine isRunning]) {
            [[manager.audioEngine inputNode] removeTapOnBus:0];
            [manager.audioEngine stop];
            [manager.recognitionRequest endAudio];
            manager.recognitionRequest = nil;
        }
    }
}

//录音结束
-(void)endRecord
{
    __weak typeof (self) vc = self;
    _againBtn.center = CGPointMake(_sendBackView.center.x, _againBtn.center.y);
    _doneBtn.center = CGPointMake(_sendBackView.center.x, _doneBtn.center.y);
    _againBtn.hidden = NO;
    _againBtn.alpha = 0;
    _doneBtn.hidden = NO;
    _doneBtn.alpha = 0;
    
    //点击暂停按钮
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         vc.recordBtn.alpha = 0;
                         vc.againBtn.alpha = 1;
                         vc.doneBtn.alpha = 1;
                         vc.againBtn.center = CGPointMake(vc.splashView.center.x-vc.sendBackView.frame.size.width/4, vc.againBtn.center.y);
                         vc.doneBtn.center = CGPointMake(vc.splashView.center.x+vc.sendBackView.frame.size.width/4, vc.againBtn.center.y);
                     }
                     completion:^(BOOL finished) {
                         vc.recordBtn.hidden = YES;
                         //结束录音
                         
                     }
     ];
}

//点击重录按钮
-(void)clickAgainBtn
{
    __weak typeof (self) vc = self;
    _recordBtn.hidden = NO;
    _recordBtn.alpha = 0;
    
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         vc.recordBtn.alpha = 1;
                         vc.againBtn.alpha = 0;
                         vc.doneBtn.alpha = 0;
                         vc.againBtn.center = CGPointMake(vc.sendBackView.center.x, vc.againBtn.center.y);
                         vc.doneBtn.center = CGPointMake(vc.sendBackView.center.x, vc.doneBtn.center.y);
                     }
                     completion:^(BOOL finished) {
                         vc.againBtn.hidden = YES;
                         vc.doneBtn.hidden = YES;
                         //重新录制
                         vc.fingerWarnLabel.text = @"按下录制语音";
                         vc.voiceTextView.text = @"";
                     }
     ];
}

//点击完成录音按钮
-(void)clickDoneBtn
{
    [self hide];
    _completeAlert(_pathName,_voiceTime, _voiceTextView.text);       //发送成功
}

-(void)show
{
//    UIApplication *application = [UIApplication sharedApplication];
//    NSInteger index = [[application keyWindow].subviews count];
//    [[application keyWindow] insertSubview:self atIndex:index];
    
    [[self getCurrentRootViewController].view addSubview:self];
}

-(void)hide
{
    [self removeFromSuperview];
}

-(void)drawRect:(CGRect)rect
{
    
}

- (UIViewController *)getCurrentRootViewController
{
    UIViewController *result = nil;
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    id  nextResponder = nil;
    UIViewController *appRootVC=window.rootViewController;
    //    如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        //多层present
        while (appRootVC.presentedViewController) {
            appRootVC = appRootVC.presentedViewController;
            if (appRootVC) {
                nextResponder = appRootVC;
            }else{
                break;
            }
        }
        //        nextResponder = appRootVC.presentedViewController;
    }else{
        
        //        NSLog(@"===%@",[window subviews]);
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];
        //        UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result=nav.childViewControllers.lastObject;
        
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        UIViewController * nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;
    }else{
        result = nextResponder;
    }
    return result;
}

//将int型秒数转换为00：00格式
-(NSString *)secondToOOOO:(NSInteger)second
{
    NSString *tmpmm = [NSString stringWithFormat:@"%ld",(second/60)%60];
    if ([tmpmm length] == 1)
    {
        tmpmm = [NSString stringWithFormat:@"0%@",tmpmm];
    }
    NSString *tmpss = [NSString stringWithFormat:@"%ld",second%60];
    if ([tmpss length] == 1)
    {
        tmpss = [NSString stringWithFormat:@"0%@",tmpss];
    }
    NSString * resultStr = [NSString stringWithFormat:@"%@:%@",tmpmm,tmpss];
    return resultStr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@end
