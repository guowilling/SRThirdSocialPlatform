//
//  SRThirdSocialManager.h
//  SRThirdSocialPlatformDemo
//
//  Created by 郭伟林 on 16/9/14.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * 更改成你们在第三方平台申请的 APP 信息, 请不要将此 Demo 中提供的 APP 信息用于其他用途, 谢谢.
 * 注意: 本 Demo 中微博授权不能成功, 因为 Bundle Identifier 不一致导致, 实际使用时将项目 BID 和微博应用管理平台 BID 保持一致即可.
 */

#define WX_APPKEY      @"wx537feebd640931cc"
#define WX_SECRET      @"f1e54b2d0da8ea5ac5bcb6a8c7a8cf79"

#define WB_APPKEY      @"891974957"
#define WB_RedirectURI @"http://www.arhieason.com/"

#define QQ_APPID       @"1104784464"
#define QQ_APPKEY      @"2ejPhOgTmjIQqkDC"

typedef NS_OPTIONS (NSInteger, SRThirdSocialType) {
    SRThirdSocialWX = 1 << 0,
    SRThirdSocialWB = 1 << 1,
    SRThirdSocialQQ = 1 << 2,
};

typedef void (^SRThirdSocialAuthSuccess)(NSString *openID, NSString *unionID);
typedef void (^SRThirdSocialAuthError)(NSError *error);

typedef void (^SRThirdSocialLoginSuccess)(NSString *openID, NSString *unionID, NSString *userNickname, NSString *userAvatarURL);
typedef void (^SRThirdSocialLoginError)(NSError *error);

@interface SRThirdSocialManager : NSObject

+ (void)registerApp;

+ (BOOL)isAppInstalled:(SRThirdSocialType)thirdSocialType;

+ (void)installeAPP:(SRThirdSocialType)thirdSocialType;

+ (BOOL)handleOpenURL:(NSURL *)aURL;

+ (void)authRequest:(SRThirdSocialType)thirdSocialType authSuccess:(SRThirdSocialAuthSuccess)authSuccess authError:(SRThirdSocialAuthError)authError;

+ (void)loginRequest:(SRThirdSocialType)thirdSocialType loginSuccess:(SRThirdSocialLoginSuccess)loginSuccess loginError:(SRThirdSocialLoginError)loginError;

@end
