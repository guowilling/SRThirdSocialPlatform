//
//  SRWeixinManager.h
//  SRThirdSocialPlatformDemo
//
//  Created by 郭伟林 on 16/9/14.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRAuthManager.h"

// **SDK依赖的系统库**
// SystemConfiguration.framework
// libz.dylib
// libsqlite3.0.dylib
// libc++.dylib
// CoreTelephony.framework

@interface SRWeixinManager : NSObject

+ (void)registerApp;

+ (BOOL)isAppInstalled;

+ (BOOL)handleOpenURL:(NSURL *)url;

+ (void)authRequestWithAuthSuccess:(SRAuthSuccess)authSuccess authError:(SRAuthError)authError;

+ (void)loginRequestWithLoginSuccess:(SRLoginSuccess)loginSuccess loginError:(SRLoginError)loginError;

@end
