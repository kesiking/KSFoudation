//
//  WeAppSelectorItem.m
//  WeAppSDK
//
//  Created by zhuge.zzy on 7/4/14.
//  Copyright (c) 2014 1111. All rights reserved.
//

#import "WeAppSelectorItem.h"

@implementation WeAppSelectorItem

- (void) setFromDictionary:(NSDictionary *)dict
{
	self.title = [dict objectForKey:@"title"];
    id selectedBackgroundUrl = [dict objectForKey:@"selectedBackgroundUrl"];
    id selectedBackgroundImage = [dict objectForKey:@"selectedBackgroundImage"];
    id backgroundUrl = [dict objectForKey:@"backgroundUrl"];
    id backgroundImage = [dict objectForKey:@"backgroundImage"];
    if (selectedBackgroundUrl) {
        self.selectedBackgroundUrl = selectedBackgroundUrl;
    }else if (selectedBackgroundImage){
        self.selectedBackgroundUrl = selectedBackgroundImage;
    }
    if (backgroundUrl) {
        self.backgroundUrl = backgroundUrl;
    }else if (backgroundImage){
        self.backgroundUrl = backgroundImage;
    }
    self.imageQuality = [[dict objectForKey:@"imageQuality"] integerValue];
	self.iconUrl = [dict objectForKey:@"iconUrl"];
    self.newMsgNum = [[dict objectForKey:@"newMsgNum"] unsignedIntegerValue];
    self.formatType = [dict objectForKey:@"formatType"];
	self.precision = [dict objectForKey:@"precision"];
    self.isShowRedDot = [[dict objectForKey:@"isShowRedDot"] boolValue];
    self.userTrack = [dict objectForKey:@"userTrack"];
}

- (NSDictionary *) toDictionary{
	NSMutableDictionary *bufferDict = [[NSMutableDictionary alloc] init];
    
	if (self.title) {
		[bufferDict setObject:self.title forKey:@"title"];
	}
	if (self.selectedBackgroundUrl) {
		[bufferDict setObject:self.selectedBackgroundUrl forKey:@"selectedBackgroundUrl"];
	}
    if (self.backgroundUrl) {
        [bufferDict setObject:self.backgroundUrl forKey:@"backgroundUrl"];
    }
    if (self.iconUrl) {
        [bufferDict setObject:self.iconUrl forKey:@"iconUrl"];
    }
    
    [bufferDict setObject:[NSNumber numberWithUnsignedInteger:self.newMsgNum] forKey:@"newMsgNum"];
    if (self.formatType) {
        [bufferDict setObject:self.formatType forKey:@"formatType"];
    }
    if (self.precision) {
        [bufferDict setObject:self.precision forKey:@"precision"];
    }
    if (self.userTrack) {
        [bufferDict setObject:self.userTrack forKey:@"userTrack"];
    }
    [bufferDict setObject:[NSNumber numberWithInteger:self.imageQuality] forKey:@"imageQuality"];
    
    [bufferDict setObject:[NSNumber numberWithBool:self.isShowRedDot] forKey:@"isShowRedDot"];
    
	NSDictionary *outputDict = [NSDictionary dictionaryWithDictionary:bufferDict];
	return outputDict;
}

@end
