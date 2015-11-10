//
//  TBErrorView.m
//  taobao4iphone
//
//  Created by Cao Tim on 11-10-28.
//  Copyright (c) 2011年 Taobao.com. All rights reserved.
//

#import "KSErrorView.h"


@implementation KSErrorView

@synthesize titleLabel = _titleLabel;
@synthesize subtitleLabel = _subtitleLabel;
@synthesize actionButton = _actionButton;
@synthesize footerView = _footerView;
@synthesize headerView = _headerView;

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma -
#pragma mark NSObject



- (id)initWithImage:(id)image title:(NSString*)title subtitle:(NSString*)subtitle actionButtonTitle:(NSString*)actionButtonTitle target:(id)target selector:(SEL)selector {
    return [self initWithImage:image
                         title:title
                      subtitle:subtitle
             actionButtonTitle:actionButtonTitle
             actionButtonImage:[[UIImage imageNamed:@"tb_btn_all_square_normal.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]
   actionButtonHighligtedImage:[[UIImage imageNamed:@"tb_btn_all_square_press.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)]
                        target:target
                      selector:selector];
}

- (id)initWithImage:(id)image title:(NSString*)title subtitle:(NSString*)subtitle actionButtonTitle:(NSString*)actionButtonTitle actionButtonImage:(UIImage*)actionButtonImage actionButtonHighligtedImage:(UIImage*)actionButtonHighlightedImage target:(id)target selector:(SEL)selector {
    UIButton* actionButton = nil;
    if (target && selector) {
        actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [actionButton setTitle:actionButtonTitle forState:UIControlStateNormal];
        [actionButton setTitleColor:[UIColor colorWithRed:95/255.0f green:100/255.0f blue:110/255.0f alpha:1.0f] forState:UIControlStateNormal];
        [actionButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        actionButton.titleLabel.shadowOffset = CGSizeMake(0, 1);
        actionButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        [actionButton setTitleEdgeInsets:UIEdgeInsetsMake(10, 20, 10, 20)];
        [actionButton setBackgroundImage:actionButtonImage forState:UIControlStateNormal];
        [actionButton setBackgroundImage:actionButtonHighlightedImage forState:UIControlStateSelected];
        [actionButton setBackgroundImage:actionButtonHighlightedImage forState:UIControlStateHighlighted];
        [actionButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    return [self initWithImage:image title:title subtitle:subtitle actionButton:actionButton];
}

- (id)initWithImage:(id)image title:(NSString*)title subtitle:(NSString*)subtitle actionButton:(UIButton*)actionButton {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        if ([image isKindOfClass:[UIImage class]]) {
            _imageView = [[UIImageView alloc] initWithImage:image];
            _imageView.backgroundColor = self.backgroundColor;
        } else if ([image isKindOfClass:[UIView class]]) {
            _imageView = image;
        }
        [self addSubview:_imageView];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setFrame:CGRectMake(0, 0, self.frame.size .width, 10)];
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _titleLabel.backgroundColor = self.backgroundColor;
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor colorWithRed:.24 green:.26 blue:.27 alpha:1];
        _titleLabel.textAlignment = UITextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = title;
        [self addSubview:_titleLabel];
        
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _subtitleLabel.backgroundColor = self.backgroundColor;
        _subtitleLabel.font = [UIFont systemFontOfSize:14];
        _subtitleLabel.textColor = [UIColor colorWithWhite:170/255.0f alpha:1.0f];
        _subtitleLabel.textAlignment = UITextAlignmentCenter;
        _subtitleLabel.numberOfLines = 0;
        _subtitleLabel.text = subtitle;
        [_subtitleLabel setFrame:CGRectMake(0, 0, self.frame.size .width, 10)];
        _subtitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_subtitleLabel];
        if (actionButton) {
            _actionButton = actionButton;
            _actionButton.backgroundColor = self.backgroundColor;
            [self addSubview:_actionButton];
        }
    }
    return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma -
#pragma mark UIView

- (void)layoutSubviews {
    [_imageView sizeToFit];
    [_titleLabel sizeToFit];
    [_subtitleLabel sizeToFit];
    [_actionButton sizeToFit];
    _actionButton.frame = CGRectMake(0, 0, 112, 32);

    CGFloat headerMargin = _headerView ? 10 : 0;
    CGFloat margin1 = 16;
    CGFloat margin2 = 12;
    CGFloat margin3 = 20;
    CGFloat footerMargin = _footerView ? 10.0f : 0;
    [self addSubview:_headerView];
    [self addSubview:_footerView];
    
    CGFloat totalHeight = _headerView.frame.size.height + headerMargin + _imageView.frame.size.height + margin1 + _titleLabel.frame.size.height + margin2 + _subtitleLabel.frame.size.height + margin2 + _actionButton.frame.size.height + (_actionButton?margin3:0) + _footerView.frame.size.height + footerMargin;
    
    CGFloat top = floor(self.frame.size.height/2 - totalHeight/2);
    
    _headerView.frame = CGRectMake(floor(self.frame.size.width/2.0f - _headerView.frame.size.width/2.0f), top, _headerView.frame.size.width, _headerView.frame.size.height);
    
    top = top + _headerView.frame.size.height + headerMargin;
    _imageView.frame = CGRectMake(floor(self.frame.size.width/2 - _imageView.frame.size.width/2), top,
                                  _imageView.frame.size.width, _imageView.frame.size.height);
    top = _imageView.frame.origin.y + _imageView.frame.size.height + margin1;
    _titleLabel.frame = CGRectMake(0, top,
                                   self.frame.size .width, _titleLabel.frame.size.height);
    top = _titleLabel.frame.origin.y + _titleLabel.frame.size.height + margin2;
    _subtitleLabel.frame = CGRectMake(10, top,
                                      self.frame.size .width - 20, _subtitleLabel.frame.size.height);
    
    top = _subtitleLabel.frame.origin.y + _subtitleLabel.frame.size.height  + margin2;
    _actionButton.frame = CGRectMake(floor(self.frame.size.width/2 - _actionButton.frame.size.width/2), top,
                                     _actionButton.frame.size.width, _actionButton.frame.size.height);
    
    top = top + _actionButton.frame.size.height + footerMargin;
    _footerView.frame = CGRectMake(floor(self.frame.size.width/2.0f - _footerView.frame.size.width/2.0f), top, _footerView.frame.size.width, _footerView.frame.size.height);
}

@end
