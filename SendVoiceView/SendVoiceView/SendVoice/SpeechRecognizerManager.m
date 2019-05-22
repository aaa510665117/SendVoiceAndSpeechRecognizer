//
//  SpeechRecognizerManager.m
//  MobileHospital
//
//  Created by 扬张 on 2019/1/29.
//  Copyright © 2019 ZY. All rights reserved.
//

#import "SpeechRecognizerManager.h"

@interface SpeechRecognizerManager()

@property (nonatomic, copy)speechRecognizerBlock block;

@end

@implementation SpeechRecognizerManager

static SpeechRecognizerManager* speechRecognizerManager =nil;
static dispatch_once_t onceToken;

+ (instancetype)sharedSpeechRecognizerManager{
    dispatch_once(&onceToken, ^{
        if (speechRecognizerManager == nil) {
            speechRecognizerManager = [[SpeechRecognizerManager alloc] init];
        }
    });
    return speechRecognizerManager;
}

- (instancetype)init {
    self= [super init];
    if(self) {
        //设备识别语言为中文
        NSLocale *cale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh-CN"];
        self.speechRecognizer = [[SFSpeechRecognizer alloc]initWithLocale:cale];
        //发送语音认证请求(首先要判断设备是否支持语音识别功能)
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            bool isButtonEnabled =false;
            switch(status) {
              case SFSpeechRecognizerAuthorizationStatusAuthorized:
              {
                   isButtonEnabled =true;
                   NSLog(@"可以语音识别");
              }
               break;
              case SFSpeechRecognizerAuthorizationStatusDenied:
              {
                   isButtonEnabled =false;
                   NSLog(@"用户被拒绝访问语音识别");
              }
                break;
              case SFSpeechRecognizerAuthorizationStatusRestricted:
              {
                   isButtonEnabled =false;
                   NSLog(@"不能在该设备上进行语音识别");
              }
                break;
              case SFSpeechRecognizerAuthorizationStatusNotDetermined:
              {
                   isButtonEnabled =false;
                   NSLog(@"没有授权语音识别");
              }
                   break;
            default:
                break;
            }
        }];
        //创建录音引擎
        self.audioEngine = [[AVAudioEngine alloc]init];
    }
    return self;
}

-(void)startRecording{
    if (self.recognitionTask) {
        [self.recognitionTask cancel];
        self.recognitionTask = nil;
    }
    __weak typeof(self) ws = self;
    
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    NSError *error;
////    [audioSession setCategory:AVAudioSessionCategoryRecord mode:AVAudioSessionModeMeasurement options:AVAudioSessionCategoryOptionDuckOthers error:nil];
//    NSParameterAssert(!error);
//    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
//    NSParameterAssert(!error);
    
    speechRecognizerManager.recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc]init];
    AVAudioInputNode *inputNode = self.audioEngine.inputNode;
//    SFSpeechAudioBufferRecognitionRequest *recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc]init];
//    recognitionRequest.shouldReportPartialResults=YES;
    self.recognitionRequest.shouldReportPartialResults = YES;
    //开始识别任务
    self.recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:speechRecognizerManager.recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        __strong typeof(ws) ss = ws;
        bool isFinal =false;
        if(result) {
            SFTranscription * str = [result bestTranscription];
            ss.block(str.formattedString);
            isFinal = [result isFinal];
        }
        if(error || isFinal) {
            [speechRecognizerManager.recognitionTask cancel];
            ss.recognitionTask = nil;
        }
    }];
    AVAudioFormat*recordingFormat = [inputNode outputFormatForBus:0];
    
//    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
//    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
////    [recordSetting setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
//    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
//    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
//    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
//    recordingFormat = [[AVAudioFormat alloc] initWithSettings:recordSetting];
//    recordingFormat = [[AVAudioFormat alloc] initStandardFormatWithSampleRate:11025. channels:2];

    [inputNode removeTapOnBus:0];
    
//    [inputNode setRate:0.5];
//    [inputNode setReverbBlend:1.0];
//    [inputNode setVolume:0.0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        __strong typeof(ws) ss = ws;
        [ss.recognitionRequest appendAudioPCMBuffer:buffer];
    }];
    [speechRecognizerManager.audioEngine prepare];
    bool audioEngineBool = [speechRecognizerManager.audioEngine startAndReturnError:nil];
    NSLog(@"%d",audioEngineBool);
}

- (void)speechRecognizerResult:(speechRecognizerBlock)block{
    self.block= block;
    [self startRecording];
}

@end
