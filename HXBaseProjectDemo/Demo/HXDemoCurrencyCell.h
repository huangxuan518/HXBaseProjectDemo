//
//  HXDemoCurrencyCell.h
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/10/27.
//  Copyright © 2016年 Yiss Inc. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface HXDemoCurrencyCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end



#pragma mark - Model

@interface HXDemoCurrencyCellModel : NSObject

@property (nonatomic,copy) NSString *title;

+ (HXDemoCurrencyCellModel *)ittemModelWithTitle:(NSString *)title;

@end
