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

typedef NS_OPTIONS (NSInteger, SRThirdSocialType) {
    SRThirdSocialWX = 1 << 0,
    SRThirdSocialWB = 1 << 1,
    SRThirdSocialQQ = 1 << 2,
};

typedef void (^SRAuthSuccess)(NSString *openID, NSString *unionID);
typedef void (^SRAuthError)(NSError *error);

typedef void (^SRLoginSuccess)(NSString *openID, NSString *unionID, NSString *userNickname, NSString *userAvatarURL);
typedef void (^SRLoginError)(NSError *error);

@interface SRThirdSocialManager : NSObject

+ (void)registerApp;

+ (BOOL)isAppInstalled:(SRThirdSocialType)thirdSocialType;

+ (BOOL)handleOpenURL:(NSURL *)url;

+ (void)authRequest:(SRThirdSocialType)thirdSocialType
        authSuccess:(SRAuthSuccess)authSuccess
          authError:(SRAuthError)authError;

+ (void)loginRequest:(SRThirdSocialType)thirdSocialType
        loginSuccess:(SRLoginSuccess)loginSuccess
          loginError:(SRLoginError)loginError;

@end
