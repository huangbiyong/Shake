//
//  ShakeViewController.m
//  Shake1
//
//  Created by Huangbiyong on 16/1/26.
//  Copyright © 2016年 Super. All rights reserved.
//

#import "ShakeViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ShakeViewController ()

@property (nonatomic,strong)UIImageView *topImgView;
@property (nonatomic,strong)UIImageView *botImgView;

@property (nonatomic) SystemSoundID  soundID;

@end

@implementation ShakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    [self becomeFirstResponder];
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0
                                                green:245/255.0
                                                 blue:245/255.0
                                                alpha:1.0];
    
    [self inintImageView];
    [self initSoudID];
}

//初始化振动的图片
- (void)inintImageView
{
    //中间线位置
    CGFloat y = 64+(kScreenHeight-64)/2;
    //图片的比例  宽/高
    CGFloat scale = 208/320.0;
    
    _topImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, y-(kScreenWidth*scale), kScreenWidth, kScreenWidth*scale)];
    _topImgView.image = [UIImage imageNamed:@"Shake_01"];
    [self.view addSubview:_topImgView];
    
    _botImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, y, kScreenWidth, kScreenWidth*scale)];
    _botImgView.image = [UIImage imageNamed:@"Shake_02"];
    [self.view addSubview:_botImgView];
}

//对soundID进行赋值
- (void)initSoudID
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"shake_sound_male" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &_soundID);
}


/*************************** 振动检测 ******************************/
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //播放
    AudioServicesPlaySystemSound (_soundID);

    CGFloat y_top = _topImgView.frame.origin.y;
    CGFloat y_bot = _botImgView.frame.origin.y;

    [UIView animateWithDuration:0.3 animations:^{
        
        _topImgView.frame = CGRectMake(0, y_top-50, _topImgView.frame.size.width, _topImgView.frame.size.height);
        _botImgView.frame = CGRectMake(0, y_bot+50, _botImgView.frame.size.width, _botImgView.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.3 animations:^{
            
            _topImgView.frame = CGRectMake(0, y_top, _topImgView.frame.size.width, _topImgView.frame.size.height);
            _botImgView.frame = CGRectMake(0, y_bot, _botImgView.frame.size.width, _botImgView.frame.size.height);
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [self performSelector:@selector(vibrate) withObject:nil afterDelay:0.6];
}


-(void)vibrate
{
    //振动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}




@end
