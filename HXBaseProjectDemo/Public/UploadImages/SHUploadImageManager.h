//
//  SHUploadImageManager.h
//  Dongdaemun
//
//  Created by 刘伟 on 15/7/15.
//  Copyright (c) 2015年 sure. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHUploadImageManager : NSObject

@property (nonatomic,assign) BOOL showProgressHUD;

//多张图片上传完成
@property (nonatomic,copy) void (^completion)(SHUploadImageManager *uploadImageManager,NSArray *urlAry);
//完成一张回调一张的url和原始的图片
@property (nonatomic,copy) void (^success)(SHUploadImageManager *uploadImageManager, UIImage *uploadImage,NSString *successUrl);

/**
 *  多张图片上传
 *
 *  @param imageAry 图片数组
 *  @param type     <#type description#>
 */
- (void)uploadImagesToHttpSeverWithImageAry:(NSArray *)imageAry;

/**
 *  单张图片上传
 *
 *  @param image 图片
 *  @param type  <#type description#>
 */
- (void)uploadImagesToHttpSeverWithImage:(UIImage *)image;

//图片等比处理
+ (UIImage *)imageCompressionRatio:(UIImage *)image;

@end
