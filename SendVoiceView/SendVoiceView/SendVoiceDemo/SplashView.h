//
//  SplashAnimateView.h
//  SkyEmergency
//
//  Created by ZY on 15/10/19.
//  Copyright © 2015年 ZY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SplashView : UIView

@property(nonatomic, strong)NSArray * myColor;

/**
 *  初始化
 *
 *  @param frame frame
 *  @param color r,g,b
 */
-(id)initWithFrame:(CGRect)frame withSplashColor:(NSArray*)color;

- (void)animate:(BOOL)animate;

@end
