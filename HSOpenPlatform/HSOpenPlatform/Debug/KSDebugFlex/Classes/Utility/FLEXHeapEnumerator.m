//
//  FLEXHeapEnumerator.m
//  Flipboard
//
//  Created by Ryan Olson on 5/28/14.
//  Copyright (c) 2014 Flipboard. All rights reserved.
//

#import "FLEXHeapEnumerator.h"
#import <malloc/malloc.h>
#import <mach/mach.h>
#import <objc/runtime.h>

static CFMutableSetRef registeredClasses;

// Mimics the objective-c object stucture for checking if a range of memory is an object.
typedef struct {
    Class isa;
} flex_maybe_object_t;

@implementation FLEXHeapEnumerator

static inline kern_return_t memory_reader(task_t task, vm_address_t remote_address, vm_size_t size, void **local_memory)
{
    *local_memory = (void *)remote_address;
    return KERN_SUCCESS;
}

static void range_callback(task_t task, void *context, unsigned type, vm_range_t *ranges, unsigned rangeCount)
{
    flex_object_enumeration_block_t block = (__bridge flex_object_enumeration_block_t)context;
    if (!block) {
        return;
    }
    
    for (unsigned int i = 0; i < rangeCount; i++) {
        vm_range_t range = ranges[i];
        flex_maybe_object_t *tryObject = (flex_maybe_object_t *)range.address;
        Class tryClass = NULL;
#ifdef __arm64__
        // See http://www.sealiesoftware.com/blog/archive/2013/09/24/objc_explain_Non-pointer_isa.html
        extern uint64_t objc_debug_isa_class_mask WEAK_IMPORT_ATTRIBUTE;
        tryClass = (__bridge Class)((void *)((uint64_t)tryObject->isa & objc_debug_isa_class_mask));
#else
        tryClass = tryObject->isa;
#endif
        // If the class pointer matches one in our set of class pointers from the runtime, then we should have an object.
        if (tryClass && CFSetContainsValue(registeredClasses, (__bridge const void *)(tryClass))) {
            block((__bridge id)tryObject, tryClass);
        }
    }
}

+ (void)enumerateLiveObjectsUsingBlock:(flex_object_enumeration_block_t)block
{
    if (!block) {
        return;
    }
    
    // Refresh the class list on every call in case classes are added to the runtime.
    [self updateRegisteredClasses];
    
    // Inspired by:
    // http://llvm.org/svn/llvm-project/lldb/tags/RELEASE_34/final/examples/darwin/heap_find/heap/heap_find.cpp
    // https://gist.github.com/samdmarshall/17f4e66b5e2e579fd396
    
    vm_address_t *zones = NULL;
    unsigned int zoneCount = 0;
    kern_return_t result = malloc_get_all_zones(TASK_NULL, NULL, &zones, &zoneCount);
    
    if (result == KERN_SUCCESS) {
        for (unsigned int i = 0; i < zoneCount; i++) {
            malloc_zone_t *zone = (malloc_zone_t *)zones[i];
            if (zone->introspect && zone->introspect->enumerator) {
                zone->introspect->enumerator(mach_task_self(), (__bridge void *)block, MALLOC_PTR_IN_USE_RANGE_TYPE, (vm_address_t)zone, memory_reader, range_callback);
            }
        }
    }
}

+ (void)updateRegisteredClasses
{
    if (!registeredClasses) {
        registeredClasses = CFSetCreateMutable(NULL, 0, NULL);
    } else {
        CFSetRemoveAllValues(registeredClasses);
    }
    unsigned int count = 0;
    Class *classes = objc_copyClassList(&count);
    for (unsigned int i = 0; i < count; i++) {
        CFStringRef className = CFStringCreateWithCString(NULL, (class_getName(classes[i])), kCFStringEncodingUTF8);
        if (className && ![self _FLEXClassNameIsKnownUnsafeClass:(__bridge NSString *)className] && [(__bridge NSString *)className characterAtIndex:0] != '_') {
            CFSetAddValue(registeredClasses, (__bridge const void *)(classes[i]));
        }
    }
    free(classes);
}

+(BOOL)_FLEXClassNameIsKnownUnsafeClass:(NSString*)className {
    if (className == nil) {
        return NO;
    }
    if ([@"_NSZombie_" isEqualToString:className]) return YES;
    if ([@"__ARCLite__" isEqualToString:className]) return YES;
    if ([@"__NSCFCalendar" isEqualToString:className]) return YES;
    if ([@"__NSCFTimer" isEqualToString:className]) return YES;
    if ([@"NSCFTimer" isEqualToString:className]) return YES;
    if ([@"__NSMessageBuilder" isEqualToString:className]) return YES;
    if ([@"__NSGenericDeallocHandler" isEqualToString:className]) return YES;
    if ([@"NSAutoreleasePool" isEqualToString:className]) return YES;
    if ([@"NSPlaceholderNumber" isEqualToString:className]) return YES;
    if ([@"NSPlaceholderString" isEqualToString:className]) return YES;
    if ([@"NSPlaceholderValue" isEqualToString:className]) return YES;
    if ([@"Object" isEqualToString:className]) return YES;
    if ([@"NSPlaceholderNumber" isEqualToString:className]) return YES;
    if ([@"VMUArchitecture" isEqualToString:className]) return YES;
    if ([className hasPrefix:@"__NSPlaceholder"]) return YES;
    if ([className hasPrefix:@"_NSZombie_"]) return YES;
    
    return NO;
}

@end