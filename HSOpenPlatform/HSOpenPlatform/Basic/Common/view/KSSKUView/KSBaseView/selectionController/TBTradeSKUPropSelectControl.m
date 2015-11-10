//
//  TBTradeSKUSelectControl.m
//  TBTrade
//
//  Created by christ.yuj on 14-1-20.
//  Copyright (c) 2014年 christ.yuj. All rights reserved.
//

#import "TBTradeSKUPropSelectControl.h"
#import "TBDetailUIStyle.h"
#import "TBDetailSKULayout.h"
#import "TBDetailSKUButton.h"

@interface TBTradeSKUPropSelectControl ()

@end

@implementation TBTradeSKUPropSelectControl

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Accessor

- (void)setSelectedIndex:(NSInteger)index {
    TBDetailSKUButton *button;
    if (_selectedIndex > -1) {
        button = [self.buttons objectAtIndex:_selectedIndex];
        button.selected = NO;
    }
    
    _selectedIndex = index;
    
    if (_selectedIndex >= 0) {
        button = [self.buttons objectAtIndex:_selectedIndex];
        button.selected = YES;
    }
}

- (NSInteger)selectedIndex {
    return _selectedIndex;
}

- (NSUInteger)numberOfSegments {
    return [self.buttons count];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public

- (id)init{
    if (self = [super initWithFrame:CGRectZero]) {
        _buttons = [[NSMutableArray alloc] init];
        [self performLayoutSubviews];
        // 小于0 说明没有选择
        _selectedIndex = -1;
        _title = @"";
    }
    return self;
}

- (void)setItems:(NSArray *)items{
    for (TBDetailSKUButton *button in self.buttons) {
        [button removeFromSuperview];
    }
    
    [self.buttons removeAllObjects];
    
    for (NSString *item in items) {
        TBDetailSKUButton *button = [self createButton:item];
        
        button.accessibilityLabel = item;
        button.accessibilityHint  = [NSString stringWithFormat:@"双击选择%@",item];
        
        [self addSubview:button];
        [self.buttons addObject:button];
    }
    
    [self performLayoutSubviews];
}

- (void)setEnabled:(BOOL)enabled atIndex:(NSUInteger)index {
    TBDetailSKUButton *button = [self.buttons objectAtIndex:index];
    button.enabled = enabled;
}

- (void)setHighlightEnabled:(BOOL)enabled forIndex:(NSUInteger)index {
    TBDetailSKUButton *button = [self.buttons objectAtIndex:index];
    [button setSelected:YES];
    [button setHighlighted:YES];
    button.enabled = enabled;
    
    if (!button.enabled && button.selected) {
        /*iOS系统中当disable和selected状态冲突时为normal状态,而手淘优先展示selected状态*/
        [button setTitleColor:[TBDetailUIStyle colorWithStyle:TBDetailColorStyle_Tag]
                     forState:UIControlStateNormal];
        [button setBackgroundColor:[TBDetailUIStyle colorWithStyle:TBDetailColorStyle_Yellow]
                          forState:UIControlStateNormal];
        [button setBorderColor:[TBDetailUIStyle colorWithStyle:TBDetailColorStyle_Yellow]
                      forState:UIControlStateNormal];
    }
}


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private
- (TBDetailSKUButton *)createButton:(NSString *)title {
    TBDetailSKUButton *button = [[TBDetailSKUButton alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    
    button.reversesTitleShadowWhenHighlighted = NO;
    button.adjustsImageWhenHighlighted = NO;
    
    /*设置不同状态下的字体颜色*/
    [self setButtonStyle:button];
    
    button.layer.borderWidth  = 1.0;
    button.layer.cornerRadius = 3.0;
    
    [button addTarget:self
               action:@selector(propButtonClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [self resizeButton:button withTitle:title];
    return button;
}

-(void)resizeButton:(TBDetailSKUButton*)button withTitle:(NSString*)title{
    button.clipsToBounds            = YES;
    button.titleLabel.numberOfLines = 2;
    button.titleLabel.font          = [TBDetailUIStyle fontWithStyle:TBDetailFontStyle_Chinese
                                                                size:TBDetailFontSize_Title0];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:title forState:UIControlStateNormal];
    
    CGSize size = [title sizeWithFont:button.titleLabel.font
                    constrainedToSize:CGSizeMake(MAX(self.width - 20, 270), TBSKU_PROP_BUTTON_SINGLE_HEIGHT)
                        lineBreakMode:NSLineBreakByClipping];
    float width = MAX(ceil(size.width) + TBSKU_PROP_BUTTON_WIDTH_INNER_WIDTH, TBSKU_PROP_BUTTON_MAX_WIDTH);
    
    if (self.width < 0 || isnan(self.width)) {
        return;
    }

    if (size.height > TBSKU_PROP_BUTTON_MORE_THAN_ONE) {
        button.bounds = CGRectMake(0, 0, width, TBSKU_PROP_BUTTON_DOUBLE_HEIGHT);
        button.titleLabel.textAlignment = NSTextAlignmentLeft;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    }else{
        button.bounds = CGRectMake(0, 0, width, TBSKU_PROP_BUTTON_SINGLE_HEIGHT);
    }
}

-(void)setButtonStyle:(TBDetailSKUButton *)button
{
    /*normal状态*/
    [button setTitleColor:[TBDetailUIStyle colorWithStyle:TBDetailColorStyle_SKUButtonColor]
                 forState:UIControlStateNormal];
    [button setBorderColor:[TBDetailUIStyle colorWithStyle:TBDetailColorStyle_Price2]
                  forState:UIControlStateNormal];
    [button setBackgroundColor:[TBDetailUIStyle colorWithStyle:TBDetailColorStyle_White]
                      forState:UIControlStateNormal];
    
    /*选中/高亮状态*/
    [button setTitleColor:[TBDetailUIStyle colorWithStyle:TBDetailColorStyle_Tag]
                 forState:UIControlStateHighlighted];
    [button setBorderColor:[TBDetailUIStyle colorWithStyle:TBDetailColorStyle_Yellow]
                  forState:UIControlStateHighlighted];
    [button setBackgroundColor:[TBDetailUIStyle colorWithStyle:TBDetailColorStyle_Yellow]
                      forState:UIControlStateHighlighted];
    
    [button setTitleColor:[TBDetailUIStyle colorWithStyle:TBDetailColorStyle_Tag]
                 forState:UIControlStateSelected];
    [button setBorderColor:[TBDetailUIStyle colorWithStyle:TBDetailColorStyle_Yellow]
                  forState:UIControlStateSelected];
    [button setBackgroundColor:[TBDetailUIStyle colorWithStyle:TBDetailColorStyle_Yellow]
                      forState:UIControlStateSelected];
    
    /*设置Disable状态*/
    [button setTitleColor:[TBDetailUIStyle colorWithStyle:TBDetailColorStyle_LineColor1]
                 forState:UIControlStateDisabled];
    [button setBorderColor:[TBDetailUIStyle colorWithStyle:TBDetailColorStyle_LineColor1]
                  forState:UIControlStateDisabled];
    [button setBackgroundColor:[TBDetailUIStyle colorWithStyle:TBDetailColorStyle_White]
                      forState:UIControlStateDisabled];
}

- (void)propButtonClicked:(id)sender {
    NSUInteger index = [self.buttons indexOfObject:sender];
    if (self.selectedIndex != index) {
        self.selectedIndex = index;
    }else{
        self.selectedIndex = -1;
    }
    if ([self.delegate respondsToSelector:@selector(clickedControl:index:)]) {
        [self.delegate clickedControl:self index:index];
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Override
- (void)layoutSubviews {
    [super layoutSubviews];
    [self performLayoutSubviews];
}

- (void)performLayoutSubviews {
    CGFloat width = self.width;
    
    if (_prevWidth == width) {
        return;
    }
    
    _prevWidth = width;
    
    CGFloat x = 0;
    CGFloat y = 0;
    
    int rows = 0;
    
    for (int i = 0; i < [self.buttons count]; ++i) {
        TBDetailSKUButton *button = [self.buttons objectAtIndex:i];
        if (x + button.width > width) {
            x = 0;
            rows++;
            if (i > 0) {
                y = ((TBDetailSKUButton*)[self.buttons objectAtIndex:i-1]).height + y + TBSKU_PROP_LINE_GAP;
            }
        }
        
        button.frame = CGRectMake(x, y, button.width, button.height);
        x += button.width + TBSKU_PROP_HORIZONTAL_GAP;
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    CGSize newSize = size;
    
    if ([self.buttons count] > 0) {
        CGRect rect = self.bounds;
        
        TBDetailSKUButton *button = [self.buttons objectAtIndex:[self.buttons count]-1];
        rect.size.height = button.bottom;
        
        /*Bug,会以中点，上下缩的，不能直接设置Bound*/
        newSize = CGSizeMake(newSize.width, rect.size.height);
    }else {
        newSize = CGSizeZero;
    }
    
    return newSize;
}

@end
