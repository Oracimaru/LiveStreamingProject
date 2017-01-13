//
//  DTCatEarView.h
//  LiveStreamingProject
//
//  Created by zhanghaibin on 2017/1/13.
//  Copyright © 2017年 100TAL. All rights reserved.
//  同一个工会的主播

#import <UIKit/UIKit.h>
@class HotLiveCommand;
@interface DTCatEarView : UIView

/** 主播/主播 */
@property(nonatomic, strong) HotLiveCommand *live;
+ (instancetype)catEarView;

@end
