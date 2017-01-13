//
//  HXPhotosViewController.m
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/5/18.
//  Copyright © 2016年 YISS. All rights reserved.
//

#import "HXPhotosViewController.h"
#import "HXCutPhotoViewController.h"

#import "HXPhotoCell.h"
#import "AssetHelper.h"
#import "HXCardSwitchView.h"
#import "UIImage+Resize.h"
#import "UIImage-Extension.h"

#import "SCCaptureSessionManager.h"

#define CardSwitchViewHeight 303

typedef NS_ENUM (NSInteger, ImagePickerControllerSourceType) {
    ImagePickerControllerSourceTypeCamera,//相机
    ImagePickerTypePhotoLibrary//相册
};

@interface HXPhotosViewController () <UITableViewDataSource,UITableViewDelegate,HXCutPhotoViewControllerDelegate>

@property (nonatomic,assign) ImagePickerControllerSourceType sourceType;//类型 默认相机

#pragma mark - 相册目录及图片

@property (nonatomic,strong) UITableView *dropDownTableView;
@property (nonatomic,strong) NSArray *groupAry;//相册字典

#pragma mark - 照相机展示

@property (nonatomic,strong) SCCaptureSessionManager *captureManager;//照相机界面
@property (nonatomic,strong) UIButton *takePictureButton;//拍照按钮
@property (nonatomic,strong) UIButton *cutTakeTypeButton;//切换前后置摄像头

#pragma mark - 相册展示

@property (nonatomic,strong) UIView *footerView;//底部相册View
@property (nonatomic,strong) NSArray *collectionAry;//照片

#pragma mark - 选择的照片展示以及数组

@property (nonatomic,strong) HXCardSwitchView *cardSwitchView;
@property (nonatomic,strong) NSMutableArray *selectAry;//选择的照片数组

#pragma mark - 裁剪照片
@property (nonatomic,strong) NSMutableArray *cropAry;//需要裁剪的照片数组
@property (nonatomic,assign) NSInteger cropIndex;//当前裁剪的index
@property (nonatomic,assign) BOOL once;

@property (nonatomic,assign) BOOL isUp; //titleView 箭头是否朝上 初始化为NO

@end

@implementation HXPhotosViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _sourceType = ImagePickerControllerSourceTypeCamera;
        _selectAry = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removedRefreshing];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor blackColor];
    [self setLeftItemWithIcon:nil title:@"取消" selector:@selector(backAction:)];
    
    [self setRightBarButtonItems:nil];
    
    [self.view addSubview:self.dropDownTableView];
    //TableView
    [self hideDropDownTableView];
    [self.dropDownTableView reloadData];
    
    //添加footerView
    [self.view addSubview:self.footerView];
    [self showPartFooterView];
    
    [self.view bringSubviewToFront:self.dropDownTableView];
    
    [ASSETHELPER getGroupList:^(NSArray *groupAry) {
        _groupAry = groupAry;
    }];
    
    [self showCamera];
}

- (void)getCameraRoll {
    [ASSETHELPER getSavedPhotoList:^(NSArray *photoAry) {
        _collectionAry = photoAry;

        [self showPartFooterView];

        [self.collectionView reloadData];
    } error:^(NSError *error) {
        
    }];
}

#pragma mark - Delegate

#pragma mark UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _groupAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = @"HXPhotoCell";
    
    HXPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[HXPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *dic = [ASSETHELPER getGroupInfo:indexPath.row];
    
    [cell setData:dic delegate:nil];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _sourceType = ImagePickerTypePhotoLibrary;
    [self didSelectRowAtIndex:indexPath.row];
}

#pragma mark UICollectionView

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ((_sourceType == ImagePickerControllerSourceTypeCamera) && _collectionAry.count > 4) {
        return 5;
    }
    return _collectionAry.count + 1;
}

//每个UICollectionView展示的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * cellIdentifier = @"HXPhotoFirstCollectionViewCell";
    if (indexPath.row > 0) {
        cellIdentifier = @"HXPhotoSecondCollectionViewCell";
    }
    
    BaseCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row > 0) {
        ALAsset *asset = _collectionAry[indexPath.row - 1];
        NSString *str = [NSString stringWithFormat:@"%ld",[self isExistence:asset]];
        
        NSDictionary *dic = @{@"url":asset,
                              @"num":str
                              };
        [cell setData:dic delegate:nil];
    } else {
        NSDictionary *dataDic;
        if (_sourceType == ImagePickerControllerSourceTypeCamera) {
            dataDic = @{@"image":@"photoalbum",
                        @"title":@"相册"};
        } else if (_sourceType == ImagePickerTypePhotoLibrary) {
            dataDic = @{@"image":@"camara1",
                        @"title":@"相机"};
        }
        [cell setData:dataDic delegate:nil];
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((self.view.frame.size.width - 5*6) / 5, (self.view.frame.size.width - 5*6) / 5);
}

// 设置每个cell上下左右相距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 0, 5);
}

//// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

//UICollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row > 0) {
        _sourceType = ImagePickerTypePhotoLibrary;
        
        ALAsset *asset = _collectionAry[indexPath.row - 1];
        NSInteger index = [self isExistence:asset];
        if (index > 0) {
            [_selectAry removeObject:asset];
            
            [self addOrDeleWithIndex:index - 1 type:@"dele"];

        } else {
            if (_selectAry.count == _photoCount && _photoCount != 1) {
                [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"最多只能添加%ld张照片",(long)_photoCount]];
                return;
            } else {
                if (_photoCount == 1) {
                    [_selectAry removeAllObjects];
                }
            }
            [_selectAry addObject:asset];
        
            [self addOrDeleWithIndex:0 type:@"add"];
        }

        [self setRightBarButtonItems:[NSString stringWithFormat:@"%lu",(unsigned long)_selectAry.count]];
        
        [self hideCamera];
    } else {
        //相册/相机切换
        if (_sourceType == ImagePickerControllerSourceTypeCamera) {
            _sourceType = ImagePickerTypePhotoLibrary;

            [self addOrDeleWithIndex:0 type:@"add"];
            
            [self hideCamera];
        } else if (_sourceType == ImagePickerTypePhotoLibrary) {
            _sourceType = ImagePickerControllerSourceTypeCamera;
            [self showCamera];
        }
    }
    
    [UIView animateWithDuration:1.0 animations:^{
        [self.collectionView reloadData];
    }];
}

- (void)addOrDeleWithIndex:(NSInteger)index type:(NSString *)type {
    if ([type isEqualToString:@"add"]) {
        //添加
        [self.cardSwitchView setCardSwitchViewAry:_selectAry];
        
        if (_sourceType == ImagePickerTypePhotoLibrary) {
            self.cardSwitchView.hidden = NO;
        } else {
            self.cardSwitchView.hidden = YES;
        }
    } else {
        //删除
        [self.cardSwitchView deleteWithIndex:index];
    }
}

//判断一个图片是否是选中的
- (NSInteger)isExistence:(ALAsset *)asset {
    
    __block NSInteger index = 0;
    [_selectAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ALAsset class]]) {
            ALAsset *set = (ALAsset *)obj;
            
            if ([[[[set defaultRepresentation] url] description] isEqualToString:[[[asset defaultRepresentation] url] description]]) {
                index = idx + 1;
            }
        }
    }];
    return index;
}

#pragma mark HXCardSwitchViewDelegate 小图查看 代理

- (void)cardSwitchViewDidScroll:(HXCardSwitchView *)cardSwitchView index:(NSInteger)index {
    NSLog(@"当前照片index:%ld",(long)index);
}

#pragma mark 照片存储代理

//保存照片至本机
- (void)saveImageToPhotoAlbum:(UIImage*)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了!" message:@"存不了T_T" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        NSLog(@"保存成功");
        [ASSETHELPER getGroupList:^(NSArray *groupAry) {
            _groupAry = groupAry;
        }];
        
        [self getCameraRoll];
    }
}

#pragma mark - Action

- (void)addTakePictureButton {
    UIImage *image = [UIImage imageNamed:@"camara_click"];
    _takePictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    float height = (CONTENT_HEIGHT - ((self.view.frame.size.width - 5*6) / 5 + 30) - self.captureManager.previewLayer.frame.size.height - image.size.height)/2;
    _takePictureButton.frame = CGRectMake(0,self.captureManager.previewLayer.frame.size.height + height + 10, image.size.width, image.size.height);
    [_takePictureButton setImage:image forState:UIControlStateNormal];
    [_takePictureButton addTarget:self action:@selector(takePictureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_takePictureButton];
    _takePictureButton.frameCenterX = kScreenWidth/2;
}

- (void)addCutTakeTypeButton {
    UIImage *image = [UIImage imageNamed:@"camara2"];
    UIImage *selectImage = [UIImage imageNamed:@"camara2"];
    _cutTakeTypeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cutTakeTypeButton.frame = CGRectMake(0, self.captureManager.previewLayer.frame.origin.y + self.captureManager.previewLayer.frame.size.height + 40, image.size.width, image.size.height);
    [_cutTakeTypeButton setImage:image forState:UIControlStateNormal];
    [_cutTakeTypeButton setImage:selectImage forState:UIControlStateSelected];
    [_cutTakeTypeButton addTarget:self action:@selector(switchCameraBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_cutTakeTypeButton];
    _cutTakeTypeButton.frameOriginX = kScreenWidth - _cutTakeTypeButton.frameSizeWidth - 30;
    _cutTakeTypeButton.frameCenterY = _takePictureButton.frameCenterY;
}

//拍照
- (void)takePictureButtonAction:(UIButton *)sender {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"设备不支持拍照功能T_T");
        return;
    }
    
    sender.userInteractionEnabled = NO;
    
    //@weakify(self)
    __weak __typeof(&*self)weakSelf_SC = self;
    [self.captureManager takePicture:^(UIImage *stillImage) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //@strongify(self)
            [weakSelf_SC saveImageToPhotoAlbum:stillImage];
        });
        
        double delayInSeconds = 2.f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            sender.userInteractionEnabled = YES;
        });
    }];
}

//拍照页面，切换前后摄像头按钮按钮
- (void)switchCameraBtnPressed:(UIButton*)sender {
    sender.selected = !sender.selected;
    [self.captureManager switchCamera:sender.selected];
}

- (void)showCamera {
    [self getCameraRoll];
    
    self.captureManager.previewLayer.hidden = NO;
    _takePictureButton.hidden = NO;
    _cutTakeTypeButton.hidden = NO;
    
    self.title = @"相机";
    [self sellTitleViewForTitle:nil];
    
    self.cardSwitchView.hidden = YES;
}

- (void)sellTitleViewForTitle:(NSString *)title {
    self.navigationItem.titleView = nil;
    if (title.length == 0) {
        return;
    }
    
    UIImage *icon = [UIImage imageNamed:@"arrow_down_down"];
    
    if (_isUp) {
        icon = [UIImage imageNamed:@"arrow_up_up"];
        
    }
    
    if (kStatusBarStyle == UIStatusBarStyleLightContent) {
        icon = [icon imageToColor:kUIToneTextColor];
    }
    
    float width = 13;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:kUIToneTextColor forState:UIControlStateNormal];
    [btn setTitleColor:kUIToneTextColor forState:UIControlStateHighlighted];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -width, 0, width);
    //title与ico的间隔5
    CGSize titleSize = [title ex_sizeWithFont:btn.titleLabel.font constrainedToSize:CGSizeMake(kScreenWidth, MAXFLOAT)];
    float leight = titleSize.width + 5;
    if (icon) {
        leight += width;
        [btn setImage:icon forState:UIControlStateNormal];
        [btn setImage:icon forState:UIControlStateHighlighted];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, leight -width, 0, -leight + width);
    }
    [btn setFrame:CGRectMake(0, 0, leight, 30)];
    
    self.navigationItem.titleView = btn;
}

- (void)click:(UIButton *)sender {
    _isUp = !_isUp;
    [self titleViewButtonAction:_isUp];
    [self sellTitleViewForTitle:sender.titleLabel.text];
}

- (void)hideCamera {
    //相机隐藏
    self.captureManager.previewLayer.hidden = YES;
    //拍照按钮隐藏
    _takePictureButton.hidden = YES;
    //前后置按钮切换隐藏
    _cutTakeTypeButton.hidden = YES;
    
    [self showAllFooterView];

    if (_groupAry.count > 0) {
        self.isUp = NO;
        [self sellTitleViewForTitle:@"相机胶卷"];
    }
}

- (void)setRightBarButtonItems:(NSString *)redDotValue {
    NSMutableArray *ary = [NSMutableArray new];
    
    UIBarButtonItem *item = [self ittemRightItemWithTitle:@"下一步" selector:@selector(nextButtonAction:)];
    [ary addObject:item];
    
    if (redDotValue.intValue > 0) {
        item = [[UIBarButtonItem alloc] initWithCustomView:[self ittemRedViewWithRedDotValue:redDotValue]];
        [ary addObject:item];
    }
    
    self.navigationItem.rightBarButtonItems = ary;
}

- (UIView *)ittemRedViewWithRedDotValue:(NSString *)redDotValue {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [UILabel new];
    if (kUIToneTextColor == [UIColor whiteColor]) {
        label.backgroundColor = [UIColor redColor];
        label.textColor = [UIColor whiteColor];
    } else {
        label.backgroundColor = kUIToneTextColor;
        label.textColor = kUIToneBackgroundColor;
    }
    
    label.text = redDotValue;
    label.textAlignment = NSTextAlignmentCenter;
    
    float leight = 20;
    float height = 20;
    if (redDotValue.intValue > 9) {
        leight = 30;
        height = 20;
    }
    label.layer.cornerRadius = height/2;
    label.layer.masksToBounds = YES;
    label.frame = CGRectMake(0, 0, leight, height);
    
    view.frame = CGRectMake(0, 0, leight, height);
    [view addSubview:label];
    return view;
}

- (void)titleViewButtonAction:(BOOL)isUp {
    //点击事件处理
    if (isUp) {
        NSLog(@"显示");
        [self showDropDownTableView];
    } else {
        NSLog(@"隐藏");
        [self hideDropDownTableView];
    }
}

- (void)nextButtonAction:(UIButton *)sender {
    if (_once) {
        NSLog(@"已经点过一次了");
        return;
    }
    
    if (self.selectAry.count > 0) {
    
        _once = YES;
        
        [self.selectAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[ALAsset class]]) {
                UIImage *finalImaage = [ASSETHELPER getImageFromAsset:obj type:ASSET_PHOTO_SCREEN_SIZE];
                finalImaage = [UIImage imageCompressionRatio:finalImaage];
                self.selectAry[idx] = finalImaage;
            }
        }];
        
        self.cropAry = self.selectAry;
        [self gotoCutPhotoViewController];
        
    } else {
        [SVProgressHUD showInfoWithStatus:@"请添加图片"];
    }
}

- (void)didSelectRowAtIndex:(NSInteger)index {
    if (_sourceType == ImagePickerControllerSourceTypeCamera) {
        self.title = @"相机";
    } else {
        NSDictionary *dic = [ASSETHELPER getGroupInfo:index];
        NSString *name = dic[@"name"];
        self.isUp = NO;
        [self sellTitleViewForTitle:name];
        [self hideDropDownTableView];
        
        [ASSETHELPER getPhotoListOfGroupByIndex:index result:^(NSArray *photoAry) {
            _collectionAry = photoAry;
            [self showAllFooterView];
            [self.collectionView reloadData];
        }];
    }
}

- (void)showDropDownTableView {
    self.dropDownTableView.hidden = NO;
    float height = _groupAry.count*56;
    if (height > CONTENT_HEIGHT) {
        height = CONTENT_HEIGHT;
    }
    self.dropDownTableView.frame = CGRectMake(0, 0, self.dropDownTableView.frame.size.width,height);
    self.dropDownTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.dropDownTableView.contentOffset = CGPointMake(0, 0);
    [self.dropDownTableView reloadData];
}

- (void)hideDropDownTableView {
    self.dropDownTableView.hidden = YES;
    self.dropDownTableView.frame = CGRectMake(0, 0, _dropDownTableView.frame.size.width,0);
    self.dropDownTableView.contentOffset = CGPointMake(0, 0);
    self.dropDownTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.dropDownTableView reloadData];
}

//显示所有
- (void)showAllFooterView {
    self.footerView.frame = CGRectMake(0, CONTENT_HEIGHT - (CONTENT_HEIGHT - CardSwitchViewHeight), kScreenWidth, CONTENT_HEIGHT - CardSwitchViewHeight);
    self.collectionView.frame = CGRectMake(0, 10, kScreenWidth, self.footerView.frame.size.height - 10);
}

//显示部分
- (void)showPartFooterView {
    float height = (self.view.frame.size.width - 5*6) / 5 + 30;
    self.footerView.frame = CGRectMake(0, CONTENT_HEIGHT - height, self.view.frame.size.width,height);
    self.collectionView.frame = CGRectMake(0, 10, self.view.frame.size.width,height);
    self.collectionView.contentOffset = CGPointMake(0, 0);
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - Go To

//去图片裁剪页面
- (void)gotoCutPhotoViewController {
    CGSize cropSize;
    NSString *title;
    BOOL isLast;

    cropSize = CGSizeMake(kScreenWidth, kScreenWidth);
    title = [NSString stringWithFormat:@"裁剪（%ld/%lu）",(long)_cropIndex+1,(unsigned long)self.cropAry.count];
    if (_cropIndex+1 == self.cropAry.count) {
        isLast = YES;
    } else {
        isLast = NO;
    }
    UIImage *image = self.cropAry[_cropIndex];
    
    HXCutPhotoViewController *imgCropperViewController = [[HXCutPhotoViewController alloc] initWithImage:image  cropSize:cropSize title:title isLast:isLast];
    imgCropperViewController.delegate = self;
    [self.navigationController pushViewController:imgCropperViewController animated:YES];
}

#pragma mark - UzysImageCropperDelegate

- (void)imageCropper:(HXCutPhotoViewController *)cropper didFinishCroppingWithImage:(UIImage *)image {
    self.cropAry[_cropIndex] = image;
    
    if (self.cropAry.count > 0 && _cropIndex == self.cropAry.count - 1) {
        if (_completion) {
            _completion(self,self.cropAry);
        }
        return;
    }
    _cropIndex++;
    [self gotoCutPhotoViewController];
}

#pragma mark - 懒加载

#pragma mark 相册目录表

- (UITableView *)dropDownTableView {
    if (!_dropDownTableView) {
        _dropDownTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.view.frame.size.height) style:UITableViewStylePlain];
        _dropDownTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _dropDownTableView.dataSource = self;
        _dropDownTableView.delegate = self;
        [_dropDownTableView registerNib:[UINib nibWithNibName:@"HXPhotoCell" bundle:nil] forCellReuseIdentifier:@"HXPhotoCell"];
        _dropDownTableView.backgroundColor = [UIColor clearColor];
        _dropDownTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _dropDownTableView;
}

#pragma mark 照相机

- (SCCaptureSessionManager *)captureManager {

    if (!_captureManager) {
        //session manager
        _captureManager = [[SCCaptureSessionManager alloc] init];
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //判断相机是否可用
            CGRect previewRect = CGRectMake(0, 0, SC_APP_SIZE.width, SC_APP_SIZE.width);
            [_captureManager configureWithParentLayer:self.view previewRect:previewRect];
            [_captureManager.session startRunning];
            
            [self addTakePictureButton];
            
            [self addCutTakeTypeButton];
        }
    }
    return _captureManager;
}

#pragma mark - 相册小图

- (HXCardSwitchView *)cardSwitchView {
    if (!_cardSwitchView) {
        _cardSwitchView = [[HXCardSwitchView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, CardSwitchViewHeight)];
        _cardSwitchView.backgroundColor = kUIToneTextColor;
        _cardSwitchView.layout.itemSize = CGSizeMake(kScreenWidth - 40, 243);

        [self.view addSubview:_cardSwitchView];
        [self.view sendSubviewToBack:_cardSwitchView];
    }
    return _cardSwitchView;
}

- (UIView *)footerView {
    if (!_footerView) {
        float height = (kScreenWidth - 5*6) / 5 + 30;
        
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, CONTENT_HEIGHT - height, kScreenWidth,height)];
        _footerView.backgroundColor = [UIColor blackColor];
        
        //创建一屏的视图大小
        self.collectionView.frame = CGRectMake(0, 10, _footerView.frame.size.width, _footerView.frame.size.height - 10);
        [self.collectionView registerNib:[UINib nibWithNibName:@"HXPhotoFirstCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HXPhotoFirstCollectionViewCell"];
        [self.collectionView registerNib:[UINib nibWithNibName:@"HXPhotoSecondCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HXPhotoSecondCollectionViewCell"];
        self.collectionView.backgroundColor = [UIColor clearColor];
        [_footerView addSubview:self.collectionView];
    }
    return _footerView;
}

- (NSMutableArray *)cropAry {
    if (!_cropAry) {
        _cropAry = [NSMutableArray new];
    }
    return _cropAry;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
