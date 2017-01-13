//
//  DTLiveCollectionViewController.h
//  LiveStreamingProject
//
//  Created by zhanghaibin on 2017/1/13.
//  Copyright © 2017年 100TAL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DTLiveCollectionViewController : UICollectionViewController

/** 直播 */
@property (nonatomic, strong) NSArray *lives;
/** 当前的index */
@property (nonatomic, assign) NSUInteger currentIndex;

@end
