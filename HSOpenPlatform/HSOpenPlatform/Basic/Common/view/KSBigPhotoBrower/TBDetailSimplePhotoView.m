//
//  TBDetailSimplePhotoView.m
//  TBTradeDetail
//
//  Created by sweety on 14/11/27.
//  Copyright (c) 2014年 alibaba. All rights reserved.
//

#import "TBDetailSimplePhotoView.h"
#include <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>
#import "SDWebImageOperation.h"
#import "SDWebImageManager.h"

@interface TBDetailPhotoScrollView : UIScrollView {
}
@end

@implementation TBDetailPhotoScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesMoved:touches withEvent:event];
}

@end



@implementation TBDetailSimplePhotoView{
    NSMutableArray *_downloadOperations;
}

- (void)setTouchDelegate:(id)touchDelegate
{
    _originalClass = object_getClass(touchDelegate);
    _touchDelegate = touchDelegate;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        
        _minScale  = 0.5;
        _maxScale  = 1.0;
//        _lastScale = 0;
    
        
        _scrollView = [[TBDetailPhotoScrollView alloc] initWithFrame:self.bounds];
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_scrollView];
        
        _imageView  = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_scrollView addSubview:_imageView];
        
        _scaleEnabled = YES;
        
        _downloadOperations=[NSMutableArray array];
        
    }
    return self;
}

-(void)dealloc{
    for(id <SDWebImageOperation> operation in _downloadOperations){
        [operation cancel];
    }
    _scrollView.delegate = nil;
    _touchDelegate       = nil;
}


#pragma mark -
#pragma mark Image and View

- (void)setImageURL:(NSString *)url {
    if ([_imageURL isEqualToString:url]) {
        NSLog(@"用缓存");
        return;
    }
    
    _imageURL = url;
    
    __weak __typeof(&*self)weakSelf = self;
    id <SDWebImageOperation> operation = [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageDelayPlaceholder progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        ;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (!error&&image) {
            weakSelf.imageView.image=image;
            [weakSelf resetScaleOfImage:image];
            [weakSelf replaceImg:image];
            NSLog(@"%f,%f",image.size.height,image.size.width);
        }else{
            NSLog(@"没有网络，什么都不做");
        }
    }];
    if (operation) {
        [_downloadOperations addObject:operation];
    }
}

-(void)replaceImg:(UIImage*)img{
    Class currentClass = object_getClass(_touchDelegate);
    //    printf("\n_originalClass = %s\ncurrentClass = %s\n", NSStringFromClass(_originalClass).UTF8String, NSStringFromClass(currentClass).UTF8String);
    if (currentClass
        && _originalClass
        && currentClass == _originalClass
        && self.touchDelegate
        && [self.touchDelegate respondsToSelector:@selector(replaceImages:)]) {
        NSLog(@"替换图片");
        [self.touchDelegate performSelector:@selector(replaceImages:) withObject:img];
    }
}

-(void)resetScaleOfImage:(UIImage*)img{
    
    
    CGSize size = self.bounds.size;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.bouncesZoom = NO;
    self.scrollView.zoomScale = 1.0;
    float width = img.size.width;
    float height = img.size.height;
    
    CGSize contSize = CGSizeMake(MAX(width, size.width), MAX(height, size.height));
    
    float radio = size.width/size.height;
    if (contSize.width/contSize.height > radio) {
        contSize.height = floor(contSize.width / radio);
    } else {
        contSize.width = floor(contSize.height * radio);
    }
    
    self.scrollView.contentSize = contSize;
    
    self.minScale = MIN(size.width / contSize.width, 1.0);
    NSLog(@"%f",self.minScale);
    self.maxScale = 1.0;
    self.scrollView.minimumZoomScale = self.minScale;
    self.scrollView.maximumZoomScale = self.maxScale;
    
    CGRect imgFrame = CGRectMake(0, 0, contSize.width, contSize.height);
    self.imageView.frame = imgFrame;
    //        _imageView.center=self.center;
    
    self.fitScale = MIN(self.minScale, 1.0);
    
    self.scrollView.zoomScale = self.minScale;
}

-(void)setImage:(UIImage *)image{
    if (image.size.width >= _imageView.image.size.width) {
        NSLog(@"用小图");
        _imageView.image=image;
        [self resetScaleOfImage:image];
    }
}

#pragma mark -
#pragma mark Layout

- (void)layoutSubviews {
    [super layoutSubviews];
}


#pragma mark -
#pragma mark === UIScrollView Delegate ===

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)aScrollView withView:(UIView *)view atScale:(CGFloat)scale {
    CGFloat zs = scale;
    zs = MAX(zs, _minScale);
    zs = MIN(zs, _maxScale);
    NSLog(@"%f",zs);
    [_scrollView setZoomScale:zs animated:YES];
}

- (void)setSelected:(BOOL)value animated:(BOOL)animated {
    if (value) {
        
        
    } else {
        if (animated) {
            [UIView beginAnimations:nil context:NULL];
            
            [UIView commitAnimations];
            
            
        } else {
            
        }
    }
}

#pragma mark -
#pragma mark === UITouch Delegate ===

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    NSLog(@"%d",[touch tapCount] );
    
    if (_scaleEnabled && [touch tapCount] == 2) {
        [self handleDoubleTap];
    }
    
    
    if ([touch tapCount] == 1) {
        
        [self performSelector:@selector(handleSingleTap) withObject:nil
                   afterDelay:0.2];
        
    }
    
    
    [[self nextResponder] touchesEnded:touches withEvent:event];
}

-(void)handleSingleTap{
    NSLog(@"single");
    CGFloat zs = _scrollView.zoomScale;
    NSLog(@"%f,%f",_scrollView.zoomScale,_minScale);
    if (zs!=_minScale) {
        [_scrollView setZoomScale:_minScale animated:YES];
        NSLog(@"先变小%f,%f",_scrollView.zoomScale,_minScale);
    }else{
        if (self.touchDelegate && [self.touchDelegate respondsToSelector:@selector(touchOnPhotoView:)]) {
            [self.touchDelegate performSelector:@selector(touchOnPhotoView:) withObject:self];
        }
    }
    
    
}

-(void)handleDoubleTap{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(handleSingleTap) object:nil];
    
    CGFloat zs = _scrollView.zoomScale;
    zs = (zs == _minScale) ? _maxScale : _minScale;
    [_scrollView setZoomScale:zs animated:YES];
    
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self nextResponder] touchesMoved:touches withEvent:event];
}

- (void)getOriginalPic:(NSString *)urlStr andImage:(UIImage *)image{
    _imageURL = urlStr;
    _image = image;
    [self handleDoubleTap];
}

@end
