//
//  SRWXManager.h
//  SRThirdSocialPlatformDemo
//
//  Created by 郭伟林 on 16/9/14.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRThirdSocialManager.h"

// 微信 SDK 依赖的系统库
// SystemConfiguration.framework
// libz.dylib
// libsqlite3.0.dylib
// libc++.dylib
// CoreTelephony.framework

typedef void (^GetCodeCompletionBlock)(NSError *error, NSString *code);

@interface SRWXManager : NSObject

+ (void)registerApp;

+ (BOOL)isAppInstalled;

+ (void)installApp;

+ (BOOL)handleOpenURL:(NSURL *)aURL;

+ (void)authRequestSuccess:(SRThirdSocialAuthSuccess)success failure:(SRThirdSocialAuthFailure)failure;

+ (void)loginRequestSuccess:(SRThirdSocialLoginSuccess)success failure:(SRThirdSocialLoginFailure)failure;

+ (void)getCodeCompletion:(GetCodeCompletionBlock)completion;

@end
