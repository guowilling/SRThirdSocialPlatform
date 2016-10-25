//
//  SRAuthManager.h
//  SRThirdSocialPlatformDemo
//
//  Created by 郭伟林 on 16/9/14.
//  Copyright © 2016年 SR. All rights reserved.
//

/**
 *  If you have any question, please issue or contact me.
 *  QQ: 396658379
 *  Email: guowilling@qq.com
 *
 *  If you like it, please star it, thanks a lot.
 *  Github: https://github.com/guowilling/SRThirdSocialPlatform
 *
 *  Have Fun.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  更改成你们在第三方平台申请的 APP 信息
 */

#define WX_APPKEY        @"wx537feebd640931cc"
#define WX_SECRET        @"f1e54b2d0da8ea5ac5bcb6a8c7a8cf79"

#define WB_APPKEY        @"891974957"
#define WB_RedirectURL   @"http://www.arhieason.com/"

#define QQ_APPID         @"1104784464"

typedef NS_OPTIONS (NSInteger, SRAuthType) {
    SRAuthTypeWeixin = 1 << 0,
    SRAuthTypeWeibo  = 1 << 1,
    SRAuthTypeQQ     = 1 << 2,
};

typedef void (^SRAuthSuccess)(NSString *openID, NSString *unionID);
typedef void (^SRAuthError)(NSError *error);

typedef void (^SRLoginSuccess)(NSString *openID, NSString *unionID, NSString *userNickname, NSString *userAvatarURL);
typedef void (^SRLoginError)(NSError *error);

@interface SRAuthManager : NSObject

+ (void)registerApp;

+ (BOOL)isAppInstalled:(SRAuthType)authType;

+ (BOOL)handleOpenURL:(NSURL *)url;

+ (void)authRequest:(SRAuthType)authType authSuccess:(SRAuthSuccess)authSuccess authError:(SRAuthError)authError;

+ (void)loginRequest:(SRAuthType)authType loginSuccess:(SRLoginSuccess)loginSuccess loginError:(SRLoginError)loginError;

@end
