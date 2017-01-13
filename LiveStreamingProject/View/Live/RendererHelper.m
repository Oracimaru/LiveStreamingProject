//
//  RendererView.m
//  MiaowShow
//
//  Created by zhanghaibin on 2017/1/12.
//  Copyright © 2017年 zhanghaibin. All rights reserved.
//

#import "RendererHelper.h"
#import "NSSafeObject.h"
@implementation RendererHelper
{
    NSTimer * _timer;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.canvasMargin = UIEdgeInsetsMake(DTScreenHeight * 0.3, 10, 10, 10);
        [self setUp];
    }
    return self;
}
- (void)setUp
{
    NSSafeObject * safeObj = [[NSSafeObject alloc]initWithObject:self withSelector:@selector(autoSendBarrage)];
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];

}
- (void)autoSendBarrage
{
    NSInteger spriteNumber = [self spritesNumberWithName:nil];
    if (spriteNumber <= 50) { // 限制屏幕上的弹幕量
        [self receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L]];
    }
}
#pragma mark - 弹幕描述符生产方法

long _index = 0;
/// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = self.danMuText[arc4random_uniform((uint32_t)self.danMuText.count)];
    descriptor.params[@"textColor"] = Color(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256));
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"clickAction"] = ^{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"弹幕被点击" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
    };
    return descriptor;
}

- (NSArray *)danMuText
{
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"danmu.plist" ofType:nil]];
}

@end
