//
//  HXCutPhotoViewController.m
//  黄轩博客 blog.libuqing.com
//
//  Created by Love on 16/5/10.
//  Copyright © 2016年 YISS. All rights reserved.
//

#import "HXCutPhotoViewController.h"
#import "UzysImageCropper.h"
#import "UIImage-Extension.h"

@interface HXCutPhotoViewController ()

@property (nonatomic,strong) UzysImageCropper *cropperView;

@end

@implementation HXCutPhotoViewController

- (instancetype)initWithImage:(UIImage*)newImage cropSize:(CGSize)cropSize title:(NSString *)title isLast:(BOOL)isLast {
	if (self = [super init]) {
        
        self.title = title;
        
        NSString *rightTitle;
        if (isLast) {
            rightTitle = @"确认";
        } else {
            rightTitle = @"下一张";
        }
        
        [self setRightItemWithTitle:rightTitle selector:@selector(nextButtonAction:)];
        
        if(newImage.size.width <= cropSize.width || newImage.size.height <= cropSize.height) {
            NSLog(@"Image Size is smaller than cropSize");
            newImage = [newImage resizedImageToFitInSize:CGSizeMake(cropSize.width*1.3, cropSize.height*1.3) scaleIfSmaller:YES];
            NSLog(@"newImage Size %@",NSStringFromCGSize(newImage.size));
        }
        self.view.backgroundColor = [UIColor blackColor];
        _cropperView = [[UzysImageCropper alloc]
                       initWithImage:newImage 
                       andframeSize:self.view.frame.size
                       andcropSize:cropSize];
        
        [self.view addSubview:_cropperView];
        
        UIImage *image = [UIImage imageNamed:@"rotate"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//button的类型
        button.frame = CGRectMake(0, 0,50, 50);//button的frame
        button.center = CGPointMake(self.view.frameCenterX, button.center.y);
        button.frameOriginY = CONTENT_HEIGHT - button.frameSizeHeight - 28;
        button.backgroundColor = [UIColor clearColor];
        [button setImage:image forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.contentVerticalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.imageEdgeInsets = UIEdgeInsetsMake(0,13,0,0);
        [button setTitle:@"旋转" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleEdgeInsets = UIEdgeInsetsMake(30, -20, 0, 0);
        [button addTarget:self action:@selector(rotateCropViewClockwise:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackWithTitle:@"相册"];
}

#pragma mark - Action

//返回
- (void)backAction:(UIButton *)sender {
    [self returnViewControllerWithName:@"HXPhotosViewController"];
}

//下一步
- (void)nextButtonAction:(UIButton *)sender {
    [self finishCropping];
}

//旋转
- (void)rotateCropViewClockwise:(id)senders {
    [_cropperView actionRotate];
}

//完成裁剪
- (void)finishCropping {
    //NSLog(@"%@", @"ImageCropper finish cropping end");
    UIImage *cropped =[_cropperView getCroppedImage];
    [_delegate imageCropper:self didFinishCroppingWithImage:cropped];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
