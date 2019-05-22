//
//  ViewController.m
//  SendVoiceView
//
//  Created by ZY on 2019/5/22.
//  Copyright © 2019 扬张. All rights reserved.
//

#import "ViewController.h"
#import "SendVoiceView.h"
#import "YcxdcEvidenceFileCollectionViewCell.h"

@interface ViewController ()

@property(nonatomic, strong) NSMutableArray * showVoiceAry;
@property(nonatomic, strong) NSMutableArray * showVoiceTimeAry;
@property(nonatomic, strong) NSMutableArray * showVoiceStrAry;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _showVoiceAry = [[NSMutableArray alloc]init];
    _showVoiceTimeAry = [[NSMutableArray alloc]init];
    _showVoiceStrAry = [[NSMutableArray alloc]init];
    [_voiceCollection registerNib:[UINib nibWithNibName:@"YcxdcEvidenceFileCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"YcxdcEvidenceFileCollectionViewCell"];
}

- (IBAction)clickBeginBtn:(id)sender {
    
    __weak typeof(self) ws = self;
    NSString * filePath = [NSString stringWithFormat:@"%@/%@",[self DidiSwsVoicePath] ,@"testvoice"];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if (NO == [manager fileExistsAtPath:filePath isDirectory:&isDirectory]) {
        [manager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    filePath = [NSString stringWithFormat:@"%@/%@/%lu",[self DidiSwsVoicePath] ,@"testvoice", (unsigned long)_showVoiceAry.count];
    SendVoiceView *sendVoice = [[SendVoiceView alloc]initWithPathName:filePath withSuccess:^(NSString * path, NSString * time, NSString * voiceStr) {
        __strong typeof(ws) ss = ws;
        NSLog(@"path:%@ time:%@ voiceStr:%@",path,time,voiceStr);
        [ss.showVoiceAry addObject:[NSString stringWithFormat:@"%@.wav",path]];
        [ss.showVoiceTimeAry addObject:[NSString stringWithFormat:@"%@",time]];
        if([voiceStr isEqualToString:@""]){
            voiceStr = @"无";
        }
        [ss.showVoiceStrAry addObject:[NSString stringWithFormat:@"%@",voiceStr]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [ss.voiceCollection reloadData];
        });
    }];
    [sendVoice show];
}

- (NSString *)DidiSwsVoicePath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Voice/DidiSwsVoice"];
    BOOL isDirectory = NO;
    if (NO == [manager fileExistsAtPath:path isDirectory:&isDirectory]) {
        [manager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

#pragma collectionView--Delegate
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-40)/4, ([UIScreen mainScreen].bounds.size.width-40)/4+10);
}

//定义UICollectionView 的边距（返回UIEdgeInsets：上、左、下、右）
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//定义UICollectionView 每行内部cell item的间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//每行的行距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _showVoiceAry.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(0, 0);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YcxdcEvidenceFileCollectionViewCell * cell = (YcxdcEvidenceFileCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"YcxdcEvidenceFileCollectionViewCell" forIndexPath:indexPath];
    __weak typeof(self) ws = self;
    cell.yeFileColImg.image = [UIImage imageNamed:@"recordVoice"];
    cell.voiceTimeLab.hidden = NO;
    NSString * timeStr = [_showVoiceTimeAry objectAtIndex:indexPath.row];
    timeStr = [[timeStr componentsSeparatedByString:@"-"] firstObject];
    cell.voiceTimeLab.text = [self secondToOOOO:[timeStr integerValue]];
    cell.deleteBtn.hidden = YES;
    cell.voiceTextBtn.hidden = NO;
    cell.choseVoiceText = ^{
        __strong typeof(ws) ss = ws;
        NSString * voiceStr = [ss.showVoiceStrAry objectAtIndex:indexPath.row];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"文字信息"
                                                                       message:voiceStr
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        //弹出提示框；
        UIViewController *vc = [UIApplication sharedApplication].windows[0].rootViewController;
        [vc presentViewController:alert animated:YES completion:nil];
    };
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    //点击
//    mh_weakSelf(self);
//    //播放语音
//    if([SOSSoundVoice sharedSoundVoice].tag == indexPath.row)
//    {
//        [[SOSSoundVoice sharedSoundVoice] stop];
//        cell.yeFileColImg.image = [UIImage imageNamed:@"recordVoice"];
//    }
//    else
//    {
//        if([SOSSoundVoice sharedSoundVoice].tag > 0)        //更新掉上一个播放状态的图片
//        {
//            YcxdcEvidenceFileCollectionViewCell * cell = (YcxdcEvidenceFileCollectionViewCell *)[_yeFileCollectionVIew cellForItemAtIndexPath:[NSIndexPath indexPathForRow:[SOSSoundVoice sharedSoundVoice].tag inSection:0]];
//            cell.yeFileColImg.image = [UIImage imageNamed:@"recordVoice"];
//        }
//        [[SOSSoundVoice sharedSoundVoice] stop];
//        cell.yeFileColImg.image = [UIImage imageNamed:@"listenVoice"];
//        NSString * voiceFileStr = [_ycxdcMediaObj.voiceAry objectAtIndex:indexPath.row-1];
//        NSString * voiceName = [[voiceFileStr componentsSeparatedByString:@"/"] lastObject];
//        AFSoundItem *item = [[AFSoundItem alloc] initWithLocalResource:[NSString stringWithFormat:@"/%@",voiceName] atPath:[NSString stringWithFormat:@"%@/%@",[NSString DidiSwsVoicePath],_ycxdcObj.XH]];
//        NSMutableArray  * itemArray = [NSMutableArray arrayWithObjects:item, nil];
//        SOSSoundVoice * queue = [SOSSoundVoice sharedSoundVoice];
//        [queue clearQueue];
//        queue = [queue initWithItems:itemArray];
//        queue.tag = indexPath.row;
//        [queue play];
//        [queue listenFeedbackUpdatesWithBlock:^(AFSoundItem *item) {
//            NSLog(@"Item duration: %ld - time elapsed: %ld", (long)item.duration, (long)item.timePlayed);
//
//        } andFinishedBlock:^(AFSoundItem *nextItem) {
//            cell.yeFileColImg.image = [UIImage imageNamed:@"recordVoice"];
//            //更改音频按钮背景
//            [queue stop];
//        }];
        //播放同时展示语音文字内容
        NSString * voiceTextStr = [_showVoiceStrAry objectAtIndex:indexPath.row];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"文字信息"
                                                                       message:voiceTextStr
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"关闭" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //点击按钮的响应事件；
        }]];
        //弹出提示框；
        UIViewController *vc = [UIApplication sharedApplication].windows[0].rootViewController;
        [vc presentViewController:alert animated:YES completion:nil];
//        NSString * voiceTimeStr = [_ycxdcMediaObj.voiceTimeAry objectAtIndex:indexPath.row-1];
//        [NSTimer scheduledTimerWithTimeInterval:[voiceTimeStr intValue] target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
    
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

@end
