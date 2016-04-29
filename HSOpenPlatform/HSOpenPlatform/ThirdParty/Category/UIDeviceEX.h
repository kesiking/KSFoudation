//
//  UIDeviceEX.h
//

#import <UIKit/UIKit.h>

NSUInteger DeviceSystemMajorVersion();

NSUInteger DeviceSystemMinorVersion();

@interface UIDevice (EX)

// 设备可用内存（单位：MB）
@property(nonatomic, assign, readonly) double availableMemory;
@property(nonatomic,assign,readonly) BOOL isRetinaScreen;
@property(nonatomic,assign,readonly) float screenScale;

/*
 * @method uniqueDeviceIdentifier
 * @description use this method when you need a unique identifier in one app.
 * It generates a hash from the MAC-address in combination with the bundle identifier
 * of your app.
 */

- (NSString *) uniqueDeviceIdentifier;

/*
 * @method uniqueGlobalDeviceIdentifier
 * @description use this method when you need a unique global identifier to track a device
 * with multiple apps. as example a advertising network will use this method to track the device
 * from different apps.
 * It generates a hash from the MAC-address only.
 */

- (NSString *) uniqueGlobalDeviceIdentifier;

@end
