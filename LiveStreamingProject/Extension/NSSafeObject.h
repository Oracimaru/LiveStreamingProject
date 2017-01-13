//
//  NSSafeObject.h
//
//
//  Created by zhanghaibin on 16/6/16.
//  Copyright © 2016年 zhanghaibin. All rights reserved.
//

#import <Foundation/Foundation.h>
/// justForText
@interface NSSafeObject : NSObject

- (instancetype)initWithObject:(id)object;
- (instancetype)initWithObject:(id)object withSelector:(SEL)selector;
- (void)excute;

@end
