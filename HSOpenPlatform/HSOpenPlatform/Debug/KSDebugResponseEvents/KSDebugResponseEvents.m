//
//  KSDebugResponseEvents.m
//  HSOpenPlatform
//
//  Created by jinmiao on 15/12/22.
//  Copyright © 2015年 孟希羲. All rights reserved.
//

#import "KSDebugResponseEvents.h"
#import "KSDebugResponseEventsModel.h"

@interface KSDebugResponseEvents ()

@property (strong,nonatomic) NSMutableArray *eventsArray;

@end

@implementation KSDebugResponseEvents

-(instancetype)init{
    if (self = [super init]) {
        _eventsArray = [[NSMutableArray alloc]init];
        
    }
    return self;

}

+ (instancetype)sharedEvents {
    static id sharedEvents = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedEvents = [[self alloc]init];
    });
    return sharedEvents;
}

+(void)beginLoading:(NSString *)eventId{
    [KSDebugResponseEvents beginLoading:eventId atViewController:@""];
}

+(void)beginLoading:(NSString *)eventId atViewController:(NSString *)viewControllerName{
    KSDebugResponseEventsModel *downloadEventsModel = [[KSDebugResponseEventsModel alloc]init];
    downloadEventsModel.beginTime = [NSDate date];
    downloadEventsModel.eventId = eventId;
    downloadEventsModel.viewControllerName = viewControllerName;
    [[KSDebugResponseEvents sharedEvents].eventsArray insertObject:downloadEventsModel atIndex:0];

}

+(void)didFinishLoading:(NSString *)eventId content:(BOOL)isEmpty
{
    [KSDebugResponseEvents didFinishLoading:eventId content:isEmpty atViewController:@""];
}
    

+(void)didFinishLoading:(NSString *)eventId content:(BOOL)isEmpty atViewController:(NSString *)viewControllerName{
    NSDate *currentDate = [NSDate date];
    for (KSDebugResponseEventsModel *eventModel in [KSDebugResponseEvents sharedEvents].eventsArray) {
        if (eventModel.eventId == eventId) {
            eventModel.finishTime = currentDate;
            eventModel.isContentEmpty = isEmpty;
        }
    }
}

//直接用viewControllerName作为开始结束配对用的唯一标识符

+(void)beginRenderingPageView:(NSString *)viewControllerName{
    NSDate *currentDate = [NSDate date];
    KSDebugResponseEventsModel *renderEventsModel = [[KSDebugResponseEventsModel alloc]init];
    renderEventsModel.beginTime = currentDate;
    renderEventsModel.viewControllerName = viewControllerName;
    [[KSDebugResponseEvents sharedEvents].eventsArray insertObject:renderEventsModel atIndex:0];

}
+(void)didFinishRenderingPageView:(NSString *)viewControllerName{
    NSDate *currentDate = [NSDate date];
    for (KSDebugResponseEventsModel *eventModel in [KSDebugResponseEvents sharedEvents].eventsArray) {
        if (eventModel.viewControllerName == viewControllerName) {
            eventModel.finishTime = currentDate;
        }
    }
    
}


+(void)didFailLoading:(NSString *)eventId withError:(NSError *)error{
    [KSDebugResponseEvents didFailLoading:eventId atViewController:@"" withError:error];
}
+(void)didFailLoading:(NSString *)eventId atViewController:(NSString *)viewControllerName withError:(NSError *)error{
    KSDebugResponseEventsModel *errorEventsModel = [[KSDebugResponseEventsModel alloc]init];
    errorEventsModel.eventId = eventId;
    errorEventsModel.error = error;
    errorEventsModel.viewControllerName = viewControllerName;

}


@end
