//
//  KSMemoryCacheArrayPerformenceTexts.m
//  HSOpenPlatform
//
//  Created by 孟希羲 on 15/12/9.
//  Copyright (c) 2015年 孟希羲. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "KSMemoryCacheArray.h"

@interface KSMemoryCacheArrayPerformenceTexts : XCTestCase{
    KSMemoryCacheArray *memoryCacheArrayAddObject;
}

@end

@implementation KSMemoryCacheArrayPerformenceTexts

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    memoryCacheArrayAddObject = [KSMemoryCacheArray new];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    NSMutableArray *mutableArray = [NSMutableArray new];
    KSMemoryCacheArray *memoryCacheArrayAddObject = [KSMemoryCacheArray new];
    KSMemoryCacheArray *memoryCacheArraySetObject = [KSMemoryCacheArray new];
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        int count = 20000;
        for (int i = 0; i < count; i++) {
            NSData *value = [NSData dataWithBytes:&i length:sizeof(int)];
            [mutableArray addObject:value];
        }
    }];
//
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//        int count = 200000;
//        for (int i = 0; i < count; i++) {
//            [mutableArray objectAtIndex:i];
//        }
//    }];
//    
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//        int count = 200000;
//        for (int i = 0; i < count; i++) {
//            [memoryCacheArrayAddObject objectAtIndex:i];
//        }
//    }];
//    
//    [self measureBlock:^{
//        // Put the code you want to measure the time of here.
//        int count = 200000;
//        for (int i = 0; i < count; i++) {
//            [memoryCacheArraySetObject objectAtIndex:i];
//        }
//    }];
}

- (void)testPerformanceExampleAddObject {
    // This is an example of a performance test case.
    memoryCacheArrayAddObject = [KSMemoryCacheArray new];
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        int count = 20000;
        for (int i = 0; i < count; i++) {
            NSData *value = [NSData dataWithBytes:&i length:sizeof(int)];
            [memoryCacheArrayAddObject addObject:value];
        }
    }];
}

- (void)testPerformanceExampleSetObject {
    // This is an example of a performance test case.
    KSMemoryCacheArray *memoryCacheArraySetObject = [KSMemoryCacheArray new];
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        int count = 20000;
        for (int i = 0; i < count; i++) {
            NSData *value = [NSData dataWithBytes:&i length:sizeof(int)];
            [memoryCacheArraySetObject setObject:value forKeyedSubscript:@(i)];
        }
    }];

}

- (void)testPerformanceExampleAddObjects {
    // This is an example of a performance test case.
    NSMutableArray *mutableArray = [NSMutableArray new];

    int count = 20000;
    for (int i = 0; i < count; i++) {
        [mutableArray addObject:@(i)];
    }
    // Put the code you want to measure the time of here.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        __block NSNumber* number = nil;
        [memoryCacheArrayAddObject addObjectsFromArray:mutableArray withBlock:^{
            number = [memoryCacheArrayAddObject objectAtIndex:0];
            number = [memoryCacheArrayAddObject objectAtIndex:2];
        }];
    }];
    

}

- (void)testPerformanceExampleAddObjectObjectForKey {
    // This is an example of a performance test case.
    int count = 200000;
    for (int i = 0; i < count; i++) {
        NSData *value = [NSData dataWithBytes:&i length:sizeof(int)];
        [memoryCacheArrayAddObject addObject:value];
    }
    [memoryCacheArrayAddObject insertObject:@(200001) atIndex:0];
    [memoryCacheArrayAddObject insertObject:@(200002) atIndex:9];

    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        int count = 200002;
        for (int i = 0; i < count; i++) {
            [memoryCacheArrayAddObject objectAtIndex:i withBlock:^(NSString *key, id<NSCoding> object) {
                
            }];
        }

    }];
    
    NSNumber* number = [memoryCacheArrayAddObject objectAtIndex:0];
    number = [memoryCacheArrayAddObject objectAtIndex:9];
}

- (void)testPerformanceExampleAddObjectRemoveObjectForKey {
    // This is an example of a performance test case.
    int count = 200000;
    for (int i = 0; i < count; i++) {
        [memoryCacheArrayAddObject addObject:@(i)];
    }
    [memoryCacheArrayAddObject insertObject:@(200001) atIndex:0];
    [memoryCacheArrayAddObject insertObject:@(200002) atIndex:9];
    
    NSNumber* number = [memoryCacheArrayAddObject objectAtIndex:0];
    number = [memoryCacheArrayAddObject objectAtIndex:9];
    
    [memoryCacheArrayAddObject removeObjectAtIndex:0];
    [memoryCacheArrayAddObject removeObjectAtIndex:9];
    
    number = [memoryCacheArrayAddObject objectAtIndex:0];
    number = [memoryCacheArrayAddObject objectAtIndex:9];
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        int count = 200000;
        for (int i = 0; i < count; i++) {
            [memoryCacheArrayAddObject removeObjectAtIndex:0];
        }
    }];
}

- (void)testPerformanceExampleObjectForKey {
    // This is an example of a performance test case.
    NSMutableArray *mutableArray = [NSMutableArray new];
    int count = 200000;
    for (int i = 0; i < count; i++) {
        NSData *value = [NSData dataWithBytes:&i length:sizeof(int)];
        [mutableArray addObject:value];
    }
    
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        int count = 200000;
        for (int i = 0; i < count; i++) {
            [mutableArray objectAtIndex:i];
        }
        
    }];
}

@end
