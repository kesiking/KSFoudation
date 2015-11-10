//
//  TBColorPageControl.h
//  taobao4iphone
//
//  Created by Xu Jiwei on 11-4-22.
//  Copyright 2011 Taobao.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    WeAppRoundPageControl, 
    WeAppRectPageControl
} WeAppPageControlType;

@interface WeAppColorPageControl : UIControl {
    WeAppPageControlType _type;
    NSInteger   _width;
    NSInteger   _height;
    NSInteger   _gap;
    UIColor*    _borderColor;
    BOOL        _isSolid;
}

@property (nonatomic, assign)   NSInteger       currentPage;
@property (nonatomic, assign)   NSInteger       numberOfPages;
@property (nonatomic, assign)   BOOL            hidesForSinglePage;
@property (nonatomic, assign)   WeAppPageControlType type;

@property (nonatomic, retain)   UIColor         *normalPageColor;
@property (nonatomic, retain)   UIColor         *currentPageColor;

@property (nonatomic, assign)   NSInteger       width;
@property (nonatomic, assign)   NSInteger       height;
@property (nonatomic, assign)   NSInteger       gap;
@property (nonatomic, assign)   BOOL            isSolid;
@property (nonatomic, assign)   CGFloat          borderWidth;
@property (nonatomic, retain)   UIColor         *borderColor;

@end
