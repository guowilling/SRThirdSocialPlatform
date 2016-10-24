//
//  SRAuthManager.m
//  SRThirdSocialPlatformDemo
//
//  Created by 郭伟林 on 16/9/14.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRAuthManager.h"
#import "SRWeixinManager.h"
#import "SRWeiboManager.h"
#import "SRQQManager.h"

@implementation SRAuthManager

+ (void)registerApp {
    
    [SRWeixinManager registerApp];
    
    [SRWeiboManager registerApp];
}

+ (BOOL)isAppInstalled:(SRAuthType)authType {
    
    BOOL result = NO;
    
    switch (authType) {
        case SRAuthTypeWeixin: {
            result = [SRWeixinManager isAppInstalled];
            break;
        }
        case SRAuthTypeWeibo: {
            result = [SRWeiboManager isAppInstalled];
            break;
        }
        case SRAuthTypeQQ: {
            result = [SRQQManager isAppInstalled];
            break;
        }
    }
    return result;
}

+ (BOOL)handleOpenURL:(NSURL *)url {
    
    if ([SRWeixinManager handleOpenURL:url]) {
        return YES;
    }
    if ([SRWeiboManager handleOpenURL:url]) {
        return YES;
    }
    if ([SRQQManager handleOpenURL:url]) {
        return YES;
    }
    return NO;
}

+ (void)authRequest:(SRAuthType)authType authSuccess:(SRAuthSuccess)authSuccess authError:(SRAuthError)authError {
    
    switch (authType) {
        case SRAuthTypeWeixin: {
            [SRWeixinManager authRequestWithAuthSuccess:authSuccess authError:authError];
            break;
        }
        case SRAuthTypeWeibo: {
            [SRWeiboManager authRequestWithAuthSuccess:authSuccess authError:authError];
            break;
        }
        case SRAuthTypeQQ: {
            [SRQQManager authRequestWithAuthSuccess:authSuccess authError:authError];
            break;
        }
    }
}

+ (void)loginRequest:(SRAuthType)authType loginSuccess:(SRLoginSuccess)loginSuccess loginError:(SRLoginError)loginError {
    
    switch (authType) {
        case SRAuthTypeWeixin: {
            [SRWeixinManager loginRequestWithLoginSuccess:loginSuccess loginError:loginError];
            break;
        }
        case SRAuthTypeWeibo: {
            [SRWeiboManager loginRequestWithLoginSuccess:loginSuccess loginError:loginError];
            break;
        }
        case SRAuthTypeQQ: {
            [SRQQManager loginRequestWithLoginSuccess:loginSuccess loginError:loginError];
            break;
        }
    }
}

@end
