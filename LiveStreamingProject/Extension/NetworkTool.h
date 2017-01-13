//
//  
//
//
//  Created by zhanghaibin on 16/6/14.
//  Copyright © 2016年 zhanghaibin. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSUInteger, NetworkStates) {
    NetworkStatesNone, // 没有网络
    NetworkStates2G, // 2G
    NetworkStates3G, // 3G
    NetworkStates4G, // 4G
    NetworkStatesWIFI // WIFI
};

@interface NetworkTool : AFHTTPSessionManager
+ (instancetype)shareTool;

// 判断网络类型
+ (NetworkStates)getNetworkStates;
@end
