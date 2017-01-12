//
//  HXAddImageViewController.m
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/1/14.
//  Copyright © 2016年 IT小子. All rights reserved.
//

#import "HXAddImageViewController.h"

//界面
#import "HXPhotoPreviewViewController.h"
#import "HXPhotosViewController.h"

//cell
#import "HXCurrencyAddPhotoCell.h"

#import "HXImageModel.h"

@interface HXAddImageViewController () <UIAlertViewDelegate>

@property (nonatomic,strong) NSMutableArray <HXImageModel *>*imageModelAry;//图片模型数组
@property (nonatomic,assign) NSInteger isClick;//是否点击提交

@end

@implementation HXAddImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removedRefreshing];

    self.title = @"添加图片";
    
    [self setRightItemWithTitle:@"完成" selector:@selector(complete)];

    [self.tableview registerNib:[UINib nibWithNibName:@"HXCurrencyAddPhotoCell" bundle:nil] forCellReuseIdentifier:@"HXCurrencyAddPhotoCell"];
    
    self.tableview.showsVerticalScrollIndicator = NO;
}

- (void)submit {
    //提交
}

#pragma mark - 图片上传相关

//图片上传
- (void)uploadImagesToHttpSever:(NSArray *)ary {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *dataAry = [NSMutableArray new];
        [ary enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *imageData = UIImagePNGRepresentation(image);
            [dataAry addObject:imageData];
        }];
        
        // 处理耗时操作的代码块...
        @weakify(self);
        [self.uploadManager uploadDatas:dataAry progress:^(float percent) {
            
        } oneTaskCompletion:^(NSError *error, NSString *link,NSData *data,NSInteger index) {

            [self.imageModelAry enumerateObjectsUsingBlock:^(HXImageModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSData *imageData = UIImagePNGRepresentation(model.image);
                if ([imageData isEqual:data]) {
                    if (model.imageUrl.length == 0) {
                        model.imageUrl = link;
                        [self.imageModelAry replaceObjectAtIndex:idx withObject:model];
                    }
                    *stop = YES;
                    return;
                }
            }];
            
        } allTasksCompletion:^{
            @strongify(self);
            NSArray *toBeUploadedAry = self.ittemToBeUploadedAry;
            if (toBeUploadedAry.count > 0) {
                //待上传的图片数大于0，则再次执行图片上传操作
                [self uploadImagesToHttpSever:toBeUploadedAry];
            } else {
                //没有待上传的图片，则发起提交请求
                if (_isClick) {
                    [self submit];
                }
            }
        }];
    });
}

#pragma mark 图片相关方法

//待上传图片数
- (NSMutableArray *)ittemToBeUploadedAry {
    NSMutableArray *toBeUploaded = [NSMutableArray new];
    
    [self.imageModelAry enumerateObjectsUsingBlock:^(HXImageModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (model.imageUrl.length == 0) {
            [toBeUploaded addObject:model.image];
        }
    }];

    return toBeUploaded;
}

//获取可用的图片
- (NSMutableArray *)ittemDidNotDeletePictures:(NSArray *)ary {
    NSMutableArray *newAry = [NSMutableArray new];
    [ary enumerateObjectsUsingBlock:^(HXImageModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!model.isDelete) {
            //优先用本地图片
            if (model.image) {
               [newAry addObject:model.image];
            } else if (model.imageUrl.length > 0) {
                [newAry addObject:model.imageUrl];
            }
        }
    }];
    return newAry;
}

#pragma mark - cellDataSource

- (NSArray *)cellDataSource {
    if (!self.dataSource) {
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:4];
        
        NSMutableArray *subarr = nil;
        NSDictionary *dict = nil;
        
        //单品sections
        NSArray *photos = [self ittemDidNotDeletePictures:self.imageModelAry];
        
        //section 1
        //图片
        subarr = [NSMutableArray arrayWithCapacity:1];
        dict =  @{@"class":HXCurrencyAddPhotoCell.class,
                  @"height":@([HXCurrencyAddPhotoCell getCellFrame:photos]),
                  @"data":[HXCurrencyAddPhotoCellModel ittemModelWithImageAry:photos],
                  @"delegate":@YES};
        [subarr addObject:dict];
        [arr addObject:subarr];

        self.dataSource = arr;
    }
    return self.dataSource;
}

#pragma mark FKDCurrencyAddPhotoCellDelegate 添加照片cell代理

//照片预览
- (void)currencyAddPhotoCell:(HXCurrencyAddPhotoCell *)cell didSelectItem:(id)selectItem {
    [self gotoPhotoPreviewViewController:selectItem];
}

//添加照片
- (void)currencyAddPhotoCellAddPhotoButtonAction {
    [self gotoPhotosViewController];
}

#pragma mark - 数据完整性验证

- (void)complete {
    NSString *erro;
    
    NSArray *photos = [self ittemDidNotDeletePictures:self.imageModelAry];
    
    if (photos.count == 0) {
        erro = @"请添加图片";
    }
    
    if (erro.length > 0) {
        [SVProgressHUD showInfoWithStatus:erro];
    } else {
        _isClick = YES;
        
        NSArray *toBeUploadedAry = self.ittemToBeUploadedAry;
        if (toBeUploadedAry.count > 0) {
            [SVProgressHUD showErrorWithStatus:@"图片正在上传中"];
            //待上传的图片数大于0，则再次执行图片上传操作
            [self uploadImagesToHttpSever:toBeUploadedAry];
        } else {
            //没有待上传的图片，则发起提交请求
            [self submit];
        }
    }
}

#pragma mark - goto

//照片预览界面
- (void)gotoPhotoPreviewViewController:(id)selectItem {
    
    NSArray *photos = [self ittemDidNotDeletePictures:self.imageModelAry];
    
    NSInteger index = [photos indexOfObject:selectItem];

    HXPhotoPreviewViewController *vc = [[HXPhotoPreviewViewController alloc] initWithPhotos:photos index:index];
    vc.superTitle = self.title;
    @weakify(self);
    vc.deleteCompletion = ^(HXPhotoPreviewViewController *vc, NSArray *photos,id currentDeleteImage) {
        @strongify(self);
        [self.imageModelAry enumerateObjectsUsingBlock:^(HXImageModel *model, NSUInteger idx, BOOL * _Nonnull stop) {

            //删除的可能是一个url或者是一个image所以拿它和model里面的url或者image比较即可
            if ([model.imageUrl isEqualToString:currentDeleteImage] || model.image == currentDeleteImage) {
                model.isDelete = YES;
                [self.imageModelAry replaceObjectAtIndex:idx withObject:model];
                *stop = YES;
                return;
            }
        }];
        
        [self refreshData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//去相机相册
- (void)gotoPhotosViewController {
    NSArray *images = [self ittemDidNotDeletePictures:self.imageModelAry];
    
    NSInteger count = kMaxPhotoNum - images.count;
    
    if (count <= 0) {
        NSString *str = [NSString stringWithFormat:@"最多只能添加%d张照片",kMaxPhotoNum];
        [SVProgressHUD showInfoWithStatus:str];
        return;
    }
    
    HXPhotosViewController *vc = [HXPhotosViewController new];
    vc.fromeType = FromeTypeCommodity;
    vc.photoCount = count;
    @weakify(self);
    vc.completion = ^(HXPhotosViewController *vc,NSArray *photos) {
        @strongify(self);
        [photos enumerateObjectsUsingBlock:^(UIImage *image, NSUInteger idx, BOOL * _Nonnull stop) {
            HXImageModel *model = [HXImageModel ittemModelWithImage:image imageUrl:nil isDelete:NO];
            [self.imageModelAry addObject:model];
        }];
        [self refreshData];
        
        //事件处理
        [self returnViewControllerWithName:self.class];
        
        [self uploadImagesToHttpSever:photos];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 懒加载

- (NSMutableArray *)imageModelAry {
    if (!_imageModelAry) {
        _imageModelAry = [NSMutableArray new];
    }
    return _imageModelAry;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
