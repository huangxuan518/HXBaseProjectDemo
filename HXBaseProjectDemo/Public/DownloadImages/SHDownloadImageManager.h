//
//  SHDownloadImageManager.h
//
//
//  Created by 黄轩 on 16/6/22.
//  Copyright (c) 2016年 sure. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHDownloadImageManager : NSObject

@property (nonatomic,assign) BOOL showProgressHUD;

//多张图片下载完成
@property (nonatomic,copy) void (^completion)(SHDownloadImageManager *downloadManager,NSArray *completeImageAry);

/**
 *  批量下载
 *
 *  @param imageUrlAry 图片Url数组
 */
- (void)downloadsToHttpSeverWithImageUrlAry:(NSArray *)imageUrlAry;

@end
