//
//
//  Created by zhanghaibin on 16/6/29.
//  Copyright © 2016年 zhanghaibin. All rights reserved.
//

#import "NSObject+HUD.h"

@implementation NSObject (HUD)
- (void)showInfo:(NSString *)info
{
    if ([self isKindOfClass:[UIViewController class]] || [self isKindOfClass:[UIView class]]) {
        [[[UIAlertView alloc] initWithTitle:@"喵播" message:info delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil] show];
    }
}
@end
