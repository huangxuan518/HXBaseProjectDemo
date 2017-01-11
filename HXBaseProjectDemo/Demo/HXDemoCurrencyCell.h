//
//  HXDemoCurrencyCell.h
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/10/27.
//  Copyright © 2016年 Yiss Inc. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface HXDemoCurrencyCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *littleRedDotLabel;

@end



#pragma mark - Model

@interface HXDemoCurrencyCellModel : NSObject

@property (nonatomic,copy) NSString *icoName;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,assign) BOOL isLittleRedDot;

+ (HXDemoCurrencyCellModel *)ittemModelWithIcoName:(NSString *)icoName title:(NSString *)title isLittleRedDot:(BOOL)isLittleRedDot;

@end
