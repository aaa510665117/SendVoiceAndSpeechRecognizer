//
//  YcxdcEvidenceFileCollectionViewCell.m
//  MobileHospital
//
//  Created by ZY on 2018/7/5.
//  Copyright © 2018年 ZY. All rights reserved.
//

#import "YcxdcEvidenceFileCollectionViewCell.h"

@implementation YcxdcEvidenceFileCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)clickDeleteBtn:(id)sender {
    if(_choseDelete) _choseDelete();
}

- (IBAction)clickVoiceTextBtn:(id)sender {
    if(_choseVoiceText) _choseVoiceText();
}

@end
