//
//  PNCircleChart.h
//  PNChartDemo
//
//  Created by kevinzhow on 13-11-30.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNColor.h"
#import "UICountingLabel.h"

typedef NS_ENUM (NSUInteger, PNChartFormatType) {
    PNChartFormatTypePercent,
    PNChartFormatTypeDollar,
    PNChartFormatTypeNone,
    PNChartFormatTypeDecimal,
    PNChartFormatTypeDecimalTwoPlaces,
};

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface PNCircleChart : UIView

- (void)strokeChart;
- (void)growChartByAmount:(NSNumber *)growAmount;
- (void)updateChartByCurrent:(NSNumber *)current;
- (void)updateChartByCurrent:(NSNumber *)current byTotal:(NSNumber *)total;
- (id)initWithFrame:(CGRect)frame
              total:(NSNumber *)total
            current:(NSNumber *)current
          clockwise:(BOOL)clockwise;

- (id)initWithFrame:(CGRect)frame
              total:(NSNumber *)total
            current:(NSNumber *)current
          clockwise:(BOOL)clockwise
             shadow:(BOOL)hasBackgroundShadow
        shadowColor:(UIColor *)backgroundShadowColor;

- (id)initWithFrame:(CGRect)frame
              total:(NSNumber *)total
            current:(NSNumber *)current
          clockwise:(BOOL)clockwise
             shadow:(BOOL)hasBackgroundShadow
        shadowColor:(UIColor *)backgroundShadowColor
displayCountingLabel:(BOOL)displayCountingLabel;

- (id)initWithFrame:(CGRect)frame
              total:(NSNumber *)total
            current:(NSNumber *)current
          clockwise:(BOOL)clockwise
             shadow:(BOOL)hasBackgroundShadow
        shadowColor:(UIColor *)backgroundShadowColor
displayCountingLabel:(BOOL)displayCountingLabel
  overrideLineWidth:(NSNumber *)overrideLineWidth;

@property (strong, nonatomic) UICountingLabel *countingLabel;
@property (nonatomic) UIColor *strokeColor __deprecated_msg("deprecated. Use `strokeLeftColors and strokeRightColors`");
@property (nonatomic) UIColor *strokeColorGradientStart __deprecated_msg("deprecated. Use `strokeLeftColors and strokeRightColors`");
/*!
 *  @author 孟希羲, 15-12-18 16:12:00
 *
 *  @brief  左半部分的渐变色与有半部分的渐变色
 *
 *  @since 2.0
 */
/******************/
@property (nonatomic) NSArray *strokeLeftColors;
@property (nonatomic) NSArray *strokeRightColors;
/******************/
@property (nonatomic) NSNumber *total;
@property (nonatomic) NSNumber *current;
@property (nonatomic) NSNumber *lineWidth;
@property (nonatomic) NSTimeInterval duration;
@property (nonatomic) PNChartFormatType chartType;


@property (nonatomic) CAShapeLayer *circle;
@property (nonatomic) CAShapeLayer *gradientMask;
@property (nonatomic) CAShapeLayer *circleBackground;

@property (nonatomic) BOOL displayCountingLabel;

@end
