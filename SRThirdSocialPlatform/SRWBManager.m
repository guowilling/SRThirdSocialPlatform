//
//  SRWBManager.m
//  SRThirdSocialPlatformDemo
//
//  Created by 郭伟林 on 16/9/14.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRWBManager.h"
#import "WeiboSDK.h"
#import "WeiboUser.h"

@interface SRWBManager () <WeiboSDKDelegate>

@property (nonatomic, copy) SRThirdSocialAuthSuccess authSuccess;
@property (nonatomic, copy) SRThirdSocialAuthError   authError;

@property (nonatomic, copy) SRThirdSocialLoginSuccess loginSuccess;
@property (nonatomic, copy) SRThirdSocialLoginError   loginError;

@property (nonatomic, copy) GetTokenAndOpenIDCompletionBlock getTokenAndOpenIDCompletionBlock;

@end

@implementation SRWBManager

+ (void)registerApp {
    if ([WeiboSDK registerApp:WB_APPKEY]) {
        NSLog(@"Register Weibo success");
    }
}

+ (BOOL)isAppInstalled {
    return ([WeiboSDK isWeiboAppInstalled] && [WeiboSDK isCanSSOInWeiboApp]);
}

+ (void)installApp {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[WeiboSDK getWeiboAppInstallUrl]]];
}

+ (BOOL)handleOpenURL:(NSURL *)aURL {
    return [WeiboSDK handleOpenURL:aURL delegate:[SRWBManager manager]];
}

+ (instancetype)manager {
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SRWBManager alloc] init];
    });
    return manager;
}

+ (void)authRequestWithAuthSuccess:(SRThirdSocialAuthSuccess)authSuccess authError:(SRThirdSocialAuthError)authError {
    SRWBManager *manager = [SRWBManager manager];
    manager.authSuccess = authSuccess;
    manager.authError = authError;
    manager.loginSuccess = nil;
    manager.loginError = nil;
    manager.getTokenAndOpenIDCompletionBlock = nil;
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = WB_RedirectURI;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

+ (void)loginRequestWithLoginSuccess:(SRThirdSocialLoginSuccess)loginSuccess loginError:(SRThirdSocialLoginError)loginError {
    SRWBManager *manager = [SRWBManager manager];
    manager.authSuccess = nil;
    manager.authError = nil;
    manager.loginSuccess = loginSuccess;
    manager.loginError = loginError;
    manager.getTokenAndOpenIDCompletionBlock = nil;
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = WB_RedirectURI;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

+ (void)getTokenAndOpenIDCompletion:(GetTokenAndOpenIDCompletionBlock)completion {
    SRWBManager *manager = [SRWBManager manager];
    manager.authSuccess = nil;
    manager.authError = nil;
    manager.loginSuccess = nil;
    manager.loginError = nil;
    manager.getTokenAndOpenIDCompletionBlock = completion;
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = WB_RedirectURI;
    request.scope = @"all";
    [WeiboSDK sendRequest:request];
}

#pragma mark - WeiboSDKDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request { }

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    if ([response isKindOfClass:WBAuthorizeResponse.class]) {
        if (response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            WBAuthorizeResponse *resp = (WBAuthorizeResponse *)response;
            if (self.getTokenAndOpenIDCompletionBlock) {
                self.getTokenAndOpenIDCompletionBlock(nil, resp.accessToken, resp.userID);
            }
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
