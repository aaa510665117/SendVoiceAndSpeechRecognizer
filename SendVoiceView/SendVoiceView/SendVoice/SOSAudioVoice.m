//
//  JSQAudioVoice.m
//  Conversation
//
//  Created by ZY on 15/9/29.
//  Copyright © 2015年 ZY. All rights reserved.
//

#import "SOSAudioVoice.h"

@interface SOSAudioVoice()

@property(nonatomic, strong)NSTimer *timer;

@end

@implementation SOSAudioVoice

- (instancetype)initWithFileSaveName:(NSString *)fileName
{
    self = [super init];
    if (self) {
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        [session setCategory:AVAudioSessionCategoryRecord error:&sessionError];
        
//        if (session) {
//            [session setActive:YES error:nil];  // 此处手动激活
//        }
//        else {
//            NSLog(@"Error setting category: %@", [sessionError description]);
//        }
        
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
        
        _fileName = [fileName stringByAppendingString:@".wav"];
        _filePath = _fileName;
        
        NSError *error;
        _audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL URLWithString:_filePath] settings:recordSetting error:&error];
        _audioRecorder.meteringEnabled = YES;
    }
    return self;
}

- (void)start
{
    [_audioRecorder record];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
}

- (void)over
{
    [_timer invalidate];
    _timer = nil;
    [_audioRecorder stop];
}

- (void)cancel
{
    [_timer invalidate];
    _timer = nil;
    [_audioRecorder stop];
    [_audioRecorder deleteRecording];
}

- (void)changeImage
{
    [_audioRecorder updateMeters];
    float avg = [_audioRecorder averagePowerForChannel:0];
    float minValue = -60;
    float range = 60;
    float outRange = 60;
    if (avg < minValue) {
        avg = minValue;
    }
    float decibels = (avg + range) / range * outRange;
    if (_voice) {
        _voice(decibels, _audioRecorder.currentTime);
    }
}

@end
