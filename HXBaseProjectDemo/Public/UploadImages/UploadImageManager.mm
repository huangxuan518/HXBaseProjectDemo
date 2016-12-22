//
//  UploadImageManager.m
//  Dongdaemun
//
//  Created by 刘伟 on 15/7/15.
//  Copyright (c) 2015年 sure. All rights reserved.
//

#import "UploadImageManager.h"
#import "NSString+Extension.h"
#import "SVProgressHUD.h"
#import "UIImage+Extension.h"

@interface UploadImageManager ()

@property (nonatomic,strong) NSMutableArray *imagesAry;//图片数组
@property (nonatomic,strong) NSMutableArray *completeImagesUrlArr;
@property (nonatomic,assign) NSInteger currentDisposeIndex;//当前处理的图片index
@property (nonatomic,assign) NSInteger successCount;//上传成功的数

@end

@implementation UploadImageManager

/**
 *  图片上传成功
 *
 *  @param url   <#url description#>
 *  @param index <#index description#>
 */
- (void)uploadSucess:(id)obj {
    if (_currentDisposeIndex > _imagesAry.count - 1) {
        [self queueComplete];
    } else {
        if ([obj isKindOfClass:[UIImage class]]) {
            UIImage *image = (UIImage *)obj;
            
            [self uploadImg:image progressBlock:^(Float32 percent, long long requestDidSendBytes) {
                if (_showProgressHUD) {
                    if (percent >= 1.0) {
                        percent = 0.99;
                    }
                    
                    float index = _successCount*1.0;
                    float count = (int)_imagesAry.count*1.0;
                    float current = index/count;
                    float one = 1.0/count;
                    
                    float ff = percent*one + current;
                    NSString *strPercent = [NSString stringDisposeWithFloatValue:ff*100];
                    [SVProgressHUD showWithStatus:[NSString stringWithFormat:NSLocalizedString(@"upload_img_tips", @"上传中...%@%@"),strPercent,@"%"]];
                }
            } completeBlock:^(NSError *error, NSString *resultUrl, BOOL isSuccess) {
                if (isSuccess) {
                    if (_success) {
                        _success(self,obj,resultUrl);
                    }
                    _successCount++;
                    [self.completeImagesUrlArr addObject:resultUrl];
                }
                
                _currentDisposeIndex++;
                if (_currentDisposeIndex > _imagesAry.count - 1) {
                    [self queueComplete];
                    [SVProgressHUD dismiss];
                } else {
                    [self uploadSucess:_imagesAry[_currentDisposeIndex]];
                }
            }];
        } else {
            _successCount++;
            [self.completeImagesUrlArr addObject:obj];
            
            _currentDisposeIndex++;
            if (_currentDisposeIndex > _imagesAry.count - 1) {
                [self queueComplete];
                [SVProgressHUD dismiss];
            } else {
                [self uploadSucess:_imagesAry[_currentDisposeIndex]];
            }
        }
    }
}

/**
 *  所有图片
 */
- (void)queueComplete {
    if (_completion) {
        _completion(self,self.completeImagesUrlArr);
    }
}

/**
 *  批量图片地址上传图片到服务器
 *
 *  @param imageAry 图片数组
 */
- (void)uploadImagesToHttpSeverWithImageAry:(NSArray *)imageAry {
    [self.completeImagesUrlArr removeAllObjects];
    
    _successCount = 0;
    _currentDisposeIndex = 0;
    
    if (imageAry.count > 0) {
        _imagesAry = [NSMutableArray arrayWithArray:imageAry];
        [self uploadSucess:_imagesAry[_currentDisposeIndex]];
    } else {
        [self queueComplete];
    }
}

//懒加载
- (NSMutableArray *)completeImagesUrlArr {
    if (!_completeImagesUrlArr) {
        _completeImagesUrlArr = [NSMutableArray new];
    }
    return _completeImagesUrlArr;
}

- (void)uploadImagesToHttpSeverWithImage:(UIImage *)image {
    [self.completeImagesUrlArr removeAllObjects];
    
    [self uploadImg:image progressBlock:^(Float32 percent, long long requestDidSendBytes) {
        
        if (_showProgressHUD) {
            if (percent >= 1.0) {
                percent = 0.99;
            }
            NSString *strPercent = [NSString stringDisposeWithFloatValue:percent*100];
            [SVProgressHUD showWithStatus:[NSString stringWithFormat:NSLocalizedString(@"upload_img_tips", @"上传中...%@%@"),strPercent,@"%"]];
        }
        
    } completeBlock:^(NSError *error, NSString *resultUrl, BOOL isSuccess) {
        if (isSuccess) {
            [self.completeImagesUrlArr addObject:resultUrl];
        } else {
            [SVProgressHUD showErrorWithStatus:error.domain];
        }

        [self queueComplete];
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - 图片尺寸处理

//1000PX以下不缩放； 1000-2000PX缩放至1/2大小；2000-4800PX缩放至1/4大小；4800PX以上缩放至1/8大小。
+ (UIImage *)imageCompressionRatio:(UIImage *)image {
    int width = image.size.width;
    int height = image.size.height;
    
    float size;
    if (width > height) {
        size = width;
    } else {
        size = height;
    }
    
    UIImage *croppedImage;
    if (size > 4800) {
        croppedImage = [image imageCompressForSize:image targetSize:CGSizeMake(image.size.width/8, image.size.height/8)];
    } else if (size > 2000) {
        croppedImage = [image imageCompressForSize:image targetSize:CGSizeMake(image.size.width/4, image.size.height/4)];
    } else if (size > 1000) {
        croppedImage = [image imageCompressForSize:image targetSize:CGSizeMake(image.size.width/2, image.size.height/2)];
    } else {
        croppedImage = [image imageCompressForSize:image targetSize:CGSizeMake(image.size.width, image.size.height)];
    }
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation != UIDeviceOrientationPortrait) {
        
        CGFloat degree = 0;
        if (orientation == UIDeviceOrientationPortraitUpsideDown) {
            degree = 180;// M_PI;
        } else if (orientation == UIDeviceOrientationLandscapeLeft) {
            degree = -90;// -M_PI_2;
        } else if (orientation == UIDeviceOrientationLandscapeRight) {
            degree = 90;// M_PI_2;
        }
        croppedImage = [croppedImage rotatedByDegrees:degree];
    }
    
    NSLog(@"width:%f height:%f",croppedImage.size.width,croppedImage.size.height);
    
    return croppedImage;
}

//图片上传
- (void)uploadImg:(UIImage *)uploadImg progressBlock:(void(^)(Float32 percent, long long requestDidSendBytes))progressBlock
    completeBlock:(void(^)(NSError *error, NSString *resultUrl, BOOL isSuccess))completeBlock {
//    
//    //图片进行尺寸压缩
//    UIImage *imageCompressionRatioImage = [UploadImageManager imageCompressionRatio:uploadImg];
//
//    NSData *imgData = UIImageJPEGRepresentation(imageCompressionRatioImage, 1.0);
}

@end
