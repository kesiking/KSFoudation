//
//  KSDebubSelectorButton.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/1.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugSelectorButton.h"

#define labelWidth  (12)
#define labelHeight (labelWidth)
#define pointWidth  (7)
#define pointHeight (pointWidth)
#define iconWidth   (24)
#define iconHeight  (iconWidth)

#define standBorder (1)

#define maxNumberWidth (20)

@implementation KSDebugSelectorButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupView];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.backgroundColor = KSDebugRGB(0xfb, 0xfb, 0xfb);
    [self initButton];
    [self initLabelAndPoint];
    //    [self initSelectorIcon];
}

-(void)initLabel{
    _textLabel = [[UILabel alloc] init];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.opaque = YES;
    _textLabel.frame = CGRectZero;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = [UIFont boldSystemFontOfSize:14];
    [_textLabel setTextColor:[UIColor whiteColor]];
    [self addSubview:_textLabel];
}

-(void)initButton{
    _imageButton = [[UIButton alloc] init];
    _imageButton.backgroundColor = [UIColor whiteColor];
    _imageButton.opaque = YES;
    _imageButton.frame = CGRectZero;
    
    [_imageButton setImage:nil forState:UIControlStateNormal];
    _imageButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    _imageButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [_imageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_imageButton setImageEdgeInsets:UIEdgeInsetsMake(0.0, -5, 0.0, 0.0)];
    [_imageButton setAdjustsImageWhenHighlighted:NO];
    
    [self addSubview:_imageButton];
}

-(void)initLabelAndPoint{
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, labelHeight)];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    _numberLabel.font = [UIFont systemFontOfSize:8.0];
    _numberLabel.textColor = [UIColor whiteColor];
    _numberLabel.backgroundColor = [UIColor clearColor];
    
    _selectorNumImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, labelWidth, labelHeight)];
    [_selectorNumImage addSubview:_numberLabel];
    _selectorNumImage.opaque = YES;
    _selectorNumImage.hidden = YES;
    [self addSubview:_selectorNumImage];
    
    _selectorPoint = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, pointWidth, pointHeight)];
    _selectorPoint.opaque = YES;
    _selectorPoint.hidden = YES;
    [self addSubview:_selectorPoint];
}

-(void)initSelectorIcon{
    _selectorIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
    _selectorIcon.opaque = YES;
    _selectorIcon.hidden = YES;
    [self addSubview:_selectorIcon];
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    //用button方式实现
    _imageButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _selectorNumImage.frame = CGRectMake(self.frame.size.width - _selectorNumImage.frame.size.width - standBorder, 0 + (self.frame.size.height - _selectorNumImage.frame.size.height)/2, _selectorNumImage.frame.size.width, _selectorNumImage.frame.size.height);
    _selectorPoint.frame = CGRectMake(self.frame.size.width - _selectorPoint.frame.size.width - standBorder, 0 + (self.frame.size.height - _selectorPoint.frame.size.height)/2, _selectorPoint.frame.size.width, _selectorPoint.frame.size.height);
    _selectorIcon.frame = CGRectMake(8, 0 + (self.frame.size.height - iconHeight)/2, iconWidth, iconHeight);
    
}

-(void)dealloc{
    NSLog(@"dealloc");
}

//展示小红点并隐藏numImage
-(void)hideSelectorNumImage:(BOOL)hide{
    self.selectorNumImage.hidden = hide;
    self.selectorPoint.hidden = !hide;
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    if (title == nil || title.length <= 0) {
        return;
    }
    if (_textLabel) {
        _textLabel.text = title;
    }else if(_imageButton){
        [_imageButton setTitle:title forState:state];
    }
    
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [self.imageButton addTarget:target action:action forControlEvents:controlEvents];
}

@end
