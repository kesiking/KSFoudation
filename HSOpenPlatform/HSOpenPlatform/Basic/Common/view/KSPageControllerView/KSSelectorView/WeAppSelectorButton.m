//
//  WeAppSelectorButton.m
//  WeAppSDK
//
//  Created by zhuge.zzy on 7/4/14.
//  Copyright (c) 2014 1111. All rights reserved.
//

#import "WeAppSelectorButton.h"
#import "WeAppUtils.h"
#import "WeAppConstant.h"

#define labelWidth  (12)
#define labelHeight (labelWidth)
#define pointWidth  (7)
#define pointHeight (pointWidth)
#define iconWidth   (24)
#define iconHeight  (iconWidth)

#define standBorder (1)

#define maxNumberWidth (20)

@implementation WeAppSelectorButton

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
    self.backgroundColor = RGB(0xfb, 0xfb, 0xfb);
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
    _selectorNumImage.image = [UIImage imageNamed:@"account_cicle_remind.png"];
    [_selectorNumImage addSubview:_numberLabel];
    _selectorNumImage.opaque = YES;
    _selectorNumImage.hidden = YES;
    [self addSubview:_selectorNumImage];
    
    _selectorPoint = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, pointWidth, pointHeight)];
    _selectorPoint.image = [UIImage imageNamed:@"account_toolbar_icon.png"];
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

//默认展示9+的情况
-(void)setNumber:(NSUInteger)number andNeedPoint:(BOOL)needPoint{
    [self setNumber:number formatType:@"plus" precision:@"1" andNeedPoint:needPoint];
}

-(void)setNumber:(NSUInteger)number formatType:(NSString*)formatType precision:(NSString*)precision andNeedPoint:(BOOL)needPoint{
    if (!needPoint) {
        //展示numImage
        [self hideSelectorNumImage:NO];
        //根据number判断
        if (number == 0) {
            //不展示
            self.selectorNumImage.hidden = YES;
        }else{
            //展示数字
            NSString *textNumber = [WeAppUtils longNumberAbbreviation:number number:3];//[WeAppDataUtils getStringFromNumber:[NSNumber numberWithUnsignedInteger:number] formatType:formatType precision:precision withData:nil];
            if (textNumber) {
                [self.numberLabel setText:textNumber];
            }else if(number > 0 && number < 10){
                [self.numberLabel setText:[NSString stringWithFormat:@"%lu",number]];
            }else{
                [self.numberLabel setText:[NSString stringWithFormat:@"9+"]];
            }
            
            //自动适配大小
            CGSize numberSize = [self.numberLabel.text sizeWithFont:self.numberLabel.font constrainedToSize:CGSizeMake(maxNumberWidth, self.numberLabel.height) lineBreakMode:NSLineBreakByWordWrapping];
            //修复ios7下评论展示显示···问题，计算的宽度加2
            if (numberSize.width > labelWidth) {
                [self.numberLabel setWidth:numberSize.width + 2];
                [self.selectorNumImage setWidth:numberSize.width + 2];
            }
            [self.selectorNumImage setOrigin:CGPointMake(self.width - self.selectorNumImage.width - standBorder, self.selectorNumImage.origin.y)];
        }
    }else{
        //展示小红点
        [self hideSelectorNumImage:YES];
    }
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
        //自动适配大小
        //        CGSize numberSize = [title sizeWithFont:self.imageButton.titleLabel.font constrainedToSize:CGSizeMake(self.imageButton.width, self.imageButton.height) lineBreakMode:NSLineBreakByWordWrapping];
        //        self.imageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //        [_imageButton.titleLabel setSize:numberSize];
        //        [_imageButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    }
    
}

-(void)setSelectorIcon:(NSString *)imageUrl forState:(UIControlState)state{
    [self setSelectorIcon:imageUrl forState:state forParam:nil];
}

-(void)setSelectorIcon:(NSString *)imageUrl forState:(UIControlState)state forParam:(NSDictionary *)param{
    if (imageUrl == nil || imageUrl.length <= 0) {
        
        if (_selectorIcon) {
            _selectorIcon.hidden = YES;
        }else if(_imageButton){
            [_imageButton setImage:nil forState:state];
        }
        return;
    }
    
    if (_selectorIcon) {
        _selectorIcon.hidden = NO;
        [_selectorIcon sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    }else if(_imageButton){
        [_imageButton sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal];
    }
}

// 设置selector的背景图片
-(void)setBackgroundImage:(NSString *)imageUrl forState:(UIControlState)state{
    [self setBackgroundImage:imageUrl forState:state forParam:nil];
}

-(void)setBackgroundImage:(NSString *)imageUrl forState:(UIControlState)state forParam:(NSDictionary *)param{
    if (imageUrl == nil || imageUrl.length <= 0) {
        return;
    }
    [_imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:imageUrl] forState:state];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
	[self.imageButton addTarget:target action:action forControlEvents:controlEvents];
}

@end
