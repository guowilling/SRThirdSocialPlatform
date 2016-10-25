//
//  SRQQManager.m
//  SRThirdSocialPlatformDemo
//
//  Created by 郭伟林 on 16/9/14.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRQQManager.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface SRQQManager () <TencentSessionDelegate, QQApiInterfaceDelegate>

@property (nonatomic, strong) TencentOAuth *tencentOAuth;

@property (nonatomic, copy) SRThirdSocialAuthSuccess   authSuccess;
@property (nonatomic, copy) SRThirdSocialAuthError     authError;

@property (nonatomic, copy) SRThirdSocialLoginSuccess  loginSuccess;
@property (nonatomic, copy) SRThirdSocialLoginError    loginError;

@end

@implementation SRQQManager

+ (instancetype)manager {
    
    static id QQManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        QQManager = [[SRQQManager alloc] init];
    });
    return QQManager;
}

- (id)init {
    
    if (self = [super init]) {
        _tencentOAuth = [[TencentOAuth alloc] initWithAppId:QQ_APPID andDelegate:self];
    }
    return self;
}

+ (BOOL)isAppInstalled {
    
    if ([TencentOAuth iphoneQQInstalled] && [TencentOAuth iphoneQQSupportSSOLogin]) {
        return YES;
    }
    return NO;
}

+ (BOOL)handleOpenURL:(NSURL *)url {
    
    if ([QQApiInterface handleOpenURL:url delegate:[SRQQManager manager]]) {
        return YES;
    }
    return [TencentOAuth HandleOpenURL:url];
}

+ (void)authRequestWithAuthSuccess:(SRThirdSocialAuthSuccess)authSuccess authError:(SRThirdSocialAuthError)authError {
    
    SRQQManager *manager = [SRQQManager manager];
    manager.authSuccess = authSuccess;
    manager.authError = authError;
    manager.loginSuccess = nil;
    manager.loginError = nil;
    [manager.tencentOAuth authorize:@[kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]];
}

+ (void)loginRequestWithLoginSuccess:(SRThirdSocialLoginSuccess)loginSuccess loginError:(SRThirdSocialLoginError)loginError {
    
    SRQQManager *manager = [SRQQManager manager];
    manager.authSuccess = nil;
    manager.authError = nil;
    manager.loginSuccess = loginSuccess;
    manager.loginError = loginError;
    [manager.tencentOAuth authorize:@[kOPEN_PERMISSION_GET_SIMPLE_USER_INFO]];
}

#pragma mark - TencentLoginDelegate

- (void)tencentDidLogin {
    
    if (self.tencentOAuth.accessToken && self.tencentOAuth.accessToken.length > 0) {
        if (self.authSuccess) {
            self.authSuccess(self.tencentOAuth.openId, nil);
        }
        [self.tencentOAuth getUserInfo];
    } else {
        if (self.authError) {
            self.authError([NSError errorWithDomain:@"QQ登录失败" code:-1 userInfo:nil]);
        }
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    
    if (cancelled) {
        if (self.authError) {
            self.authError([NSError errorWithDomain:@"用户取消QQ登录" code:-1 userInfo:nil]);
        }
    } else {
        if (self.authError) {
            self.authError([NSError errorWithDomain:@"QQ登录失败" code:-1 userInfo:nil]);
        }
    }
}

- (void)tencentDidNotNetWork {
    
    if (self.authError) {
        self.authError([NSError errorWithDomain:@"QQ登录网络错误" code:-1 userInfo:nil]);
    }
}

- (void)getUserInfoResponse:(APIResponse *)response {
    
    if (response.retCode == URLREQUEST_SUCCEED) {
        NSString *nickname  = response.jsonResponse[@"nickname"];
        NSString *avatarURL = response.jsonResponse[@"figureurl_qq_2"];
        if (self.loginSuccess) {
            self.loginSuccess(self.tencentOAuth.openId, nil, nickname, avatarURL);
        }
    } else {
        if (self.loginError) {
            self.loginError([NSError errorWithDomain:@"QQ登录异常" code:-1 userInfo:nil]);
        }
    }
}

#pragma mark - QQApiInterfaceDelegate

- (void)onReq:(QQBaseReq *)req { }

- (void)onResp:(QQBaseResp *)resp { }

- (void)isOnlineResponse:(NSDictionary *)response { }

@end
