//
//  SpeechRecognizerManager.h
//  MobileHospital
//
//  Created by 扬张 on 2019/1/29.
//  Copyright © 2019 ZY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Speech/Speech.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^speechRecognizerBlock)(NSString *testStr);

@interface SpeechRecognizerManager : NSObject

@property(strong,nonatomic)SFSpeechRecognitionTask * recognitionTask;//语音识别任务
@property(strong,nonatomic)SFSpeechRecognizer * speechRecognizer;//语音识别器
@property (strong, nonatomic) SFSpeechAudioBufferRecognitionRequest * recognitionRequest; //识别请求
@property (strong, nonatomic)AVAudioEngine * audioEngine; //录音引擎

// 单例类
+ (instancetype)sharedSpeechRecognizerManager;

- (void)speechRecognizerResult:(speechRecognizerBlock)block;

@end
