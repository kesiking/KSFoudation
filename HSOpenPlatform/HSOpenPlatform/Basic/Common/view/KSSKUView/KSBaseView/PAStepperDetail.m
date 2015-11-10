//
//  PAStepper.m
//  Leroy Merlin
//
//  Created by Miroslav Perovic on 11/30/12.
//  Copyright (c) 2012 Pure Agency. All rights reserved.
//

#import "PAStepperDetail.h"
#import "TBDetailUIStyle.h"
#import "TBDetailUITools.h"

#define PASTEPPER_BUTTON_WIDTH 36

#define PASTEPPER_CONTROL_HEIGHT 36
#define PASTEPPER_CONTROL_WIDTH 112
#define PASTEPPER_CONTROL_CART_WIDTH 118
#define PASTEPPER_CONTROL_CART_HEIGHT 32
#define PASTEPPER_BUTTON_CART_WIDTH 35
@interface PAStepperDetail ()<UITextFieldDelegate> {
	UIImageView *backgroundImageView;
	UIImage *normalStateImage;
	UIImage *selectedStateImage;
	UIImage *highlightedStateImage;
	UIImage *disabledStateImage;
	
	NSNumber *changingValue;
	
	
	UIAlertView *thealertView;
}

@property (nonatomic, strong) UIButton *incrementButton;
@property (nonatomic, strong) UIButton *decrementButton;

@end

@implementation PAStepperDetail
- (void)awakeFromNib
{
	[self setInitialValues];
}

- (id)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, PASTEPPER_CONTROL_WIDTH, PASTEPPER_CONTROL_HEIGHT)]) {
		[self setInitialValues];
	}
	
	return self;
}

- (void)setInitialValues
{
    _tintColor          = [UIColor whiteColor];
    _textColor          = [TBDetailUIStyle colorWithHexString:@"#3d4245"];
    _value              = 1;
    _continuous         = YES;
    _minimumValue       = 1;
    _maximumValue       = 100;
    _stepValue          = 1;
    _wraps              = NO;
    _autorepeat         = YES;
    _autorepeatInterval = 0.5;
    _editable           = YES;
	
    //    UIColor *borderColor = [UIColor colorWithRed:0xe0/255.0 green:0xe1/255.0 blue:0xe1/255.0 alpha:1.0];
    
	// init left button
    self.backgroundColor=[UIColor clearColor];
	
	// background image
	backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(PASTEPPER_BUTTON_WIDTH, 0.0, PASTEPPER_CONTROL_WIDTH-PASTEPPER_BUTTON_WIDTH*2, PASTEPPER_CONTROL_HEIGHT)];
	normalStateImage = [UIImage imageNamed:@"tb_control_flow_number_center"];//[UIImage imageWithContentsOfFile:TBPath(@"cart_cell_num.png")];// [UIImage imageNamed:@"inputNumber"];
	//normalStateImage = [UIImage imageWithContentsOfFile:TBPath(@"cart_cell_num.png")];// [UIImage imageNamed:@"inputNumber"];
    backgroundImageView.userInteractionEnabled=YES;
	[backgroundImageView setImage:normalStateImage];
	[self addSubview:backgroundImageView];
    [self sendSubviewToBack:backgroundImageView];
    
	// label
    
	[self addSubview:self.decrementButton];
	[backgroundImageView addSubview:self.textField];
	//[self addSubview:_textField];
    
	/* init right button */
    [self addSubview:self.incrementButton];
}

-(void)done{
    [_textField resignFirstResponder];
    
    if (self.onEnd) {
        self.onEnd();
    }
    if (self.onValueChange) {
        self.onValueChange(_value);
    }
}

- (void)setFrame:(CGRect)frame
{
	// don't allow to change frame
	[super setFrame:CGRectMake(frame.origin.x, frame.origin.y, PASTEPPER_CONTROL_WIDTH, PASTEPPER_CONTROL_HEIGHT)];
}

- (void)setLabelText
{
	NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
	[formatter setFormatterBehavior:NSNumberFormatterBehaviorDefault];
	[formatter setNumberStyle:NSNumberFormatterBehaviorDefault];
	[_textField setText:[formatter stringFromNumber:[NSNumber numberWithDouble:_value]]];
}

- (void)setStrongStyle:(UIButton *)finishButton{
    UIColor *color =[TBDetailUIStyle colorWithHexString:@"#ff5000"];
    finishButton.layer.borderColor = color.CGColor;
    [finishButton setTitleColor:color forState:UIControlStateNormal];
    [finishButton setTitleColor:color forState:UIControlStateHighlighted];
    
    UIColor *cl = [TBDetailUIStyle colorWithStyle:TBDetailColorStyle_Price0 alpha:0.3];
    [finishButton setBackgroundImage:[TBDetailUIStyle imageWithImage:[TBDetailUIStyle createImageWithColor:cl] scaledToSize:self.frame.size] forState:UIControlStateHighlighted];
    
}

#pragma UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.onPop) {
        self.onPop();
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([self shouldChangeValue:[NSNumber numberWithDouble:_value]])
    {
        return YES;
    }
    return NO;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)atextField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)atextField{
    
    NSUInteger value = [atextField.text integerValue];
    atextField.text = [NSString stringWithFormat:@"%@", @(value)];
    if (value < _minimumValue || value > _maximumValue) {
        [WeAppToast toast:@"数量超出范围~"];
        [self setLabelText];
    } else{
        [self setValidValue:value];
    }
    
    if ([atextField.text integerValue] > 1) {
        _decrementButton.enabled = YES;
    }
    
    if (self.onEnd) {
        self.onEnd();
    }
}


#pragma mark - Set Values
- (void)setMinimumValue:(double)minValue
{
	if (minValue > _maximumValue) {
        _minimumValue = _maximumValue;
        NSLog(@"这里设置了一个错误的值%f",minValue);
        return;
        //		NSException *ex = [NSException exceptionWithName:NSInvalidArgumentException
        //												  reason:@"Invalid minimumValue"
        //												userInfo:nil];
        //		@throw ex;
	}
    _minimumValue = minValue;
}

- (void)setStepValue:(double)stepValue
{
//	if (stepValue <= 0) {
//		NSException *ex = [NSException exceptionWithName:NSInvalidArgumentException
//												  reason:@"Invalid stepValue"
//												userInfo:nil];
//		@throw ex;
//	}
    if (stepValue < 1) {
        stepValue = 1;
    }
    _stepValue = stepValue;
}

- (void)setMaximumValue:(double)maxValue
{
	if (maxValue < _minimumValue) {
        _maximumValue = _minimumValue;
        NSLog(@"这里设置了一个错误的值%f",maxValue);
        return;
        //		NSException *ex = [NSException exceptionWithName:NSInvalidArgumentException
        //												  reason:@"Invalid maximumValue"
        //												userInfo:nil];
        //		@throw ex;
	}
    _maximumValue = maxValue;
}

- (void)setValue:(double)val
{
    [self setValidValue:val];
	
	if (_value != val) {
		[self sendActionsForControlEvents:UIControlEventValueChanged];
	}
}


- (void)setValueWithoutEvents:(double)val
{
    [self setValidValue:val];
}

- (void)setAutorepeatValue:(double)autorepeatInterval
{
	if (autorepeatInterval > 0.0) {
		_autorepeatInterval = autorepeatInterval;
	} else if (autorepeatInterval == 0) {
		_autorepeatInterval = autorepeatInterval;
		_autorepeat = NO;
	}
}

- (void)setValidValue:(double)val
{
    if (val < _minimumValue) {
        val = _minimumValue;
    } else if(val > _maximumValue) {
        val = (_maximumValue / _stepValue) * _stepValue;
    }
    
    /*校验倍数*/
    int tmpValue     = val;
    int tmpStepValue = _stepValue;
    if ((tmpValue % tmpStepValue) > 0) {
        tmpValue = (tmpValue / tmpStepValue) * tmpStepValue;
        if (tmpValue + tmpValue < _maximumValue) {
            tmpValue += tmpStepValue;
        }
    }
    
    _value = tmpValue;
    
    if (_value - _stepValue <= 0) {
        self.decrementButton.enabled = NO;
    }else{
        self.decrementButton.enabled = YES;
    }
    
    [self setLabelText];
}

# pragma mark - Public Methods

- (UIImage *)backgroundImageForState:(UIControlState)state
{
	switch (state) {
		case UIControlStateNormal:
			return normalStateImage;
			break;
			
		case UIControlStateHighlighted:
			if (highlightedStateImage) {
				return highlightedStateImage;
			} else {
				return normalStateImage;
			}
			break;
			
		case UIControlStateDisabled:
			if (disabledStateImage) {
				return disabledStateImage;
			} else {
				return normalStateImage;
			}
			break;
			
		case UIControlStateSelected:
			if (selectedStateImage) {
				return selectedStateImage;
			} else {
				return normalStateImage;
			}
			break;
			
		default:
			return normalStateImage;
			break;
	}
	
	return normalStateImage;
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;
{
	switch (state) {
		case UIControlStateNormal:
			normalStateImage = image;
			break;
			
		case UIControlStateHighlighted:
			highlightedStateImage = image;
			break;
			
		case UIControlStateDisabled:
			disabledStateImage = image;
			break;
			
		case UIControlStateSelected:
			selectedStateImage = image;
			break;
			
		default:
			break;
	}
}

- (UIImage *)decrementImageForState:(UIControlState)state
{
	return [self.decrementButton imageForState:state];
}

- (void)setdDecrementImage:(UIImage *)image forState:(UIControlState)state
{
	[self.decrementButton setImage:image forState:state];
}

- (UIImage *)incrementImageForState:(UIControlState)state
{
	return [self.incrementButton imageForState:state];
}

- (void)setdIncrementImage:(UIImage *)image forState:(UIControlState)state
{
	[self.incrementButton setImage:image forState:state];
}

#pragma mark - Private Accessor
- (UIButton *)incrementButton
{
    if (!_incrementButton) {
        _incrementButton = [[UIButton alloc] initWithFrame:CGRectMake(PASTEPPER_CONTROL_WIDTH-PASTEPPER_BUTTON_WIDTH, 0.0, PASTEPPER_BUTTON_WIDTH, PASTEPPER_CONTROL_HEIGHT)];
        [_incrementButton setBackgroundImage:[UIImage imageNamed:@"tb_control_flow_number_right"] forState:UIControlStateNormal];
        [_incrementButton setBackgroundImage:[UIImage imageNamed:@"tb_control_flow_number_right_press"] forState:UIControlStateHighlighted];
        [_incrementButton setImage:[UIImage imageNamed:@"skuview_increase.png"] forState:UIControlStateNormal];
        [_incrementButton setImage:[UIImage imageNamed:@"skuview_increase2.png"] forState:UIControlStateHighlighted];
        //    [incrementButton addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
        [_incrementButton addTarget:self action:@selector(didBeginLongTap:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
        [_incrementButton addTarget:self action:@selector(didEndLongTap) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel | UIControlEventTouchDragExit];
        //    incrementButton.layer.borderWidth = 0.5;
        //    incrementButton.layer.borderColor = borderColor.CGColor;
        _incrementButton.accessibilityLabel = @"增加购买数量";
    }
    return _incrementButton;
}

- (UIButton *)decrementButton
{
    if (!_decrementButton) {
        _decrementButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, PASTEPPER_BUTTON_WIDTH, PASTEPPER_CONTROL_HEIGHT)];
        [_decrementButton setBackgroundImage:[UIImage imageNamed:@"tb_control_flow_number_left"]
                                    forState:UIControlStateNormal];
        [_decrementButton setBackgroundImage:[UIImage imageNamed:@"tb_control_flow_number_left_press"]
                                    forState:UIControlStateHighlighted];
        [_decrementButton setImage:[UIImage imageNamed:@"skuview_decrease.png"]
                          forState:UIControlStateNormal];
        [_decrementButton setImage:[UIImage imageNamed:@"skuview_decrease2.png"]
                          forState:UIControlStateHighlighted];
        [_decrementButton setAutoresizingMask:UIViewAutoresizingNone];
        //    [decrementButton addTarget:self action:@selector(didPressButton:) forControlEvents:UIControlEventTouchUpInside];
        [_decrementButton addTarget:self action:@selector(didBeginLongTap:)
                   forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
        [_decrementButton addTarget:self action:@selector(didEndLongTap)
                   forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel | UIControlEventTouchDragExit];
        if (1 == _stepValue) {
            _decrementButton.enabled = NO;
        }
        _decrementButton.accessibilityLabel = @"减少购买数量";
    }
    return _decrementButton;
}

- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(backgroundImageView.bounds.origin.x,
                                                                   backgroundImageView.bounds.origin.y,
                                                                   backgroundImageView.bounds.size.width,
                                                                   backgroundImageView.bounds.size.height)];
        _textField.delegate     = self;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        [_textField setTextAlignment:NSTextAlignmentCenter];
        [_textField setFont:[UIFont boldSystemFontOfSize:15.0]];
        [_textField setTextColor:_textColor];
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _textField.backgroundColor          = [UIColor clearColor];
        [_textField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
        [_textField setTextAlignment:NSTextAlignmentCenter];
        _textField.accessibilityLabel = @"当前购买数量";
        [self setLabelText];
        
        /*设置辅助试图*/
        UIView *numberToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 50)];
        numberToolBar.backgroundColor = [UIColor colorWithRed:0xf9/255.0f green:0xf9/255.0f blue:0xf9/255.0f alpha:1.0];
        [numberToolBar sizeToFit];
        
        UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        float x = [[UIScreen mainScreen] bounds].size.width - 60 - [TBDetailUITools getDetailBorderGap];
        finishButton.frame           = CGRectMake(x, 8 , 60, 34);
        finishButton.backgroundColor = [UIColor clearColor];
        [finishButton setTitle:@"完成"
                      forState:UIControlStateNormal];
        [self setStrongStyle:finishButton];

        [finishButton addTarget:self
                         action:@selector(done)
               forControlEvents:UIControlEventTouchUpInside];
        [numberToolBar addSubview:finishButton];
        
        _textField.inputAccessoryView = numberToolBar;
    }
    return _textField;
}

#pragma mark - Actions

- (void)didPressButton:(id)sender
{
//    [[ALAAdapterManager currentUserTrackService] ctrlClicked:@"Button-ChangeNum"];
    
	[self setHighlighted:YES];
	if (changingValue) {
		return;
	}
	
	UIButton *button = (UIButton *)sender;
	double changeValue;
	if (button == _decrementButton) {
		changeValue = -1 * _stepValue;
	} else {
		changeValue = _stepValue;
	}
    if([self shouldChangeValue:[NSNumber numberWithDouble:changeValue]])
    {
        changingValue = [NSNumber numberWithDouble:changeValue];
        [self performSelector:@selector(changeValue:) withObject:changingValue afterDelay:0.5];
    }
}

- (void)didBeginLongTap:(id)sender
{
	[self setHighlighted:YES];
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	UIButton *button = (UIButton *)sender;
	double changeValue;
	if (button == _decrementButton) {
		changeValue = -1 * _stepValue;
	} else {
		changeValue = _stepValue;
	}
    if([self shouldChangeValue:[NSNumber numberWithDouble:changeValue]])
    {
        changingValue = [NSNumber numberWithDouble:changeValue];
        if (_continuous) {
            [self changeValue:changingValue];
        }
        [self performSelector:@selector(longTapLoop) withObject:nil afterDelay:_autorepeatInterval];
    }
}

- (void)didEndLongTap
{
	[self setHighlighted:NO];
    
    if([self shouldChangeValue:changingValue])
    {
        if (!_continuous) {
            [self performSelectorOnMainThread:@selector(changeValue:) withObject:changingValue waitUntilDone:YES];
        }
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    changingValue = nil;
}

- (void)longTapLoop
{
	if (_autorepeat) {
		[self performSelector:@selector(longTapLoop) withObject:nil afterDelay:_autorepeatInterval];
		[self performSelectorOnMainThread:@selector(changeValueWithoutValue:) withObject:changingValue waitUntilDone:YES];
	}
}


#pragma mark - Overwrite UIControl methods

- (void)setEnabled:(BOOL)enabled
{
	if (enabled) {
		backgroundImageView.image = normalStateImage;
	} else {
		if (disabledStateImage) {
			backgroundImageView.image = disabledStateImage;
		}
	}
}

- (void)setHighlighted:(BOOL)highlighted
{
	if (highlighted && highlightedStateImage) {
		backgroundImageView.image = highlightedStateImage;
	} else {
		backgroundImageView.image = normalStateImage;
	}
}

- (void)setSelected:(BOOL)selected
{
	if (selected && selectedStateImage) {
		backgroundImageView.image = selectedStateImage;
	} else {
		backgroundImageView.image = normalStateImage;
	}
}


#pragma mark - Other methods

- (void)textFieldDidChange:(UITextField *)textField {
    NSUInteger  textValue = [textField.text integerValue];
    textField.text = [NSString stringWithFormat:@"%@", @(textValue)];
    
    if (textValue > 1) {
        _decrementButton.enabled = YES;
    }
}

- (BOOL)shouldChangeValue:(NSNumber *)change
{
    if(self.onShouldChangeValue)
    {
        return self.onShouldChangeValue([change integerValue]);
    }
    return YES;
}

- (void)changeValue:(NSNumber *)change
{
	double toChange = [change integerValue];
	double newValue = _value + toChange;
	if (toChange < 0) {
		if (newValue < _minimumValue) {
			if (!_wraps) {
                
//				[self showAlertView];
				
				return;
			} else {
				newValue = _maximumValue;
			}
		}
	} else {
		if (newValue > _maximumValue) {
			if (!_wraps) {
				[self showAlertView];
                return;
			} else {
				newValue = _minimumValue;
			}
		}
	}
    
    if (_minimumValue == newValue) {
        _decrementButton.enabled = NO;
    }else{
        _decrementButton.enabled = YES;
    }
	[self setValue:newValue];
    if (self.onValueChange) {
        self.onValueChange(newValue);
    }
}

- (void)changeValueWithoutValue:(NSNumber *)change
{
	double toChange = [change integerValue];
	double newValue = _value + toChange;
	if (toChange < 0) {
		if (newValue < _minimumValue) {
			if (!_wraps) {
				
				[self showAlertView];
				[self setValue:_minimumValue];
				
				return;
			} else {
				newValue = _maximumValue;
			}
		}
	} else {
		if (newValue > _maximumValue) {
			if (!_wraps) {
				[self showAlertView];
				[self setValue:_maximumValue];
			} else {
				newValue = _minimumValue;
			}
		}
	}
	[self setValueWithoutEvents:newValue];
}

-(void)showAlertView{
    [WeAppToast toast:@"数量超出范围~"];
}


-(void)changeElementHeight{
    
    _decrementButton.frame= CGRectMake(0.0, 0.0, PASTEPPER_BUTTON_CART_WIDTH, PASTEPPER_CONTROL_CART_HEIGHT);
    
    backgroundImageView.frame = CGRectMake(PASTEPPER_BUTTON_CART_WIDTH, 0.0, PASTEPPER_CONTROL_CART_WIDTH-PASTEPPER_BUTTON_CART_WIDTH*2, PASTEPPER_CONTROL_CART_HEIGHT);
    _incrementButton.frame = CGRectMake(PASTEPPER_CONTROL_CART_WIDTH-PASTEPPER_BUTTON_CART_WIDTH, 0.0, PASTEPPER_BUTTON_CART_WIDTH, PASTEPPER_CONTROL_CART_HEIGHT);
    _textField.frame=backgroundImageView.bounds;
    [super  setFrame:CGRectMake(self.left, self.top, PASTEPPER_CONTROL_CART_WIDTH, PASTEPPER_CONTROL_CART_HEIGHT)];
    
    [_incrementButton setImage:[UIImage imageNamed:@"tb_cart_flow_number_right"] forState:UIControlStateNormal];
    [_incrementButton setImage:[UIImage imageNamed:@"tb_cart_flow_number_right_press"] forState:UIControlStateHighlighted];
    [_incrementButton setBackgroundImage:nil forState:UIControlStateNormal];
    [_incrementButton setBackgroundImage:nil forState:UIControlStateHighlighted];
    [_decrementButton setImage:[UIImage imageNamed:@"tb_cart_flow_number_left"] forState:UIControlStateNormal];
    [_decrementButton setImage:[UIImage imageNamed:@"tb_cart_flow_number_left_press"] forState:UIControlStateHighlighted];
    [_decrementButton setBackgroundImage:nil forState:UIControlStateNormal];
    [_decrementButton setBackgroundImage:nil forState:UIControlStateHighlighted];
	[backgroundImageView setImage:[UIImage imageNamed:@"tb_cart_control_flow_number_center"]];
    
    [self setNeedsLayout];
}

@end
