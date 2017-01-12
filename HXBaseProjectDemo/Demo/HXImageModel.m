//
//  HXImageModel.m
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/1/14.
//  Copyright © 2016年 IT小子. All rights reserved.
//

#import "HXImageModel.h"

@implementation HXImageModel

+ (HXImageModel *)ittemModelWithImage:(UIImage *)image imageUrl:(NSString *)imageUrl isDelete:(BOOL)isDelete {
    HXImageModel *model = [HXImageModel new];
    model.image = image;
    NSString *str = kSafeString(imageUrl);
    str = [str stringByReplacingOccurrencesOfString:@"!small9" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"!dplist" withString:@""];
    model.imageUrl = str;
    model.isDelete = isDelete;
    return model;
}

@end
