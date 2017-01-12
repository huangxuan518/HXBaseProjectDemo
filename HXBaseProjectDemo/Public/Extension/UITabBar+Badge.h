//
//  UITabBar+Badge.h
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 2016/12/12.
//  Copyright © 2016年 Yiss Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Badge)

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点
- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
