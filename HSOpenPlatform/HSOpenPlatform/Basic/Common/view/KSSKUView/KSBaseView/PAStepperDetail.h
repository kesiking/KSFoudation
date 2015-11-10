//
//  PAStepper.h
//  Leroy Merlin
//
//  Created by Miroslav Perovic on 11/30/12.
//  Copyright (c) 2012 Pure Agency. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAStepperDetail : UIControl

@property (assign, nonatomic) double value;
@property (assign, nonatomic) double minimumValue;
@property (assign, nonatomic) double maximumValue;
@property (assign, nonatomic) double stepValue;
@property (assign, nonatomic) BOOL wraps;
@property (assign, nonatomic) BOOL continuous;
@property (assign, nonatomic) BOOL autorepeat;
@property (assign, nonatomic) double autorepeatInterval;

@property (strong, nonatomic) UIColor *tintColor;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UITextField *textField;
@property (assign, nonatomic) BOOL editable;


typedef void (^ popStart)();
typedef void (^ popEnd)();
typedef void (^ valueChange)(double value);
typedef BOOL (^ shouldChangeValue)(double value);
@property (strong, nonatomic) popStart onPop;
@property (strong, nonatomic) popEnd onEnd;
@property (strong, nonatomic) valueChange onValueChange;
@property (strong, nonatomic) shouldChangeValue onShouldChangeValue;
- (UIImage *)backgroundImageForState:(UIControlState)state;
- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state;

- (UIImage *)decrementImageForState:(UIControlState)state;
- (void)setdDecrementImage:(UIImage *)image forState:(UIControlState)state;

- (UIImage *)incrementImageForState:(UIControlState)state;
- (void)setdIncrementImage:(UIImage *)image forState:(UIControlState)state;

- (void)setValueWithoutEvents:(double)val;
-(void)changeElementHeight;
@end
