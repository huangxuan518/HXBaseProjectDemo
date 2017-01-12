//
//  HXCutPhotoViewController.h
//  黄轩博客 blog.libuqing.com
//
//  Created by Love on 16/5/10.
//  Copyright © 2016年 YISS. All rights reserved.
//

#import "BaseViewController.h"

@class  HXCutPhotoViewController;

@protocol HXCutPhotoViewControllerDelegate <NSObject>

- (void)imageCropper:(HXCutPhotoViewController *)cropper didFinishCroppingWithImage:(UIImage *)image;

@end

@interface HXCutPhotoViewController : BaseViewController 

@property (nonatomic, assign) id <HXCutPhotoViewControllerDelegate> delegate;

- (instancetype)initWithImage:(UIImage*)newImage cropSize:(CGSize)cropSize title:(NSString *)title isLast:(BOOL)isLast;

@end


