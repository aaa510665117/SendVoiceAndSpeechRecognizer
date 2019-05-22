//
//  JSQAudioVoice.h
//  Conversation
//
//  Created by C_HAO on 15/9/29.
//  Copyright © 2015年 CHAOO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "libSendVoice.h"

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
