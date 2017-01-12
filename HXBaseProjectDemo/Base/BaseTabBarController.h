//
//  BaseTabBarController.h
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/5/9.
//  Copyright © 2016年 YISS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTabBarController : UITabBarController

#pragma 设置小红点数值
- (void)setBadgeValue:(NSString *)badgeValue index:(NSInteger)index;//设置指定tabar 小红点的值
#pragma 设置小红点显示或者隐藏
- (void)showBadgeWithIndex:(int)index;//显示小红点 没有数值
- (void)hideBadgeWithIndex:(int)index;//隐藏小红点 没有数值

@end
