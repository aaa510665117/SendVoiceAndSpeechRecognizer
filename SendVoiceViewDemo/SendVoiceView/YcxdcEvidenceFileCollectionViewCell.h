//
//  YcxdcEvidenceFileCollectionViewCell.h
//  MobileHospital
//
//  Created by ZY on 2018/7/5.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChoseDelete)(void);
typedef void(^ChoseVoiceText)(void);

@interface YcxdcEvidenceFileCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *yeFileColImg;
@property (weak, nonatomic) IBOutlet UILabel *voiceTimeLab;
@property (weak, nonatomic) IBOutlet UIButton *voiceTextBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (nonatomic, copy) ChoseDelete choseDelete;
@property (nonatomic, copy) ChoseVoiceText choseVoiceText;

@end
