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

@interface SRWXManager : NSObject

+ (void)registerApp;

+ (BOOL)isAppInstalled;

+ (BOOL)handleOpenURL:(NSURL *)url;

+ (void)authRequestWithAuthSuccess:(SRThirdSocialAuthSuccess)authSuccess authError:(SRThirdSocialAuthError)authError;

+ (void)loginRequestWithLoginSuccess:(SRThirdSocialLoginSuccess)loginSuccess loginError:(SRThirdSocialLoginError)loginError;

@end
