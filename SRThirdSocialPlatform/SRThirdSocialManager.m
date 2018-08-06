//
//  SRThirdSocialManager.m
//  SRThirdSocialPlatformDemo
//
//  Created by 郭伟林 on 16/9/14.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRThirdSocialManager.h"
#import "SRWXManager.h"
#import "SRWBManager.h"
#import "SRQQManager.h"

@implementation SRThirdSocialManager

+ (void)registerApp {
    [SRWXManager registerApp];
    [SRWBManager registerApp];
}

+ (BOOL)isAppInstalled:(SRThirdSocialType)thirdSocialType {
    BOOL result = NO;
    switch (thirdSocialType) {
        case SRThirdSocialWX:
        {
            result = [SRWXManager isAppInstalled];
            break;
        }
        case SRThirdSocialWB:
        {
            result = [SRWXManager isAppInstalled];
            break;
        }
        case SRThirdSocialQQ:
        {
            result = [SRQQManager isAppInstalled];
            break;
        }
    }
    return result;
}

+ (void)installeAPP:(SRThirdSocialType)thirdSocialType {
    switch (thirdSocialType) {
        case SRThirdSocialWX:
        {
            [SRWXManager installApp];
            break;
        }
        case SRThirdSocialWB:
        {
            [SRWBManager installApp];
            break;
        }
        case SRThirdSocialQQ:
        {
            [SRQQManager installApp];
            break;
        }
    }
}

+ (BOOL)handleOpenURL:(NSURL *)aURL {
    if ([SRWXManager handleOpenURL:aURL]) {
        return YES;
    }
    if ([SRWBManager handleOpenURL:aURL]) {
        return YES;
    }
    if ([SRQQManager handleOpenURL:aURL]) {
        return YES;
    }
    return NO;
}

+ (void)authRequest:(SRThirdSocialType)type success:(SRThirdSocialAuthSuccess)success failure:(SRThirdSocialAuthFailure)failure {
    switch (type) {
        case SRThirdSocialWX:
        {
            [SRWXManager authRequestSuccess:success failure:failure];
            break;
        }
        case SRThirdSocialWB:
        {
            [SRWBManager authRequestSuccess:success failure:failure];
            break;
        }
        case SRThirdSocialQQ:
        {
            [SRQQManager authRequestSuccess:success failure:failure];
            break;
        }
    }
}

+ (void)loginRequest:(SRThirdSocialType)type success:(SRThirdSocialLoginSuccess)success failure:(SRThirdSocialLoginFailure)failure {
    switch (type) {
        case SRThirdSocialWX:
        {
            [SRWXManager loginRequestSuccess:success failure:failure];
            break;
        }
        case SRThirdSocialWB:
        {
            [SRWBManager loginRequestSuccess:success failure:failure];
            break;
        }
        case SRThirdSocialQQ:
        {
            [SRQQManager loginRequestSuccess:success failure:failure];
            break;
        }
    }
}

@end
