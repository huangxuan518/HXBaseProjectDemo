//
//  HXCurrencyAddPhotoCell.m
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/1/14.
//  Copyright © 2016年 IT小子. All rights reserved.
//

#import "HXCurrencyAddPhotoCell.h"
#import "HXCurrencyAddPhotoCollectionViewCell.h"

#define  Identifier @"HXCurrencyAddPhotoCollectionViewCell"


@interface HXCurrencyAddPhotoCell () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *ary;
@property (weak, nonatomic) IBOutlet UILabel *addCommodityPhotoTip;
@property (weak, nonatomic) IBOutlet UILabel *addCommodityPhotoTip2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipOrginConstraint;
@property (strong, nonatomic) HXCurrencyAddPhotoCellModel *model;

@end

@implementation HXCurrencyAddPhotoCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    [self addSubview:self.collectionView];
    
    _addCommodityPhotoTip.text = @"请添加您的物品图片";
    
    CGSize size = [_addCommodityPhotoTip.text ex_sizeWithFont:_addCommodityPhotoTip.font constrainedToSize:CGSizeMake(kScreenWidth, MAXFLOAT)];
    _tipOrginConstraint.constant = size.width + 10;
    
    _addCommodityPhotoTip2.text = @"(支持JPG,JPEG,GIF.PNG格式)";
}

- (void)setData:(id)data delegate:(id)delegate {
    _delegate = delegate;
    if ([data isKindOfClass:[NSDictionary class]]) {        
        if ([data[@"data"] isKindOfClass:[HXCurrencyAddPhotoCellModel class]]) {
            _model = data[@"data"];
            _ary = _model.imageAry;

            [self.collectionView reloadData];
        }
    }
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = _ary.count + 1;
    if (kMaxPhotoNum - _ary.count <= 0) {
        count = _ary.count;
    }
    if (_ary.count > kMaxPhotoNum) {
        return kMaxPhotoNum;
    }
    return count;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = Identifier;
    BaseCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dic;
    if (indexPath.row == _ary.count && _ary.count < kMaxPhotoNum) {
        dic = @{@"type":@"add",
                @"url":@"demand_addimage"};
    } else {
        id image = _ary[indexPath.row];
        
        if ([image isKindOfClass:[NSString class]]) {
            NSString *url = (NSString *)image;
            dic = @{@"type":@"photo",
                    @"url":kSafeString(url)};
        }else if ([image isKindOfClass:[UIImage class]]){
            dic = @{@"type":@"photoImageClass",
                    @"url":image};
        }
    }
    [cell setData:dic delegate:nil];

    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float width = (self.collectionView.frameSizeWidth - (HXCurrencyAddPhotoCellRowPhotoSpace*(HXCurrencyAddPhotoCellRowPhotoCount + 1))) / HXCurrencyAddPhotoCellRowPhotoCount;
    return CGSizeMake(width, width);
}

// 设置每个cell上下左右相距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(HXCurrencyAddPhotoCellRowPhotoSpace, HXCurrencyAddPhotoCellRowPhotoSpace, 0, HXCurrencyAddPhotoCellRowPhotoSpace);
}

//// 设置最小行间距，也就是前一行与后一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return HXCurrencyAddPhotoCellRowPhotoSpace;
}

// 设置最小列间距，也就是左行与右一行的中间最小间隔
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return HXCurrencyAddPhotoCellRowPhotoSpace;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _ary.count && _ary.count < kMaxPhotoNum) {
        //添加
        if (_delegate && [_delegate respondsToSelector:@selector(currencyAddPhotoCellAddPhotoButtonAction)]) {
            [_delegate currencyAddPhotoCellAddPhotoButtonAction];
        }
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(currencyAddPhotoCell:didSelectItem:)]) {
            [_delegate currencyAddPhotoCell:self didSelectItem:_ary[indexPath.row]];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frameSizeHeight = self.frameSizeHeight - 22;
}

+ (float)getCellFrame:(id)msg {
    int photoCount;
    if ([msg isKindOfClass:[NSArray class]]) {
        NSArray *ary = msg;
        photoCount = (int)ary.count;
        if (photoCount > kMaxPhotoNum) {
            photoCount = kMaxPhotoNum;
        }
    }
    
    if ((kMaxPhotoNum - photoCount) <= 0) {
        photoCount = photoCount - 1;
    }
    //(UICollectionView的宽度等于全屏的宽度减左右间隙 - CollectionViewCell间的间隙和) 除以 每行的数量
    float width = ((kScreenWidth - HXCurrencyAddPhotoCellCollectionViewX*2) - (HXCurrencyAddPhotoCellRowPhotoSpace*(HXCurrencyAddPhotoCellRowPhotoCount + 1))) / HXCurrencyAddPhotoCellRowPhotoCount;
    float height = width;
    
    //照片上边距 + 照片行数 * （照片高度 + 间隙） + 下边文字固定高度
    return HXCurrencyAddPhotoCellCollectionViewY*2 + (photoCount / HXCurrencyAddPhotoCellRowPhotoCount + 1)*(height + HXCurrencyAddPhotoCellRowPhotoSpace) + 22;
}

#pragma mark - 懒加载

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //先实例化一个层
        UICollectionViewFlowLayout *layout= [UICollectionViewFlowLayout new];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        //创建一屏的视图大小
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(HXCurrencyAddPhotoCellCollectionViewX, HXCurrencyAddPhotoCellCollectionViewY, kScreenWidth - HXCurrencyAddPhotoCellCollectionViewX*2, 10) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:Identifier bundle:nil] forCellWithReuseIdentifier:Identifier];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

@end


@implementation HXCurrencyAddPhotoCellModel

+ (HXCurrencyAddPhotoCellModel *)ittemModelWithImageAry:(NSArray *)imageAry {
    HXCurrencyAddPhotoCellModel *model = [HXCurrencyAddPhotoCellModel new];
    model.imageAry = imageAry;
    return model;
}

@end
