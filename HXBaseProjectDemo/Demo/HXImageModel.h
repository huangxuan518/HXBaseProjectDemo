//
//  HXImageModel.h
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/1/14.
//  Copyright © 2016年 IT小子. All rights reserved.
//

#import "BaseModel.h"

@interface HXImageModel : BaseModel

@property (nonatomic,strong) UIImage *image;//刚从相册或者相机中添加的照片
@property (nonatomic,copy) NSString *imageUrl;//图片地址 该地址指的是网络地址
@property (nonatomic,assign) BOOL isDelete;//是否被删除 默认未被删除

+ (HXImageModel *)ittemModelWithImage:(UIImage *)image imageUrl:(NSString *)imageUrl isDelete:(BOOL)isDelete;

@end
