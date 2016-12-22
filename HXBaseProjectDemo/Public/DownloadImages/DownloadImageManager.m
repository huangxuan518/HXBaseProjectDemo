//
//  DownloadImageManager.m
//
//
//  Created by 黄轩 on 16/6/22.
//  Copyright (c) 2016年 sure. All rights reserved.
//

#import "DownloadImageManager.h"
#import "SDWebImageDownloader.h"
#import "SVProgressHUD.h"

@interface DownloadImageManager ()

@property (nonatomic,strong) NSMutableArray *imageUrlAry;//图片Url数组
@property (nonatomic,strong) NSMutableArray *completeImageAry;//完成的图片
@property (nonatomic,assign) NSInteger currentDisposeIndex;//当前处理的图片index
@property (nonatomic,assign) NSInteger successCount;//上传成功的数

@end

@implementation DownloadImageManager

/**
 *  图片下载成功
 *
 *  @param url   <#url description#>
 *  @param index <#index description#>
 */
- (void)downloadImageSucess:(NSString *)url {
    if (_currentDisposeIndex > self.imageUrlAry.count - 1) {
        [self queueComplete];
    } else {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        //发送一个异步请求
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (!connectionError) {
                if ([UIImage imageWithData:data]) {
                    _successCount ++;
                    [self.completeImageAry addObject:[UIImage imageWithData:data]];
                }
            }
            //休息每上传完一张图片休息0.5秒,让界面有充足的时间展示下载动画
            _currentDisposeIndex++;
            float progress = _currentDisposeIndex/(self.imageUrlAry.count*1.0);
            [SVProgressHUD showProgress:progress status:[NSString stringWithFormat:NSLocalizedString(@"download_img_tips", @"图片下载中%ld/%lu"),(long)_currentDisposeIndex,(unsigned long)self.imageUrlAry.count]];
            
            if (_currentDisposeIndex > self.imageUrlAry.count - 1) {
                [self queueComplete];
            } else {
                [self downloadImageSucess:self.imageUrlAry[_currentDisposeIndex]];
            }
        }];
    }
}

- (void)dismiss {
    [SVProgressHUD dismiss];
}

/**
 *  所有图片
 */
- (void)queueComplete {
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    
    if (_completion) {
        _completion(self,self.completeImageAry);
    }
}

/**
 *  批量下载
 *
 *  @param imageUrlAry 图片Url数组
 */
- (void)downloadsToHttpSeverWithImageUrlAry:(NSArray *)imageUrlAry {
    [self dataInit];
    
    [imageUrlAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *url = (NSString *)obj;
            [self.imageUrlAry addObject:url];
        }
    }];
    
    if (self.imageUrlAry.count > 0) {
        [self downloadImageSucess:self.imageUrlAry[_currentDisposeIndex]];
    } else {
        [self queueComplete];
    }
}

- (void)dataInit {
    [self.imageUrlAry removeAllObjects];
    _successCount = 0;
    _currentDisposeIndex = 0;
    [self.completeImageAry removeAllObjects];
}

#pragma mark - 懒加载

//完成图片数组
- (NSMutableArray *)completeImageAry {
    if (!_completeImageAry) {
        _completeImageAry = [NSMutableArray new];
    }
    return _completeImageAry;
}

- (NSMutableArray *)imageUrlAry {
    if (!_imageUrlAry) {
        _imageUrlAry = [NSMutableArray new];
    }
    return _imageUrlAry;
}



@end
