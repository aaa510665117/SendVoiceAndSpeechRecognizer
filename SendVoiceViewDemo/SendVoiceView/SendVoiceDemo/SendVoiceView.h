//
//  SendVoiceView.h
//  SkyEmergency
//
//  Created by ZY on 15/10/28.
//  Copyright © 2015年 ZY. All rights reserved.
//  发布语音view

#import <UIKit/UIKit.h>
#import "SpeechRecognizerManager.h"

/**
 *  success block
 *  path        --  语音路径
 *  time        --  语音时长
 *  voiceStr    --  语音识别文字
 */
typedef void (^CompleteAlert)(NSString * path, NSString * time, NSString * voiceStr);

@interface SendVoiceView : UIView<SFSpeechRecognizerDelegate>

@property (nonatomic, copy) CompleteAlert completeAlert;
@property (nonatomic, strong) NSString * pathName;              //绝对路径   ////

/**
 *  初始化
 *
 *  @param completeAlert 成功回调
 */
-(id)initWithPathName:(NSString *)pathName withSuccess:(CompleteAlert)completeAlert;

-(void)show;

@end
