//
//  BaseCollectionViewCell.h
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/1/14.
//  Copyright © 2016年 IT小子. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionViewCell : UICollectionViewCell

- (void)setData:(id)data delegate:(id)delegate;

+ (float)getCellFrame:(id)msg;

@end
