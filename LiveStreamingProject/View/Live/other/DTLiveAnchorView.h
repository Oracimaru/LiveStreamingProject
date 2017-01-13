//
//  DTLiveAnchorView.h
//  LiveStreamingProject
//
//  Created by zhanghaibin on 2017/1/13.
//  Copyright © 2017年 100TAL. All rights reserved.
//   直播间主播相关的视图

#import <UIKit/UIKit.h>
@class HotLiveCommand;
@interface DTLiveAnchorView : UIView

+ (instancetype)liveAnchorView;
/** 直播 */
@property(nonatomic, strong) HotLiveCommand *live;
/** 点击开关  */
@property(nonatomic, copy)void (^clickDeviceShow)(bool selected);

@end
