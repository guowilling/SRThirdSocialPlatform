//
//  SRQQManager.h
//  SRThirdSocialPlatformDemo
//
//  Created by 郭伟林 on 16/9/14.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRThirdSocialManager.h"

// QQ SDK依赖的系统库
// Security.framework
// libiconv.dylib
// SystemConfiguration.framework
// CoreGraphics.Framework
// libsqlite3.dylib
// CoreTelephony.framework
// libstdc++.dylib
// libz.dylib

typedef void (^GetTokenAndOpenidComleteBlock)(NSError *error, NSString *token, NSString *openid);

@interface SRQQManager : NSObject

+ (BOOL)isAppInstalled;

+ (void)installApp;

+ (BOOL)handleOpenURL:(NSURL *)url;

+ (void)authRequestWithAuthSuccess:(SRThirdSocialAuthSuccess)authSuccess authError:(SRThirdSocialAuthError)authError;

+ (void)loginRequestWithLoginSuccess:(SRThirdSocialLoginSuccess)loginSuccess loginError:(SRThirdSocialLoginError)loginError;

@end
