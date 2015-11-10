//
//  WeAppBannerItem.h
//  WeAppSDK
//
//  Created by zhuge.zzy on 7/6/14.
//  Copyright (c) 2014 1111. All rights reserved.
//

#import "WeAppComponentBaseItem.h"

@interface WeAppBannerItem : WeAppComponentBaseItem

@property (nonatomic, strong) NSString*         bannerId;

@property (nonatomic, strong) NSString*         data_type;
@property (nonatomic, strong) NSString*         title;
@property (nonatomic, strong) NSString*         url;
@property (nonatomic, assign) BOOL              full_image;
@property (nonatomic, strong) NSString*         pic_url;
@property (nonatomic, strong) NSString*         pic_url_2x;
@property (nonatomic, strong) NSDictionary*     extra_data;

@property (nonatomic, strong) NSString*         picture;
@property (nonatomic, strong) NSString*         picUrl;
@property (nonatomic, strong) NSString*         redirectUrl;
@property (nonatomic, assign) NSUInteger        hour;

-(void)setBannerItem:(WeAppBannerItem*)item;

@end
