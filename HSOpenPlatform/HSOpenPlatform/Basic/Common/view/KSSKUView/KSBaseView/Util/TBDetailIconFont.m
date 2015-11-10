//
//  TBDetailIconFont.m
//  
//
//  Created by lv on 14-6-10.
//  Copyright (c) 2014年. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "TBDetailIconFont.h"
#import "UIKit/UIKit.h"
static CGFontRef globalFontRef = nil;
#define kDefaultFontColor     [UIColor colorWithRed:0x5f/255.0 green:0x64/255.0 blue:0x6e/255.0 alpha:1.0]
@implementation TBDetailIconFont

#pragma mark - Public  Method
+ (UIFont*)iconFontWithSize:(NSInteger)fontSize{
    UIFont *iconfont = nil;
    if (fontSize > 0 ) {
        iconfont = [UIFont fontWithName:@"detailiconfont" size: fontSize];
    }
    
    if (iconfont == nil) {
        //其他业务bundle的mainclient 还是自动加载吧。
//        if (![[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.taobao.taobao4iphone"]) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                NSString *path = [[NSBundle mainBundle] pathForResource:@"detailiconfont" ofType:@"ttf"];
                [TBDetailIconFont loadFontAtPath:path];
            });
            iconfont = [UIFont fontWithName:@"detailiconfont" size: fontSize];
//        }
    }
    return iconfont;
}


+ (UIButton*)iconFontButtonWithType:(UIButtonType)type fontSize:(NSInteger)fontSize text:(NSString*)text{
    text = [[self iconfontMapDict] objectForKey:text] ? [[self iconfontMapDict] objectForKey:text] : text;
    UIButton *button = [UIButton buttonWithType:type];
    [button setTitleColor:kDefaultFontColor forState:UIControlStateNormal];
    [button setTitleColor:kDefaultFontColor forState:UIControlStateHighlighted];
    [button.titleLabel setFont:[TBDetailIconFont iconFontWithSize:fontSize]];
    [button setTitle:text forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor clearColor]];
    return button;
}

+ (UILabel*)iconFontLabelWithFrame:(CGRect)frame fontSize:(NSInteger)fontSize text:(NSString*)text{
    text = [[self iconfontMapDict] objectForKey:text] ? [[self iconfontMapDict] objectForKey:text] : text;
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.font = [TBDetailIconFont iconFontWithSize:fontSize];
    label.textColor = kDefaultFontColor;
    label.text = text;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

+ (NSString*)iconFontUnicodeWithName:(NSString*)name{
    NSString *result = nil;
    if ([name length] >0) {
        result =  [[self iconfontMapDict] objectForKey:name];
    }
    result = result ? result : name;
    return result;
}

#pragma mark - Private Method
//////////////////////////////////////////////////////////////////////////////////
+ (void )loadFontAtPath:(NSString*)path
{
    if ([path length] == 0) {
        return;
    }
    
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    if(data == nil)
    {
#ifdef DEBUG
        NSLog(@"Failed to load font. Data at path is null path = %@", path);
#endif //ifdef Debug
        return;
    }
    CFErrorRef error;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    if(!CTFontManagerRegisterGraphicsFont(font, &error)){
#ifdef DEBUG
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
        return ;
#endif //ifdef Debug
    }
    //    CFStringRef fontName = CGFontCopyFullName(font);
    //    NSLog(@"Loaded: %@", fontName);
    //
    //    CFRelease(fontName);
    if (font) {
        globalFontRef = font;
    }
    CFRelease(provider);
}

+ (void) unloadFont
{
    CFErrorRef error;
    if(globalFontRef){
        CTFontManagerUnregisterGraphicsFont(globalFontRef, &error);
        CFRelease(globalFontRef);
        globalFontRef = nil;
    }
    else{
        NSLog(@"WARNING: Font cannot be unloaded");
    }
}
//////////////////////////////////////////////////////////////////////////////////
+ (NSDictionary*)iconfontMapDict{
    static NSDictionary * mapDict = nil;
    if (mapDict == nil) {
        //http://yunpan.taobao.com/share/link/D5FoiG4ZE
        mapDict = @{@"home"     : @"\U0000a01a",
                    @"we"       : @"\U0000a02a",
                    @"discover" : @"\U0000a03a",
                    @"cart"     : @"\U0000a04a",
                    @"my"       : @"\U0000a05a",
                    @"more"     : @"\U0000a06a",
                    @"back"     : @"\U0000a07a",
                    @"message"  : @"\U0000a08a",
                    
                    @"home_fill"     : @"\U0000a01b",
                    @"we_fill"      : @"\U0000a02b",
                    @"discover_fill" : @"\U0000a03b",
                    @"cart_fill"     : @"\U0000a04b",
                    @"my_fill"       : @"\U0000a05b",
                    @"friend_fill"   : @"\U0000a17b",
                    
                    @"scan"         : @"\U0000a10a",
                    @"settings"      : @"\U0000a11a",
                    @"share"        : @"\U0000a12a",
                    @"list"         : @"\U0000a13a",
                    @"cascades"     : @"\U0000a14a",
                    @"sort"         : @"\U0000a15a",
                    @"remind"       : @"\U0000a16a",
                    @"friend"       : @"\U0000a17a",
                    @"profile"      : @"\U0000a18a",
                    @"qr_code"      : @"\U0000a19a",
                    @"refresh"      : @"\U0000a20a",
                    
                    @"favor"        : @"\U0000b01a",
                    @"time"         : @"\U0000b02a",
                    @"location"     : @"\U0000b03a",
                    @"taxi"         : @"\U0000b04a",
                    @"phone"        : @"\U0000b05a",
                    @"edit"         : @"\U0000b06a",
                    @"search"       : @"\U0000b07a",
                    @"delete"       : @"\U0000b08a",
                    
                    @"emoji"        : @"\U0000b09a",
                    @"appreciate"   : @"\U0000b10a",
                    @"loading"      : @"\U0000b11a",
                    @"pull_up"      : @"\U0000b12a",
                    @"pull_down"    : @"\U0000b13a",
                    @"footprint"    : @"\U0000b14a",
                    @"top"          : @"\U0000b15a",
                    @"filter"       : @"\U0000b16a",
                    @"like"         : @"\U0000b17a",
                    @"comment"      : @"\U0000b18a",
                    @"same"         : @"\U0000b19a",
                    @"order"        : @"\U0000b20a",
                    @"notification" : @"\U0000b21a",
                    @"camera"       : @"\U0000b22a",
                    @"tag"          : @"\U0000b23a",
                    @"form"         : @"\U0000b24a",
                    @"pic"          : @"\U0000b25a",
                    @"link"             : @"\U0000b26a",
                    @"friend_add"       : @"\U0000b27a",
                    @"address_book"     : @"\U0000b28a",
                    @"unlock"           : @"\U0000b29a",
                    @"lock"             : @"\U0000b30a",
                    @"friend_famous"    : @"\U0000b31a",
                    @"present"          : @"\U0000b32a",
                    @"selection"        : @"\U0000b34a",
                    @"attention"        : @"\U0000b35a",
                    @"explore"          : @"\U0000b36a",
                    @"activity"         : @"\U0000b37a",
                    @"vip"              : @"\U0000b38a",
                    @"goods"            : @"\U0000b39a",
                    @"redpacket"        : @"\U0000b41a",
                    @"similar"          : @"\U0000b42a",
                    @"game"             : @"\U0000b43a",
                    @"bar_code"         : @"\U0000b44a",
                    @"reward"           : @"\U0000b45a",
                    @"recharge"         : @"\U0000b46a",
                    @"vip_card"         : @"\U0000b47a",
                    @"voice"            : @"\U0000b48a",
                    @"friend_favor"     : @"\U0000b49a",
                    @"wifi"             : @"\U0000b50a",
                    @"camera_rotate"    : @"\U0000b51a",
                    @"light"            : @"\U0000b52a",
                    @"light_forbid"     : @"\U0000b53a",
                    @"light_auto"       : @"\U0000b54a",
                    @"flashlight_close" : @"\U0000b55a",
                    @"flashlight_open"  : @"\U0000b56a",
                    @"search_list"      : @"\U0000b57a",
                    @"service"          : @"\U0000b58a",
                    @"down"             : @"\U0000b59a",
                    @"mobile"           : @"\U0000b60a",
                    @"upstage"          : @"\U0000b61a",
                    @"countdown"        : @"\U0000b62a",
                    @"notice"           : @"\U0000b63a",
                    @"qiang"            : @"\U0000b64a",
                    @"copy"             : @"\U0000b65a",
                    @"pull_right"       : @"\U0000b66a",
                    @"pull_left"        : @"\U0000b67a",
                    @"keyboard"         : @"\U0000b68a",
                    @"rank"             : @"\U0000b69a",
                    @"new"              : @"\U0000b70a",
                    @"male"             : @"\U0000b71a",
                    @"female"           : @"\U0000b72a",
                    @"brand"            : @"\U0000b73a",
                    @"choiceness"       : @"\U0000b74a",
                    @"baby"             : @"\U0000b75a",
                    @"clothes"          : @"\U0000b76a",
                    @"creative"         : @"\U0000b77a",
                    @"bad"              : @"\U0000b78a",
                    @"camera_add"       : @"\U0000b79a",
                    @"focus"            : @"\U0000b80a",
                    
                    
                    
                    @"favor_fill"         : @"\U0000b01b",
                    @"time_fill"          : @"\U0000b02b",
                    @"location_fill"      : @"\U0000b03b",
                    @"delete_fill"        : @"\U0000b08b",
                    
                    @"appreciate_fill"    : @"\U0000b10b",
                    @"info_fill"          : @"\U0000b16b",
                    
                    @"like_fill"          : @"\U0000b17b",
                    @"comment_fill"       : @"\U0000b18b",
                    @"same_fill"          : @"\U0000b19b",
                    @"notification_fill"  : @"\U0000b21b",
                    @"camera_fill"        : @"\U0000b22b",
                    @"tag_fill"           : @"\U0000b23b",
                    @"friend_add_fill"    : @"\U0000b27b",
                    @"selection_fill"     : @"\U0000b34b",
                    @"attention_fill"     : @"\U0000b35b",
                    @"explore_fill"       : @"\U0000b36b",
                    
                    @"notification_forbid_fill"    : @"\U0000b40b",
                    @"reward_fill"                 : @"\U0000b45b",
                    @"recharge_fill"               : @"\U0000b46b",
                    @"voice_fill"                  : @"\U0000b48b",
                    @"light_fill"                  : @"\U0000b52b",
                    @"mobile_fill"                 : @"\U0000b60b",
                    @"upstage_fill"                : @"\U0000b61b",
                    @"countdown_fill"              : @"\U0000b62b",
                    @"notice_fill"                 : @"\U0000b63b",
                    
                    @"rank_fill"                    : @"\U0000b69b",
                    @"new_fill"                     : @"\U0000b70b",
                    @"brand_fill"                   : @"\U0000b73b",
                    @"choiceness_fill"              : @"\U0000b74b",
                    @"baby_fill"                    : @"\U0000b75b",
                    @"clothes_fill"                 : @"\U0000b76b",
                    @"creative_fill"                : @"\U0000b77b",
                    
                    
                    @"pay"          : @"\U0000c01a",
                    @"send"         : @"\U0000c02a",
                    @"deliver"      : @"\U0000c03a",
                    @"evaluate"     : @"\U0000c04a",
                    @"refund"       : @"\U0000c05a",
                    @"wang"         : @"\U0000c06a",
                    @"ticket"       : @"\U0000c07a",
                    @"shop"         : @"\U0000c08a",
                    
                    @"wang_fill"    : @"\U0000c06b",
                    @"shop_fill"    : @"\U0000c08b",
                    
                    
                    @"check"        : @"\U0000d01a",
                    @"round_check"  : @"\U0000d02a",
                    @"close"        : @"\U0000d03a",
                    @"round_close"  : @"\U0000d04a",
                    @"right"        : @"\U0000d05a",
                    @"round_right"  : @"\U0000d06a",
                    @"unfold"       : @"\U0000d07a",
                    @"warn"         : @"\U0000d08a",
                    @"question"     : @"\U0000d09a",
                    @"add"          : @"\U0000d10a",
                    @"round_add"    : @"\U0000d11a",
                    @"round"        : @"\U0000d12a",
                    @"square"       : @"\U0000d13a",
                    @"square_check" : @"\U0000d14a",
                    @"fold"         : @"\U0000d15a",
                    @"info"         : @"\U0000d16a",
                    
                    
                    @"round_check_fill"     : @"\U0000d02b",
                    @"round_close_fill"     : @"\U0000d04b",
                    @"round_right_fill"     : @"\U0000d06b",
                    @"warn_fill"            : @"\U0000d08b",
                    @"question_fill"        : @"\U0000d09b",
                    @"round_add_fill"       : @"\U0000d11b",
                    @"square_check_fill"    : @"\U0000d14b",
                    
                    @"weibo"                : @"\U0000e01a",
                    @"big"                  : @"\U0000e02a",
                    @"tmall"                : @"\U0000e03a",
                    
                    @"mobile_tao"         : @"\U0000e05a",
                    @"tao"                : @"\U0000e06a",
                    @"1212"               : @"\U0000e08a",
                    
                    };
 
    }
    return mapDict;
}


@end
