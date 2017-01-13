//
//  IJKFFMoviePlayerHelper.h
//  MiaowShow
//
//  Created by zhanghaibin on 2017/1/12.
//  Copyright © 2017年 zhanghaibin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef  NS_ENUM(NSInteger,PlayState){
    
    PlayState_DidChange,
    PlayState_Finish
    
};

@interface IJKFFMoviePlayerHelper : UIView

/** 直播播放器 */
@property (nonatomic, strong) IJKFFMoviePlayerController *moviePlayer;

/** 直播开始前的占位图片 */
@property(nonatomic, weak) UIImageView *placeHolderView;

/** 父控制器 */
@property (nonatomic, weak) UIViewController *parentVc;

@property (nonatomic, copy) void (^playerState)( PlayState stateType);

- (void)plarFLV:(NSString *)flv placeHolderUrl:(NSString *)placeHolderUrl;

@end
