//
//  DTHotLiveCell.h
//  LiveStreamingProject
//
//  Created by zhanghaibin on 2017/1/13.
//  Copyright © 2017年 100TAL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HotLiveCommand;
@interface DTHotLiveCell : UITableViewCell

/** 直播 */
@property (nonatomic, strong) HotLiveCommand *live;

@end
