//
//  DTLiveViewCell.h
//  LiveStreamingProject
//
//  Created by zhanghaibin on 2017/1/13.
//  Copyright © 2017年 100TAL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HotLiveCommand;
@interface DTLiveViewCell : UICollectionViewCell


@property (nonatomic, strong) HotLiveCommand *live;
/** 相关的直播或者主播 */
@property (nonatomic, strong) HotLiveCommand *relateLive;
/** 父控制器 */
@property (nonatomic, weak) UIViewController *parentVc;
/** 点击关联主播 */
@property (nonatomic, copy) void (^clickRelatedLive)();


@end
