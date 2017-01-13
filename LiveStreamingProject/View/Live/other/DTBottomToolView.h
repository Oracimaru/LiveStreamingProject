//
//  DTBottomToolView.h
//  LiveStreamingProject
//
//  Created by zhanghaibin on 2017/1/13.
//  Copyright © 2017年 100TAL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LiveToolType) {
    LiveToolTypePublicTalk,
    LiveToolTypeClose
};
@interface DTBottomToolView : UIView

//点击工具栏
@property(nonatomic, copy)void (^clickToolBlock)(LiveToolType type);


@end
