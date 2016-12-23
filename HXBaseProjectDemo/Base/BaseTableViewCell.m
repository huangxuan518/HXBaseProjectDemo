//
//  BaseTableViewCell.m
//  黄轩博客 blog.libuqing.com
//
//  Created by 黄轩 on 16/1/14.
//  Copyright © 2016年 IT小子. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BaseTableViewCell ()

@property (nonatomic,strong) UIColor *lineColor;//分隔线的颜色值,默认为(208,208,208)
@property(nonatomic,assign)SecondHouseCellType cellType;//分隔线是上,还是下,还是中间的
@property(nonatomic,assign)BOOL ios7SeperatorStyle;//标识分隔线是不是ios7的风格,ios7的风格,是中间的分隔线都会在最前面留一些空
@property(nonatomic,assign) int separateLineOffset;//分割线了偏移量,默认是15,只是在IOS7模式下才起作用,也就是ios7SeperatorStyle为YES
@property(nonatomic,assign) BOOL isInitialize;//是否初始化

@end

@implementation BaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self internalInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self internalInit];
    }
    return self;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self internalInit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    _lineviewTop.image =  [UIImage imageWithColor:_lineColor size:_lineviewTop.frame.size];
    _lineviewTop.backgroundColor = lineColor;
    _lineviewBottom.image = [UIImage imageWithColor:_lineColor size:_lineviewBottom.frame.size];
    _lineviewBottom.backgroundColor = lineColor;
    
}

- (void)internalInit {
    if (_isInitialize) {
        return;
    }
    _lineColor = UIColorFromHex(0xD8D8D8);
    _isInitialize = YES;
    
    _lineviewTop = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
    _lineviewTop.backgroundColor = _lineColor;
    _lineviewTop.image = [UIImage imageWithColor:_lineColor size:_lineviewTop.frame.size];
    
    _lineviewBottom = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5)];
    _lineviewBottom.image = [UIImage imageWithColor:_lineColor size:_lineviewBottom.frame.size];
    _lineviewBottom.backgroundColor = _lineColor;
    
    
    [self addSubview:_lineviewBottom];
    [self addSubview:_lineviewTop];
    
    //初始化的时候隐藏线
    _lineviewTop.hidden = YES;
    _lineviewBottom.hidden = YES;
}

- (void)setCellType:(SecondHouseCellType)type {
    _cellType = type;
    switch (type) {
            
        case SecondHouseCellTypeFirst:
            _lineviewTop.hidden = NO;
            _lineviewBottom.hidden = YES;
            break;
        case SecondHouseCellTypeMiddle:
            _lineviewTop.hidden = NO;
            _lineviewBottom.hidden = YES;
            break;
        case SecondHouseCellTypeLast:
            _lineviewTop.hidden = NO;
            _lineviewBottom.hidden = NO;
            break;
        case SecondHouseCellTypeSingle:
            _lineviewTop.hidden = NO;
            _lineviewBottom.hidden = NO;
            break;
        case SecondHouseCellTypeAny:
            _lineviewTop.hidden = YES;
            _lineviewBottom.hidden = YES;
            break;
        case SecondHouseCellTypeHaveTop:
            _lineviewTop.hidden = NO;
            _lineviewBottom.hidden = YES;
            break;
        case SecondHouseCellTypeHaveBottom:
            _lineviewTop.hidden = YES;
            _lineviewBottom.hidden = NO;
            break;
        default:
            break;
            
    }
    [self setNeedsLayout];
}

- (int)separateLineOffset {
    if (_separateLineOffset == 0) {
        _separateLineOffset = 0;   // 默认15
    }
    return _separateLineOffset;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (_ios7SeperatorStyle) {
        
        switch (_cellType) {
                
            case SecondHouseCellTypeFirst:
                _lineviewTop.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
                _lineviewBottom.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width , 0.5);
                break;
            case SecondHouseCellTypeMiddle:
                _lineviewTop.frame = CGRectMake(self.separateLineOffset, 0, self.frame.size.width - self.separateLineOffset, 0.5);
                _lineviewBottom.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width , 0.5);
                break;
            case SecondHouseCellTypeLast:
                _lineviewTop.frame = CGRectMake(self.separateLineOffset, 0, self.frame.size.width - self.separateLineOffset, 0.5);
                
                _lineviewBottom.frame = CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width , 0.5);
                break;
            case SecondHouseCellTypeSingle:
                _lineviewTop.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
                _lineviewBottom.frame =CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
                break;
            case SecondHouseCellTypeAny:
                _lineviewTop.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
                _lineviewBottom.frame =CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
                break;
                
            default:
                break;
        }
        
    }
    else {
        _lineviewTop.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
        _lineviewBottom.frame =CGRectMake(0, self.frame.size.height - 0.5, self.frame.size.width, 0.5);
    }
}

- (void)setSeperatorLineForIOS7 :(NSIndexPath *)indexPath numberOfRowsInSection: (NSInteger)numberOfRowsInSection {
    [self setIos7SeperatorStyle:YES];
    if (indexPath.row == 0 && numberOfRowsInSection == 1){
        [self setCellType:SecondHouseCellTypeSingle];
    }
    else if (indexPath.row == 0 && numberOfRowsInSection > 1){
        [self setCellType:SecondHouseCellTypeFirst];
    }
    else if (indexPath.row > 0 && indexPath.row < numberOfRowsInSection - 1 && numberOfRowsInSection > 2){
        [self setCellType:SecondHouseCellTypeMiddle];
    }
    else if (indexPath.row == numberOfRowsInSection - 1 && numberOfRowsInSection > 1){
        [self setCellType:SecondHouseCellTypeLast];
    }
}

- (void)setSeperatorLine:(NSIndexPath *)indexPath numberOfRowsInSection: (NSInteger)numberOfRowsInSection {
    if (indexPath.row == 0 && numberOfRowsInSection == 1){
        [self setCellType:SecondHouseCellTypeSingle];
    }
    else if (indexPath.row == 0 && numberOfRowsInSection > 1){
        [self setCellType:SecondHouseCellTypeFirst];
    }
    else if (indexPath.row > 0 && indexPath.row < numberOfRowsInSection - 1 && numberOfRowsInSection > 2){
        [self setCellType:SecondHouseCellTypeMiddle];
    }
    else if (indexPath.row == numberOfRowsInSection - 1 && numberOfRowsInSection > 1){
        [self setCellType:SecondHouseCellTypeLast];
    }
}

- (void)setData:(id)data delegate:(id)delegate {
    
}

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([self class])
                          bundle:[NSBundle mainBundle]];
}

+ (NSString *)reuseIdentifier {
    return NSStringFromClass([self class]);
}

+ (float)getCellFrame:(id)msg {
    if ([msg isKindOfClass:[NSNumber class]]) {
        NSNumber *number = msg;
        float height = number.floatValue;
        if (height > 0) {
            return height;
        }
    }
    return 44;
}

@end

@implementation UIImage (MGTint)

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, .0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [color set];
    CGContextFillRect(context, CGRectMake(.0, .0, size.width, size.height));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
