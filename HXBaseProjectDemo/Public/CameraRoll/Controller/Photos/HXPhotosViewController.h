//
//  HXPhotosViewController.h
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/5/18.
//  Copyright © 2016年 YISS. All rights reserved.
//

#import "BaseCollectionViewController.h"

typedef NS_ENUM (NSInteger, FromeType) {
    FromeTypeCommodity = 0,//从添加、编辑商品界面进来
    FromeTypeMyShop,//从我的档口进来
    FromeTypeOther,//从其他界面进来
};

@interface HXPhotosViewController : BaseCollectionViewController

@property (nonatomic,assign) FromeType fromeType;//默认从添加、编辑商品界面进来，可不传值
@property (nonatomic,assign) NSInteger photoCount;//最大添加照片数
@property (nonatomic,copy) void (^completion)(HXPhotosViewController *vc, NSArray *photos);
@end
