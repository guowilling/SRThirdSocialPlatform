//
//  SRWeiboManager.m
//  SRThirdSocialPlatformDemo
//
//  Created by 郭伟林 on 16/9/14.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRWeiboManager.h"
#import "WeiboSDK.h"
#import "WeiboUser.h"

@interface SRWeiboManager () <WeiboSDKDelegate>

@property (nonatomic, copy) SRAuthSuccess  authSuccess;
@property (nonatomic, copy) SRAuthError    authError;
@property (nonatomic, copy) SRLoginSuccess loginSuccess;
@property (nonatomic, copy) SRLoginError   loginError;

@end

@implementation SRWeiboManager

+ (void)registerApp {
    
    if ([WeiboSDK registerApp:WB_APPKEY]) {
        NSLog(@"Register Weibo success.");
    }
}

+ (BOOL)isAppInstalled {
    
    return ([WeiboSDK isWeiboAppInstalled] && [WeiboSDK isCanSSOInWeiboApp]);
}

+ (BOOL)handleOpenURL:(NSURL *)url {
    
    return [WeiboSDK handleOpenURL:url delegate:[SRWeiboManager manager]];
}

+ (instancetype)manager {
    
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SRWeiboManager alloc] init];
    });
    return manager;
}

+ (void)authRequestWithAuthSuccess:(SRAuthSuccess)authSuccess authError:(SRAuthError)authError {
    
    SRWeiboManager *manager = [SRWeiboManager manager];
    manager.authSuccess = authSuccess;
    manager.authError = authError;
    manager.loginSuccess = nil;
    manager.loginError = nil;
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = WB_RedirectURL;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

+ (void)loginRequestWithLoginSuccess:(SRLoginSuccess)loginSuccess loginError:(SRLoginError)loginError {
    
    SRWeiboManager *manager = [SRWeiboManager manager];
    manager.authSuccess = nil;
    manager.authError = nil;
    manager.loginSuccess = loginSuccess;
    manager.loginError = loginError;
    
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = WB_RedirectURL;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

#pragma mark - WeiboSDKDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    
    if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            WBAuthorizeResponse *resp = (WBAuthorizeResponse *)response;
            if (self.authSuccess) {
                self.authSuccess(resp.userID, nil);
            }
            [self loginRequest:resp];
        } else {
            if (self.authError) {
                if (response.statusCode == WeiboSDKResponseStatusCodeAuthDeny) {
                    self.authError([NSError errorWithDomain:@"用户拒绝微博授权" code:response.statusCode userInfo:nil]);
                } else if (response.statusCode == WeiboSDKResponseStatusCodeUserCancel) {
                    self.authError([NSError errorWithDomain:@"用户取消微博授权" code:response.statusCode userInfo:nil]);
                } else {
                    self.authError([NSError errorWithDomain:@"微博授权失败" code:response.statusCode userInfo:nil]);
                }
            }
        }
    }
}

- (void)loginRequest:(WBAuthorizeResponse *)resp {
    
    [WBHttpRequest requestForUserProfile:resp.userID
                         withAccessToken:resp.accessToken
                      andOtherProperties:nil
                                   queue:nil
                   withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
                       if (!error) {
                           WeiboUser *userInfo = (WeiboUser *)result;
                           NSString *userID = userInfo.userID;
                           NSString *nickname = userInfo.name;
                           NSString *avatarURL = userInfo.avatarLargeUrl;
                           if (self.loginSuccess) {
                               self.loginSuccess(userID, nil, nickname, avatarURL);
                           }
                       } else {
                           if (self.loginError) {
                               self.loginError(error);
                           }
                       }
                   }];
}

@end
