//
//	 ______    ______    ______
//	/\  __ \  /\  ___\  /\  ___\
//	\ \  __<  \ \  __\_ \ \  __\_
//	 \ \_____\ \ \_____\ \ \_____\
//	  \/_____/  \/_____/  \/_____/
//
//
//	Copyright (c) 2014-2015, Geek Zoo Studio
//	http://www.bee-framework.com
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a
//	copy of this software and associated documentation files (the "Software"),
//	to deal in the Software without restriction, including without limitation
//	the rights to use, copy, modify, merge, publish, distribute, sublicense,
//	and/or sell copies of the Software, and to permit persons to whom the
//	Software is furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//	FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//	IN THE SOFTWARE.
//

#import "ServiceInspector_Window.h"
#import "KSDebugServiceInspector_Layer.h"
#import "UIView+Screenshot.h"

#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)

#pragma mark -

#undef	D2R
#define D2R( __degree ) (M_PI / 180.0f * __degree)

#undef	MAX_DEPTH
#define MAX_DEPTH	(36)

#pragma mark -

@interface ServiceInspector_Window()
{
	float				_rotateX;
    float				_rotateY;
    float				_distance;
	BOOL				_animating;
    
    CGPoint				_oringePoint;
	
	CGPoint				_panOffset;
    BOOL                _isSwidding;
	CGFloat				_pinchOffset;
    CGPoint				_swipeOffset;
	
	UIButton *          _showLabel;
	BOOL				_labelShown;
}

@property (nonatomic, assign) BOOL				pinchable;		// same as pinchEnabled
@property (nonatomic, assign) BOOL				pinchEnabled;
@property (nonatomic, assign) CGFloat			pinchScale;
@property (nonatomic, assign) CGFloat			pinchVelocity;
@property (nonatomic, strong) UIPinchGestureRecognizer* pinchGesture;

@property (nonatomic, assign) BOOL			    pannable;	// same as panEnabled
@property (nonatomic, assign) BOOL				panEnabled;
@property (nonatomic, assign) CGPoint			panOffset;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, strong) UIView            *threeDView;

- (void)hide;
- (void)show;

- (void)buildLayers;
- (void)removeLayers;
- (void)transformLayers:(BOOL)flag;

@end

#pragma mark -

@implementation ServiceInspector_Window

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self load];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self load];
    }
    return self;
}

- (void)load
{
	self.backgroundColor = [UIColor blackColor];
	self.hidden = YES;

	
	_labelShown = NO;
	
	CGRect buttonFrame;
	buttonFrame.size.width = 100.0f;
	buttonFrame.size.height = 40.0f;
	buttonFrame.origin.x = 10.0f;
	buttonFrame.origin.y = self.frame.size.height - buttonFrame.size.height - 10.0f;
    
    _threeDView = [[UIView alloc] initWithFrame:self.bounds];
    _threeDView.backgroundColor = [UIColor clearColor];
    _threeDView.userInteractionEnabled = YES;
    [self addSubview:_threeDView];
	
	_showLabel = [[UIButton alloc] initWithFrame:buttonFrame];
	_showLabel.hidden = NO;
	_showLabel.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _showLabel.backgroundColor = [UIColor whiteColor];
    [_showLabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	_showLabel.layer.cornerRadius = 10.0f;
    _showLabel.layer.masksToBounds = YES;
    [_showLabel setTitle:@"Label (OFF)" forState:UIControlStateNormal];
    [_showLabel addTarget:self action:@selector(labelShowClicked:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:_showLabel];
    
    self.panEnabled = YES;
    self.pinchable = YES;
    
    _oringePoint = CGPointMake(0, 0);
}

#pragma -mark pinchGesture

- (UIPinchGestureRecognizer *)pinchGesture
{
    UIPinchGestureRecognizer * pinchGesture = nil;
    
    for ( UIGestureRecognizer * gesture in self.gestureRecognizers )
    {
        if ( [gesture isKindOfClass:[UIPinchGestureRecognizer class]] )
        {
            pinchGesture = (UIPinchGestureRecognizer *)gesture;
        }
    }
    
    if ( nil == pinchGesture )
    {
        pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didPinch:)];
        [self addGestureRecognizer:pinchGesture];
    }
    
    return pinchGesture;
}

- (void)didPinch:(UIPinchGestureRecognizer *)pinchGesture
{
    if ( UIGestureRecognizerStateBegan == pinchGesture.state )
    {
//        [self sendUISignal:UIView.PINCH_START];
        [self onPinchStart];
    }
    else if ( UIGestureRecognizerStateChanged == pinchGesture.state )
    {
//        [self sendUISignal:UIView.PINCH_CHANGED];
        [self onPinchChanged];
    }
    else if ( UIGestureRecognizerStateEnded == pinchGesture.state )
    {
//        [self sendUISignal:UIView.PINCH_STOP];
    }
    else if ( UIGestureRecognizerStateCancelled == pinchGesture.state )
    {
//        [self sendUISignal:UIView.PINCH_CANCELLED];
    }
}

- (BOOL)pinchable
{
    return self.pinchGesture.enabled;
}

- (void)setPinchable:(BOOL)flag
{
    self.pinchGesture.enabled = flag;
}

- (BOOL)pinchEnabled
{
    return self.pinchGesture.enabled;
}

- (void)setPinchEnabled:(BOOL)flag
{
    self.pinchGesture.enabled = flag;
}

- (CGFloat)pinchScale
{
    UIPinchGestureRecognizer * gesture = self.pinchGesture;
    if ( nil == gesture )
    {
        return 1.0f;
    }
    
    return gesture.scale;
}

#pragma -mark panGesture

- (BOOL)pannable
{
    return self.panGesture.enabled;
}

- (void)setPannable:(BOOL)flag
{
    self.panGesture.enabled = flag;
}

- (BOOL)panEnabled
{
    return self.panGesture.enabled;
}

- (void)setPanEnabled:(BOOL)flag
{
    self.panGesture.enabled = flag;
}

- (CGPoint)panOffset
{
    return [self.panGesture translationInView:self];
}

- (UIPanGestureRecognizer *)panGesture
{
    UIPanGestureRecognizer * panGesture = nil;
    
    for ( UIGestureRecognizer * gesture in self.gestureRecognizers )
    {
        if ( [gesture isKindOfClass:[UIPanGestureRecognizer class]] )
        {
            panGesture = (UIPanGestureRecognizer *)gesture;
        }
    }
    
    if ( nil == panGesture )
    {
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
        [panGesture setMaximumNumberOfTouches:3];
        [self addGestureRecognizer:panGesture];
    }
    
    return panGesture;
}

- (void)didPan:(UIPanGestureRecognizer *)panGesture
{
    if([panGesture numberOfTouches] == 2){
        if ( UIGestureRecognizerStateBegan == panGesture.state )
        {
            [self onSwipeStart];
        }
        else if ( UIGestureRecognizerStateChanged == panGesture.state )
        {
            [self onSwipeChanged];
        }
        else if ( UIGestureRecognizerStateEnded == panGesture.state )
        {
//            [self onSwipeChanged];
        }
        else if ( UIGestureRecognizerStateCancelled == panGesture.state )
        {
            //        [self sendUISignal:UIView.PAN_CANCELLED];
        }
        else if ( UIGestureRecognizerStateFailed == panGesture.state )
        {
        }
    }else if ([panGesture numberOfTouches] == 1) {
        if ( UIGestureRecognizerStateBegan == panGesture.state )
        {
            [self onPanStart];
        }
        else if ( UIGestureRecognizerStateChanged == panGesture.state )
        {
            [self onPanChanged];
        }
        else if ( UIGestureRecognizerStateEnded == panGesture.state )
        {
            //        [self sendUISignal:UIView.PAN_STOP];
        }
        else if ( UIGestureRecognizerStateCancelled == panGesture.state )
        {
            //        [self sendUISignal:UIView.PAN_CANCELLED];
        }
        else if ( UIGestureRecognizerStateFailed == panGesture.state )
        {
        }
    }
    
}

#pragma -mark load and unload
- (void)unload
{
    [_showLabel removeFromSuperview];
    _showLabel = nil;

	[self removeLayers];
}

- (void)buildSublayersFor:(UIView *)view depth:(CGFloat)depth origin:(CGPoint)origin
{
	if ( depth >= MAX_DEPTH )
		return;
	
	if ( view.hidden || view.alpha <= 0.0001)
		return;

	if ( 0 == view.frame.size.width || 0 == view.frame.size.height )
		return;
	
	CGRect screenBound = [UIScreen mainScreen].bounds;
	CGRect viewFrame;
	
	viewFrame.origin.x = origin.x + view.center.x - view.bounds.size.width / 2.0f;
	viewFrame.origin.y = origin.y + view.center.y - view.bounds.size.height / 2.0f;

	if ( [view isKindOfClass:[UIScrollView class]] || [view isKindOfClass:[UITableView class]] )
	{
        if (![view isKindOfClass:NSClassFromString(@"UITableViewWrapperView")]) {
            CGPoint viewOrigin = [self convertPoint:CGPointZero toView:view];
            viewFrame.origin.x -= viewOrigin.x;
            viewFrame.origin.y -= viewOrigin.y;
        }
	}
		
	viewFrame.size.width = view.bounds.size.width;
	viewFrame.size.height = view.bounds.size.height;
	
	CGFloat overflowWidth = screenBound.size.width * 10;
	CGFloat overflowHeight = screenBound.size.height * 10;
	
	if ( CGRectGetMaxX(viewFrame) < -overflowWidth || CGRectGetMinX(viewFrame) > (screenBound.size.width + overflowWidth) )
		return;
	if ( CGRectGetMaxY(viewFrame) < -overflowHeight || CGRectGetMinY(viewFrame) > (screenBound.size.height + overflowHeight) )
		return;

//	INFO( @"view = %@", [[view class] description] );
	
	KSDebugServiceInspector_Layer * layer = [[KSDebugServiceInspector_Layer alloc] init];
	if ( layer )
	{
		layer.layer.borderWidth = 1.5f;
//		layer.layer.borderColor = [UIColor colorWithRed:0x39/255.0 green:0xb5/255.0 blue:0x4a/255.0 alpha:0.8].CGColor;
//		layer.backgroundColor = [UIColor colorWithRed:0x63/255.0 green:0x63/255.0 blue:0x63/255.0 alpha:0.05f];
        
        int red = arc4random() % (200 - 128) + 128;
        int blue = arc4random() % (200 - 128) + 128;
        int green = arc4random() % (200 - 128) + 128;
        
        layer.layer.borderColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:0.8].CGColor;
        layer.backgroundColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:0.05f];

		CGPoint anchor;
		anchor.x = (screenBound.size.width / 2.0f - viewFrame.origin.x) / viewFrame.size.width;
		anchor.y = (screenBound.size.height / 2.0f - viewFrame.origin.y) / viewFrame.size.height;

		layer.view = view;
		
		if ( view.tagString )
		{
			layer.label.text = [NSString stringWithFormat:@"#%@", view.tagString];
			layer.label.textColor = [UIColor yellowColor];
		}
		else
		{
			layer.label.text =  [[view class] description];
			layer.label.textColor = [UIColor yellowColor];
		}
         
		
		layer.label.hidden = _labelShown ? NO : YES;
		layer.rect = viewFrame;
		layer.depth = depth;
		layer.frame = viewFrame;
		layer.image = view.screenshotOneLayer;
		layer.layer.anchorPoint = anchor;
		layer.layer.anchorPointZ = (layer.depth * -1.0f) * 75.0f;
		[self.threeDView addSubview:layer];
	}

	for ( UIView * subview in view.subviews )
	{
        if ([view isKindOfClass:[ServiceInspector_Window class]] || view == self) {
            continue;
        }
		[self buildSublayersFor:subview depth:(depth + 1 + [view.subviews indexOfObject:subview] * 0.025f) origin:layer.rect.origin];
	}
}

- (void)buildLayers
{
	[self buildSublayersFor:[UIApplication sharedApplication].keyWindow depth:0 origin:CGPointZero];
    _oringePoint = CGPointZero;
}

- (void)removeLayers
{
	NSArray * subviewsCopy = [NSArray arrayWithArray:self.threeDView.subviews];

	for ( UIView * subview in subviewsCopy )
	{
		if ( [subview isKindOfClass:[KSDebugServiceInspector_Layer class]] )
		{
			[subview removeFromSuperview];
		}
	}
}

- (void)transformLayers:(BOOL)setFrames
{
    CATransform3D transform2 = CATransform3DIdentity;
    transform2.m34 = -0.002;
	transform2 = CATransform3DTranslate( transform2, _rotateY * -2.5f, 0, 0 );
	transform2 = CATransform3DTranslate( transform2, 0, _rotateX * 3.5f, 0 );

    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DMakeTranslation( 0, 0, _distance * 1000 );
    transform = CATransform3DConcat( CATransform3DMakeRotation(D2R(_rotateX), 1, 0, 0), transform );
    transform = CATransform3DConcat( CATransform3DMakeRotation(D2R(_rotateY), 0, 1, 0), transform );
    transform = CATransform3DConcat( CATransform3DMakeRotation(D2R(0), 0, 0, 1), transform );
    transform = CATransform3DConcat( transform, transform2 );

	NSArray * subviewsCopy = [NSArray arrayWithArray:self.threeDView.subviews];

	for ( UIView * subview in subviewsCopy )
	{
		if ( [subview isKindOfClass:[KSDebugServiceInspector_Layer class]] )
		{
			KSDebugServiceInspector_Layer * layer = (KSDebugServiceInspector_Layer *)subview;
			layer.frame = layer.rect;
						
			if ( _animating )
			{
				layer.layer.transform = CATransform3DIdentity;
			}
			else
			{
				layer.layer.transform = transform;
			}
			
			[layer setNeedsDisplay];
		}
	}
}

- (void)prepareShow
{
	[self setHidden:NO];

	[self removeLayers];
	[self buildLayers];

	_rotateX = 0.0f;
	_rotateY = 0.0f;
	_distance = 0.0f;
	_animating = YES;
	
//	[self setAlpha:1.0f];
	[self transformLayers:YES];
}

- (void)prepareShowWithView:(UIView*)view
{
    if (view == nil || ![view isKindOfClass:[UIView class]]) {
        return;
    }
    [self setHidden:NO];
    
    [self removeLayers];
    [self buildSublayersFor:view depth:0 origin:CGPointZero];
    
    _oringePoint = CGPointZero;
    
    _rotateX = 0.0f;
    _rotateY = 0.0f;
    _distance = 0.0f;
    _animating = YES;
    
    //	[self setAlpha:1.0f];
    [self transformLayers:YES];
}

- (void)show
{
	_rotateX = 5.0f;
	_rotateY = 30.0f;
	_distance = -1.0f;
	_animating = NO;

//	[self setAlpha:1.0f];
	[self transformLayers:NO];
}

- (void)prepareHide
{
	_rotateX = 0.0f;
	_rotateY = 0.0f;
	_distance = 0.0f;
	_animating = YES;

//	[self setAlpha:0.0f];
	[self transformLayers:YES];
}

- (void)hide
{
	_animating = NO;

	[self removeLayers];
	
//	[self setAlpha:0.0f];
	[self setHidden:YES];
}

#pragma mark -

-(void)labelShowClicked:(id)sender
{
    _labelShown = _labelShown ? NO : YES;
    
    if ( _labelShown )
    {
        [_showLabel setTitle:@"Label (ON)" forState:UIControlStateNormal];
    }
    else
    {
        [_showLabel setTitle:@"Label (OFF)" forState:UIControlStateNormal];
    }
    
    for ( KSDebugServiceInspector_Layer * layer in self.threeDView.subviews )
    {
        if ( [layer isKindOfClass:[KSDebugServiceInspector_Layer class]] )
        {
            layer.label.hidden = _labelShown ? NO : YES;
        }
    }
}

-(void)onPanStart
{
    _isSwidding = NO;
    _panOffset.x = _rotateY;
    _panOffset.y = _rotateX * -1.0f;
}

-(void)onPanChanged
{
    if (!_isSwidding) {
        _rotateY = _panOffset.x + self.panOffset.x * 0.5f;
        _rotateX = _panOffset.y * -1.0f - self.panOffset.y * 0.5f;
        
        [self transformLayers:NO];
    }
}

-(void)onSwipeStart
{
    _isSwidding = YES;
    _swipeOffset.x = _oringePoint.x;
    _swipeOffset.y = _oringePoint.y;
}

-(void)onSwipeChanged
{
    _oringePoint.x = _swipeOffset.x + self.panOffset.x;
    _oringePoint.y = _swipeOffset.y + self.panOffset.y;
    
    [self.threeDView setFrame:CGRectMake(_oringePoint.x, _oringePoint.y, self.threeDView.frame.size.width, self.threeDView.frame.size.height)];
}

-(void)onPinchStart
{
    _pinchOffset = _distance;
}

-(void)onPinchChanged
{
    _distance = _pinchOffset + (self.pinchScale - 1);
    _distance = (_distance < -5 ? -5 : (_distance > 0.5 ? 0.5 : _distance));
    
    [self transformLayers:NO];
}

@end

#endif	// #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
