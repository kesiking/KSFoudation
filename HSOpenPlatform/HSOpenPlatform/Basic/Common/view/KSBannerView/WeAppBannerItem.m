//
//  WeAppBannerItem.m
//  WeAppSDK
//
//  Created by zhuge.zzy on 7/6/14.
//  Copyright (c) 2014 1111. All rights reserved.
//

#import "WeAppBannerItem.h"

@implementation WeAppBannerItem

-(void)setBannerItem:(WeAppBannerItem*)item{
    if (item == nil) {
        return;
    }
    if (item.picture) {
        _picture   = [NSString stringWithFormat:@"%@",item.picture];
    }
    if (item.picUrl) {
        _picUrl    = [NSString stringWithFormat:@"%@",item.picUrl];
    }
    if (item.redirectUrl) {
        _redirectUrl    = [NSString stringWithFormat:@"%@",item.redirectUrl];
    }
    if (item.url) {
        _url    = [NSString stringWithFormat:@"%@",item.url];
    }
    if (item.pic_url_2x) {
        _pic_url_2x    = [NSString stringWithFormat:@"%@",item.pic_url_2x];
    }
    if (item.pic_url) {
        _pic_url    = [NSString stringWithFormat:@"%@",item.pic_url];
    }
    _hour = item.hour;
}


- (void) setFromDictionary:(NSDictionary *)dict
{
    [super setFromDictionary:dict];
}

@end
