//
//  SRWXManager.m
//  SRThirdSocialPlatformDemo
//
//  Created by 郭伟林 on 16/9/14.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "SRWXManager.h"
#import "WXApiObject.h"
#import "WXApi.h"

@interface SRWXManager () <WXApiDelegate>

@property (nonatomic, copy) SRThirdSocialAuthSuccess  authSuccess;
@property (nonatomic, copy) SRThirdSocialAuthError    authError;

@property (nonatomic, copy) SRThirdSocialLoginSuccess loginSuccess;
@property (nonatomic, copy) SRThirdSocialLoginError   loginError;

@end

@implementation SRWXManager

+ (void)registerApp {
    
    if ([WXApi registerApp:WX_APPKEY]) {
        NSLog(@"Register Weixin success.");
    }
}

+ (BOOL)isAppInstalled {
    
    return [WXApi isWXAppInstalled];
}

+ (BOOL)handleOpenURL:(NSURL *)url {
    
    return [WXApi handleOpenURL:url delegate:[SRWXManager manager]];
}

+ (instancetype)manager {
    
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SRWXManager alloc] init];
    });
    return manager;
}

+ (void)authRequestWithAuthSuccess:(SRThirdSocialAuthSuccess)authSuccess authError:(SRThirdSocialAuthError)authError {
    
    SRWXManager *manager = [SRWXManager manager];
    manager.authSuccess = authSuccess;
    manager.authError = authError;
    manager.loginSuccess = nil;
    manager.loginError = nil;
    
    SendAuthReq *sendAuthReq = [[SendAuthReq alloc] init];
    sendAuthReq.scope = @"snsapi_userinfo";
    sendAuthReq.state = @"413e6ad8cae81487d315780b0a6717c0";
    [WXApi sendAuthReq:sendAuthReq viewController:nil delegate:[SRWXManager manager]];
}

+ (void)loginRequestWithLoginSuccess:(SRThirdSocialLoginSuccess)loginSuccess loginError:(SRThirdSocialLoginError)loginError {
    
    SRWXManager *manager = [SRWXManager manager];
    manager.authSuccess = nil;
    manager.authError = nil;
    manager.loginSuccess = loginSuccess;
    manager.loginError = loginError;
    
    SendAuthReq *sendAuthReq = [[SendAuthReq alloc] init];
    sendAuthReq.scope = @"snsapi_userinfo";
    sendAuthReq.state = @"413e6ad8cae81487d315780b0a6717c0";
    [WXApi sendAuthReq:sendAuthReq viewController:nil delegate:[SRWXManager manager]];
}

#pragma mark - WXApiDelegate

- (void)onReq:(BaseReq *)req { }

- (void)onResp:(BaseResp *)resp {
    
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        if (resp.errCode == WXSuccess) {
            SendAuthResp *authResp = (SendAuthResp *)resp;
            [self getOpenIDWithCode:authResp.code];
        } else {
            if (self.authError) {
                if (resp.errCode == WXErrCodeAuthDeny) {
                    self.authError([NSError errorWithDomain:@"微信用户拒绝授权" code:resp.errCode userInfo:nil]);
                } else if (resp.errCode == WXErrCodeUserCancel) {
                    self.authError([NSError errorWithDomain:@"微信用户取消授权" code:resp.errCode userInfo:nil]);
                } else {
                    self.authError([NSError errorWithDomain:@"微信授权失败" code:resp.errCode userInfo:nil]);
                }
            }
        }
    }
}

- (void)getOpenIDWithCode:(NSString *)code {
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *URLStringHeader = @"https://api.weixin.qq.com/sns/oauth2/access_token";
    NSString *URLString = [NSString stringWithFormat:@"%@?appid=%@&secret=%@&code=%@&grant_type=authorization_code", URLStringHeader, WX_APPKEY, WX_SECRET, code];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:URLString]
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                if (error) {
                                                    if (self.authError) {
                                                        self.authError(error);
                                                        return;
                                                    }
                                                }
                                                NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                                                if ([self occurError:responseObject]) {
                                                    return;
                                                }
                                                [self loginWithOpenId:responseObject[@"openid"] token:responseObject[@"access_token"]];
                                            });
                                        }];
    [task resume];
}

- (void)loginWithOpenId:(NSString *)openID token:(NSString *)token {
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *URLStringHeader = @"https://api.weixin.qq.com/sns/userinfo";
    NSString *URLString = [NSString stringWithFormat:@"%@?access_token=%@&openid=%@", URLStringHeader, token, openID];
    NSURLSessionDataTask *task = [session dataTaskWithURL:[NSURL URLWithString:URLString]
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                if (error) {
                                                    if (self.authError) {
                                                        self.authError(error);
                                                        return;
                                                    }
                                                    if (self.loginError) {
                                                        self.loginError(error);
                                                        return;
                                                    }
                                                }
                                                NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                                                if ([self occurError:responseObject]) {
                                                    return;
                                                }
                                                NSString *openid = responseObject[@"openid"];
                                                NSString *unionid = responseObject[@"unionid"];
                                                NSString *nickname = responseObject[@"nickname"];
                                                NSString *avatarURL = responseObject[@"headimgurl"];
                                                if (self.authSuccess) {
                                                    self.authSuccess(openid, unionid);
                                                }
                                                if (self.loginSuccess) {
                                                    self.loginSuccess(openid, unionid, nickname, avatarURL);
                                                }
                                            });
                                        }];
    [task resume];
}

- (BOOL)occurError:(NSDictionary *)responseObject {
    
    if (responseObject[@"errcode"]) {
        NSString *errmsg = responseObject[@"errmsg"];
        NSInteger errcode = [responseObject[@"errcode"] integerValue];
        if (self.authError) {
            self.authError([NSError errorWithDomain:errmsg code:errcode userInfo:nil]);
        }
        return YES;
    }
    return NO;
}

@end
