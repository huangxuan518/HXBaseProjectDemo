//
//  HXCardSwitchView.h
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/5/18.
//  Copyright © 2016年 YISS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SXLineLayout.h"

@interface HXCardSwitchView : UIView

@property (nonatomic, strong) SXLineLayout *layout;

- (void)deleteWithIndex:(NSInteger)index;
- (void)setCardSwitchViewAry:(NSArray *)cardSwitchViewAry;

@end
