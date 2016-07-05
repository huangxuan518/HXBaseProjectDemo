//
//  BaseTableViewCell.h
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/1/14.
//  Copyright © 2016年 IT小子. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SecondHouseCellType) {
    SecondHouseCellTypeFirst,
    SecondHouseCellTypeMiddle,
    SecondHouseCellTypeLast,
    SecondHouseCellTypeSingle,
    SecondHouseCellTypeAny,
    SecondHouseCellTypeHaveTop,
    SecondHouseCellTypeHaveBottom,
    SecondHouseCellTypeNone
};

@interface BaseTableViewCell : UITableViewCell

/**
 *  分隔线的颜色值,默认为(208,208,208)
 */
@property (nonatomic,strong) UIColor *lineColor;
/**
 *  分隔线是上,还是下,还是中间的
 */
@property(nonatomic,assign)SecondHouseCellType cellType;

/**
 *  上横线
 */
@property (strong, nonatomic)  UIImageView *lineviewTop;

/**
 *  下横线,都是用来分隔cell的
 */
@property (strong, nonatomic)  UIImageView *lineviewBottom;

/**
 *  标识分隔线是不是ios7的风格,ios7的风格,是中间的分隔线都会在最前面留一些空
 */
@property(nonatomic,assign)BOOL ios7SeperatorStyle;


/**
 *  分割线了偏移量,默认是15,只是在IOS7模式下才起作用,也就是ios7SeperatorStyle为YES
 */
@property(nonatomic,assign) int separateLineOffset;

-(void)setCellType:(SecondHouseCellType)type;

-(void)setSeperatorLineForIOS7 :(NSIndexPath *)indexPath numberOfRowsInSection: (NSInteger)numberOfRowsInSection;
-(void)setSeperatorLine:(NSIndexPath *)indexPath numberOfRowsInSection: (NSInteger)numberOfRowsInSection;

- (void)setData:(id)data delegate:(id)delegate;

+ (float)getCellFrame:(id)msg;

@end


@interface UIImage (MGTint)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

@end
