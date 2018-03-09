//
//  SRQQManager.h
//  SRThirdSocialPlatformDemo
//
//  Created by 郭伟林 on 16/9/14.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRThirdSocialManager.h"

// QQ SDK 依赖的系统库
// Security.framework
// libiconv.dylib
// SystemConfiguration.framework
// CoreGraphics.Framework
// libsqlite3.dylib
// CoreTelephony.framework
// libstdc++.dylib
// libz.dylib

typedef void (^GetTokenAndOpenIDCompletionBlock)(NSError *error, NSString *token, NSString *openID);

@interface SRQQManager : NSObject

+ (BOOL)isAppInstalled;

+ (void)installApp;

+ (BOOL)handleOpenURL:(NSURL *)aURL;

+ (void)authRequestWithAuthSuccess:(SRThirdSocialAuthSuccess)authSuccess authError:(SRThirdSocialAuthError)authError;

+ (void)loginRequestWithLoginSuccess:(SRThirdSocialLoginSuccess)loginSuccess loginError:(SRThirdSocialLoginError)loginError;

+ (void)getTokenAndOpenIDCompletion:(GetTokenAndOpenIDCompletionBlock)completion;

@end
