//
//  DTMainViewController.m
//  LiveStreamingProject
//
//  Created by zhanghaibin on 2017/1/13.
//  Copyright © 2017年 100TAL. All rights reserved.
//

#import "DTMainViewController.h"
#import "UIDevice+Extension.h"
#import <AVFoundation/AVFoundation.h>
// vc
#import "DTHotViewController.h"
#import "DTNavigationController.h"
#import "DTProfileController.h"
#import "DTShowTimeViewController.h"
@interface DTMainViewController () <UITabBarControllerDelegate>

@end

@implementation DTMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.delegate = self;
    [self setup];
}

- (void)setup
{
    [self addChildViewController:[[DTHotViewController alloc] init]
                      imageNamed:@"toolbar_home"];

    UIViewController* showTime = [[UIViewController alloc] init];
    showTime.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:showTime imageNamed:@"toolbar_live"];
    [self addChildViewController:[[DTProfileController alloc] init]
                      imageNamed:@"toolbar_me"];
}

- (void)addChildViewController:(UIViewController*)childController
                    imageNamed:(NSString*)imageName
{
    DTNavigationController* nav = [[DTNavigationController alloc]
        initWithRootViewController:childController];
    childController.tabBarItem.image = [UIImage imageNamed:imageName];
    childController.tabBarItem.selectedImage =
        [UIImage imageNamed:[NSString stringWithFormat:@"%@_sel", imageName]];
    childController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);

    [self addChildViewController:nav];
}

- (BOOL)tabBarController:(UITabBarController*)tabBarController
    shouldSelectViewController:(UIViewController*)viewController
{
    if ([tabBarController.childViewControllers indexOfObject:viewController] == tabBarController.childViewControllers.count - 2) {
        // 判断是否是模拟器
        if ([[UIDevice deviceVersion] isEqualToString:@"iPhone Simulator"]) {
            [self showInfo:@"请用真机进行测试, "
                           @"此模块不支持模拟器测试"];
            return NO;
        }

        // 判断是否有摄像头
        if (![UIImagePickerController
                isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self showInfo:@"您的设备没有摄像头或者相关的驱动, "
                           @"不能进行直播"];
            return NO;
        }

        // 判断是否有摄像头权限
        AVAuthorizationStatus authorizationStatus =
            [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authorizationStatus == AVAuthorizationStatusRestricted || authorizationStatus == AVAuthorizationStatusDenied) {
            [self showInfo:@"app需要访问您的摄像头。\n请启用摄像头-设置/隐私/摄像头"];
            return NO;
        }

        // 开启麦克风权限
        AVAudioSession* audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:)
                               withObject:^(BOOL granted) {
                                   if (granted) {
                                       return YES;
                                   } else {
                                       [self showInfo:@"app需要访问您的麦克风。\n请启用麦"
                                                      @"克风-设置/隐私/麦克风"];
                                       return NO;
                                   }
                               }];
        }

        DTShowTimeViewController* showTimeVc =
            [UIStoryboard storyboardWithName:NSStringFromClass(
                                                 [DTShowTimeViewController class])
                                      bundle:nil]
                .instantiateInitialViewController;
        [self presentViewController:showTimeVc animated:YES completion:nil];
        return NO;
    }
    return YES;
}
@end