//
//  UzysImageCropper.h
//  UzysImageCropper
//
//  Created by Uzys on 11. 12. 13..
//

#import <UIKit/UIKit.h>

@interface UzysImageCropper : UIView <UIGestureRecognizerDelegate>
{
    double _imageScale; //frame : image
    double _translateX;
    double _translateY;
    
    CGRect _imgViewframeInitValue; //imgView는 가운데 정렬 되므로 초기값 위치가 (0,0)이 아니므로 위치를 알아야함
    CGPoint _imgViewcenterInitValue;
    CGSize _realCropsize;
    UIView* _cropperView;
}
@property (nonatomic,strong) UIImage *inputImage;
@property (nonatomic,strong) UIImageView *imgView;
@property (nonatomic,assign) CGRect cropRect;

- (id)initWithImage:(UIImage*)newImage andframeSize:(CGSize)frameSize andcropSize:(CGSize)cropSize;
- (UIImage*) getCroppedImage;
- (BOOL) saveCroppedImage:(NSString *)path;

- (void) actionRotate;
- (void) actionRestore;
@end
