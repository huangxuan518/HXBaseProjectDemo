//
//  HXCurrencyAddPhotoCell.h
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/1/14.
//  Copyright © 2016年 IT小子. All rights reserved.
//

#import "BaseTableViewCell.h"

#define kMaxPhotoNum 4
#define HXCurrencyAddPhotoCellRowPhotoCount 4 //每一行的数量
#define HXCurrencyAddPhotoCellRowPhotoSpace 5 //照片间隔
#define HXCurrencyAddPhotoCellCollectionViewX 5 //x坐标
#define HXCurrencyAddPhotoCellCollectionViewY 5 //y坐标

@class HXCurrencyAddPhotoCell;

@protocol HXCurrencyAddPhotoCellDelegate <NSObject>

@optional
- (void)currencyAddPhotoCell:(HXCurrencyAddPhotoCell *)cell didSelectItem:(id)selectItem;
- (void)currencyAddPhotoCellAddPhotoButtonAction;

@end

@interface HXCurrencyAddPhotoCell : BaseTableViewCell

@property (nonatomic,weak) id <HXCurrencyAddPhotoCellDelegate> delegate;

@end


@interface HXCurrencyAddPhotoCellModel : NSObject

@property (nonatomic,strong) NSArray *imageAry;//图片数组

+ (HXCurrencyAddPhotoCellModel *)ittemModelWithImageAry:(NSArray *)imageAry;

@end
