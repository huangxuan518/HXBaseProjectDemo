//
//  UzysImageCropper.m
//  UzysImageCropper
//
//  Created by Uzys on 11. 12. 13..
//

#define MAX_ZOOMSCALE 3

//#define CROPPERVIEW_IMG

#import "UzysImageCropper.h"
#import "UIImage-Extension.h"
#import <UIKit/UIGestureRecognizerSubclass.h>
#import <QuartzCore/QuartzCore.h>
@interface UzysImageCropper()
- (void)setupGestureRecognizer;
- (void)zoomAction:(UIGestureRecognizer *)sender;
- (void)panAction:(UIPanGestureRecognizer *)gesture;
- (void)RotationAction:(UIGestureRecognizer *)sender;
- (void)DoubleTapAction:(UIGestureRecognizer *)sender;
@end

@implementation UzysImageCropper
@synthesize imgView = _imgView,inputImage=_inputImage,cropRect=_cropRect;

#pragma mark - initialize
- (id)init
{
    self = [super init];
    if (self)
    {
        NSAssert(TRUE,@"Plz initialize using initWithImage:andframeSize:andcropSize: ");
    }
    
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        NSAssert(TRUE,@"Plz initialize using initWithImage:andframeSize:andcropSize: ");
    }
    return self;
}

- (id)initWithImage:(UIImage*)newImage andframeSize:(CGSize)frameSize andcropSize:(CGSize)cropSize
{
    self = [super init];
    if(self)
    {
        //Variable for GestureRecognizer
        _translateX =0;
        _translateY =0;
        
        self.frame = CGRectMake(0, 0, frameSize.width, frameSize.height);
        self.inputImage = newImage;
        //Case 1 실제 이미지를 frame Width size에 맞춤 --> 이미지가 커지면 크롭영역도 320x480의 프레임 영역에서 작게 표시됨.
        //_imageScale = frameSize.width / inputImage.size.width; //scale criteria depend on width size
        
        //Case 2 crop Width를 310에 고정 --> 크롭영역은 일정.
        _imageScale = cropSize.width/newImage.size.width ;
        
        CGRect imgViewBound = CGRectMake(0, 0, _inputImage.size.width*_imageScale, _inputImage.size.height*_imageScale);   //이미지가 생성될 사이즈.
        _imgView = [[UIImageView alloc] initWithFrame:imgViewBound];
        _imgView.center = self.center;
        _imgView.image = _inputImage;
        _imgView.backgroundColor = [UIColor whiteColor];
        
        _imgViewframeInitValue = _imgView.frame;
        _imgViewcenterInitValue = _imgView.center;
        _realCropsize = cropSize; // _realCropsize = Cropping Size in RealImage
        
        _cropRect = CGRectMake(0, (CONTENT_HEIGHT - cropSize.height)/2, cropSize.width, cropSize.height);

        //_cropperView show the view will crop.
        _cropperView = [[UIView alloc] initWithFrame:_cropRect];
        _cropperView.backgroundColor = [UIColor clearColor];
        _cropperView.layer.borderColor = [UIColor whiteColor].CGColor;
        _cropperView.layer.borderWidth = 1.5;
        
        [self addSubview:_imgView];
        [self addSubview:_cropperView];
        [self setupGestureRecognizer];
        
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _cropRect.origin.y)];
        topView.backgroundColor = [UIColor blackColor];
        topView.alpha = 0.7;
        topView.userInteractionEnabled = NO;
        
        [self addSubview:topView];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _cropRect.origin.y + _cropRect.size.height, kScreenWidth, (CONTENT_HEIGHT - _cropRect.size.height)/2)];
        bottomView.backgroundColor = [UIColor blackColor];
        bottomView.alpha = 0.7;
        bottomView.userInteractionEnabled = NO;
        
        [self addSubview:bottomView];
        
        self.clipsToBounds = YES;
    }
    return self;
}


#pragma mark - UIGestureAction
- (void)zoomAction:(UIGestureRecognizer *)sender
{
    CGFloat factor = [(UIPinchGestureRecognizer *)sender scale];
    static CGFloat lastScale=1;
    
    if([sender state] == UIGestureRecognizerStateBegan)
    {
        // Reset the last scale, necessary if there are multiple objects with different scales
        lastScale =1;
    }
    if ([sender state] == UIGestureRecognizerStateChanged
        || [sender state] == UIGestureRecognizerStateEnded)
    {
        CGRect imgViewFrame = _imgView.frame;
        CGFloat minX,minY,maxX,maxY,imgViewMaxX,imgViewMaxY;
        minX= CGRectGetMinX(_cropRect);
        minY= CGRectGetMinY(_cropRect);
        maxX= CGRectGetMaxX(_cropRect);
        maxY= CGRectGetMaxY(_cropRect);
        
        CGFloat currentScale = [[self.imgView.layer valueForKeyPath:@"transform.scale.x"] floatValue];
        // CGFloat currentScale = self.imgView.transform.a;
        const CGFloat kMaxScale = 2.0;
        CGFloat newScale = 1 -  (lastScale - factor); // new scale is in the range (0-1)
        newScale = MIN(newScale, kMaxScale / currentScale);
        
        //변화된 후의 imgViewFrame
        imgViewFrame.size.width = imgViewFrame.size.width * newScale;
        imgViewFrame.size.height = imgViewFrame.size.height * newScale;
        imgViewFrame.origin.x = self.imgView.center.x - imgViewFrame.size.width/2;
        imgViewFrame.origin.y = self.imgView.center.y - imgViewFrame.size.height/2;
        
        imgViewMaxX= CGRectGetMaxX(imgViewFrame);
        imgViewMaxY= CGRectGetMaxY(imgViewFrame);
        
        //역변환 공식
        NSInteger collideState = 0;
        
        if(imgViewFrame.origin.x >= minX) //left
        {
            collideState = 1;
        }
        else if(imgViewFrame.origin.y >= minY) // up
        {
            collideState = 2;
        }
        else if(imgViewMaxX <= maxX) //right
        {
            collideState = 3;
        }
        else if(imgViewMaxY <= maxY) //down
        {
            collideState = 4;
        }
        
        //        NSLog(@"scale :%f",newScale);
        if(collideState >0)  // 걸렸을 때
        {
            
            if(lastScale - factor <= 0) //확대 모션
            {
                lastScale = factor;
                CGAffineTransform transformN = CGAffineTransformScale(self.imgView.transform, newScale, newScale);
                self.imgView.transform = transformN;
            }
            else
            {
                lastScale = factor;
                
                CGPoint newcenter = _imgView.center;
                
                if(collideState ==1 || collideState ==3)
                {
                    newcenter.x = _cropperView.center.x;
                }
                else if(collideState ==2 || collideState ==4)
                {
                    newcenter.y = _cropperView.center.y;
                }
                
                [UIView animateWithDuration:0.5f animations:^(void) {
                    
                    self.imgView.center = newcenter;
                    [sender reset];
                    
                } ];
                
            }
            
        }
        else //정상일 때
        {
            CGAffineTransform transformN = CGAffineTransformScale(self.imgView.transform, newScale, newScale);
            self.imgView.transform = transformN;
            lastScale = factor;
        }
        
    }
    
}
- (void)panAction:(UIPanGestureRecognizer *)gesture
{
    
    static CGPoint prevLoc;
    CGPoint location = [gesture locationInView:self];
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        prevLoc = location; //Starting position
    }
    
    if ((gesture.state == UIGestureRecognizerStateChanged) || (gesture.state == UIGestureRecognizerStateEnded))
    {
        
        CGFloat minX,minY,maxX,maxY,imgViewMaxX,imgViewMaxY;
        
        //calculate offset
        _translateX =  (location.x - prevLoc.x);
        _translateY =  (location.y - prevLoc.y);
        
        // 회전이 있는 경우 기준
        CGPoint center = self.imgView.center;
        minX= CGRectGetMinX(_cropRect);
        minY= CGRectGetMinY(_cropRect);
        maxX= CGRectGetMaxX(_cropRect);
        maxY= CGRectGetMaxY(_cropRect);
        
        center.x =center.x +_translateX;
        center.y = center.y +_translateY;
        
        imgViewMaxX= center.x + _imgView.frame.size.width/2;
        imgViewMaxY= center.y+ _imgView.frame.size.height/2;
        
        if(  (center.x - (_imgView.frame.size.width/2) ) >= minX)
        {
            center.x = minX + (_imgView.frame.size.width/2) ;
        }
        if( center.y - (_imgView.frame.size.height/2) >= minY)
        {
            center.y = minY + (_imgView.frame.size.height/2) ;
        }
        if(imgViewMaxX <= maxX)
        {
            center.x = maxX - (_imgView.frame.size.width/2);
        }
        if(imgViewMaxY <= maxY)
        {
            center.y = maxY - (_imgView.frame.size.height/2);
        }
        
        self.imgView.center = center;
        prevLoc = location;
    }
}

- (void)RotationAction:(UIGestureRecognizer *)sender
{
    UIRotationGestureRecognizer *recognizer = (UIRotationGestureRecognizer *) sender;
    static CGFloat rot=0;
    //float RotationinDegrees = recognizer.rotation * (180/M_PI);
    if(sender.state == UIGestureRecognizerStateBegan)
    {
        rot = recognizer.rotation;
    }
    
    if(sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged)
    {
        self.imgView.transform = CGAffineTransformRotate(self.imgView.transform, recognizer.rotation - rot);
//        NSLog(@"imgViewFrame : %@",NSStringFromCGRect(self.imgView.frame));
        rot =recognizer.rotation;
        
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if(self.imgView.frame.size.width < _cropperView.frame.size.width || self.imgView.frame.size.height < _cropperView.frame.size.height)
        {
            double scale = MAX(_cropperView.frame.size.width/self.imgView.frame.size.width,_cropperView.frame.size.height/self.imgView.frame.size.height) + 0.01;
            
            self.imgView.transform = CGAffineTransformScale(self.imgView.transform,scale, scale);
        }
    }
    
}
- (void)DoubleTapAction:(UIGestureRecognizer *)sender
{
    //双击放大或者还原
    if (self.imgView.transform.a > 1 &&  self.imgView.transform.d > 1) {
        [UIView animateWithDuration:0.2f animations:^(void) {
            self.imgView.transform = CGAffineTransformIdentity;
            self.imgView.center = _cropperView.center;
        } ];
    } else {
        [UIView animateWithDuration:0.2f animations:^(void) {
            self.imgView.transform = CGAffineTransformScale(self.imgView.transform,2.0, 2.0);
            self.imgView.center = _cropperView.center;
        } ];
    }
}


- (void) setupGestureRecognizer
{
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoomAction:)];
    [pinchGestureRecognizer setDelegate:self];
    
     UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    [panGestureRecognizer setMinimumNumberOfTouches:1];
    [panGestureRecognizer setMaximumNumberOfTouches:1];
    [panGestureRecognizer setDelegate:self];
    
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DoubleTapAction:)];
    [doubleTapGestureRecognizer setDelegate:self];
    doubleTapGestureRecognizer.numberOfTapsRequired =2;
    
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(RotationAction:)];
    [rotationGestureRecognizer setDelegate:self];
    
    [self addGestureRecognizer:pinchGestureRecognizer];
    [self addGestureRecognizer:panGestureRecognizer];
    [self addGestureRecognizer:doubleTapGestureRecognizer];
    [self addGestureRecognizer:rotationGestureRecognizer];
    
}

- (UIImage*) getCroppedImage
{
    double zoomScale = [[self.imgView.layer valueForKeyPath:@"transform.scale.x"] floatValue];
    double rotationZ = [[self.imgView.layer valueForKeyPath:@"transform.rotation.z"] floatValue];
    
    CGPoint cropperViewOrigin = CGPointMake( (_cropperView.frame.origin.x - _imgView.frame.origin.x)  *1/zoomScale ,
                                            ( _cropperView.frame.origin.y - _imgView.frame.origin.y ) * 1/zoomScale
                                            );
    CGSize cropperViewSize = CGSizeMake(_cropperView.frame.size.width * (1/zoomScale) ,_cropperView.frame.size.height * (1/zoomScale));
    
    CGRect CropinView = CGRectMake(cropperViewOrigin.x, cropperViewOrigin.y, cropperViewSize.width  , cropperViewSize.height);
    
    NSLog(@"CropinView : %@",NSStringFromCGRect(CropinView));
    
    CGSize CropinViewSize = CGSizeMake((CropinView.size.width*(1/_imageScale)),(CropinView.size.height*(1/_imageScale)));
    
    
    if((NSInteger)CropinViewSize.width % 2 == 1)
    {
        CropinViewSize.width = ceil(CropinViewSize.width);
    }
    if((NSInteger)CropinViewSize.height % 2 == 1)
    {
        CropinViewSize.height = ceil(CropinViewSize.height);
    }
    
    CGRect CropRectinImage = CGRectMake((NSInteger)(CropinView.origin.x * (1/_imageScale)) ,(NSInteger)( CropinView.origin.y * (1/_imageScale)), (NSInteger)CropinViewSize.width,(NSInteger)CropinViewSize.height);
    
    UIImage *rotInputImage = [[_inputImage fixOrientation] imageRotatedByRadians:rotationZ];
    UIImage *newImage = [rotInputImage cropImage:CropRectinImage];
    
    if(newImage.size.width != _realCropsize.width)
    {
        newImage = [newImage resizedImageToFitInSize:_realCropsize scaleIfSmaller:YES];
    }
    
    return newImage;
}
- (BOOL) saveCroppedImage:(NSString *) path
{
    return [UIImagePNGRepresentation([self getCroppedImage]) writeToFile:path atomically:YES];
}
- (void) actionRotate
{
    [UIView animateWithDuration:0.15 animations:^{
        
        self.imgView.transform = CGAffineTransformRotate(self.imgView.transform,-M_PI/2);
        
        if(self.imgView.frame.size.width < _cropperView.frame.size.width || self.imgView.frame.size.height < _cropperView.frame.size.height)
        {
            double scale = MAX(_cropperView.frame.size.width/self.imgView.frame.size.width,_cropperView.frame.size.height/self.imgView.frame.size.height) + 0.01;
            
            self.imgView.transform = CGAffineTransformScale(self.imgView.transform,scale, scale);
            
        }
    }];
}

- (void) actionRestore
{
    [UIView animateWithDuration:0.2 animations:^{
        self.imgView.transform = CGAffineTransformIdentity;
        self.imgView.center = _cropperView.center;
    }];
}

@end
