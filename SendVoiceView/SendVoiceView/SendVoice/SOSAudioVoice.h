//
//  JSQAudioVoice.h
//  Conversation
//
//  Created by ZY on 15/9/29.
//  Copyright © 2015年 ZY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SOSAudioVoice : NSObject

@property(nonatomic, strong)AVAudioRecorder *audioRecorder;

@property(nonatomic, copy)NSString *fileName;

@property(nonatomic, copy)NSString *filePath;

@property(nonatomic, copy)void (^voice)(CGFloat change, CGFloat currentTime);

- (instancetype)initWithFileSaveName:(NSString *)fileName;

- (void)start;

- (void)over;

- (void)cancel;


@end
