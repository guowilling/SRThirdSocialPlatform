//
//  SRQQManager.h
//  SRThirdSocialPlatformDemo
//
//  Created by 郭伟林 on 16/9/14.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRAuthManager.h"

// **SDK依赖的系统库**
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

+ (BOOL)handleOpenURL:(NSURL *)url;

+ (void)authRequestWithAuthSuccess:(SRAuthSuccess)authSuccess authError:(SRAuthError)authError;

+ (void)loginRequestWithLoginSuccess:(SRLoginSuccess)loginSuccess loginError:(SRLoginError)loginError;

@end
