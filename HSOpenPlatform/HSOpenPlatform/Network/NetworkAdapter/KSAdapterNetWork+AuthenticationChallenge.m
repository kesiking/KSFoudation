//
//  KSAdapterNetWork+AuthenticationChallenge.m
//  HSOpenPlatform
//
//  Created by xtq on 16/3/20.
//  Copyright © 2016年 孟希羲. All rights reserved.
//

#import "KSAdapterNetWork+AuthenticationChallenge.h"

@implementation KSAdapterNetWork (AuthenticationChallenge)

- (void (^)(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge))getAuthenticationChallengeBlock {
    
    __weak typeof(self.securityPolicy) weakSecurityPolicy = self.securityPolicy;

    return ^void (NSURLConnection *connection, NSURLAuthenticationChallenge *challenge) {
        NSLog(@"challenge.protectionSpace.authenticationMethod = %@",challenge.protectionSpace.authenticationMethod);
        //通过自定义验证策略验证服务器证书
        if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
            if ([weakSecurityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
            } else {
                [[challenge sender] cancelAuthenticationChallenge:challenge];
            }
        } else {    //验证客户端证书
            if ([challenge previousFailureCount] == 0) {
                NSString *thePath       = [[NSBundle mainBundle] pathForResource:@"client" ofType:@"p12"];
                NSData *PKCS12Data      = [[NSData alloc] initWithContentsOfFile:thePath];
                CFDataRef inPKCS12Data  = (__bridge CFDataRef)PKCS12Data;
                SecIdentityRef identity = NULL;
                
                [self extractIdentity :inPKCS12Data identity:&identity];
                
                SecCertificateRef certificate = NULL;
                SecIdentityCopyCertificate (identity, &certificate);
                const void *certs[] = {certificate};
                CFArrayRef certsArray = CFArrayCreate(kCFAllocatorDefault, certs, 1, NULL);
                NSURLCredential *credential = [NSURLCredential credentialWithIdentity:identity certificates:(__bridge NSArray*)certsArray persistence:NSURLCredentialPersistencePermanent];
                [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
            } else {
                [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
            }
        }
    };
}

- (OSStatus)extractIdentity:(CFDataRef)inP12Data identity:(SecIdentityRef*)identity {
    OSStatus securityError   = errSecSuccess;
    CFStringRef password     = CFSTR("gsfop456");
    const void *keys[]       = { kSecImportExportPassphrase };
    const void *values[]     = { password };
    CFDictionaryRef options  = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    CFArrayRef items         = CFArrayCreate(NULL, 0, 0, NULL);
    securityError            = SecPKCS12Import(inP12Data, options, &items);
    
    if (securityError == 0) {
        CFDictionaryRef ident    = CFArrayGetValueAtIndex(items,0);
        const void *tempIdentity = NULL;
        tempIdentity             = CFDictionaryGetValue(ident, kSecImportItemIdentity);
        *identity                = (SecIdentityRef)tempIdentity;
    }
    if (options) {
        CFRelease(options);
    }
    
    return securityError;
}


@end
