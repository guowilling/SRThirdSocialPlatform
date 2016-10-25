# SRThirdSocialPlatform

* **封装微信, 微博, QQ 第三方社交平台的登录授权功能, 通过 Block 的方式回调授权登录结果, 使用简单方便.**
* **实际项目开发中, 客户端只需拿到第三方平台的 code 或 token 即可, 所以可根据不同的业务需求, 自行修改代码.**

![image](./show01.jpg) ![image](./show02.jpg) ![image](./show03.jpg)    

![image](./1.依赖的系统类库.png)   

![image](./2.QueriesSchemes 设置.png)   

![image](./3.URL Types 设置.png)   

## Usage

````
/** Weixin */

// Auth
if ([SRAuthManager isAppInstalled:SRAuthTypeWeixin]) {
    [SRAuthManager authRequest:SRAuthTypeWeixin
                   authSuccess:^(NSString *openID, NSString *unionID) {
                       // Your code
                   } authError:^(NSError *error) {
                       // Your code
                   }];
}
    
// Login
if ([SRAuthManager isAppInstalled:SRAuthTypeWeixin]) {
    [SRAuthManager loginRequest:SRAuthTypeWeixin
                   loginSuccess:^(NSString *openID, NSString *unionID, NSString *userNickname, NSString *userAvatarURL) {
                       // Your code
                   } loginError:^(NSError *error) {
                       // Your code
                   }];
}
````

````
/** Weibo */

// Auth
if ([SRAuthManager isAppInstalled:SRAuthTypeWeixin]) {
    [SRAuthManager authRequest:SRAuthTypeWeibo
                   authSuccess:^(NSString *openID, NSString *unionID) {
                       // Your code
                   } authError:^(NSError *error) {
                       // Your code
                   }];
}
    
// Login
if ([SRAuthManager isAppInstalled:SRAuthTypeWeixin]) {
    [SRAuthManager loginRequest:SRAuthTypeWeibo
                   loginSuccess:^(NSString *openID, NSString *unionID, NSString *userNickname, NSString *userAvatarURL) {
                       // Your code
                   } loginError:^(NSError *error) {
                       // Your code
                   }];
}
````

````
/** QQ */

// Auth
if ([SRAuthManager isAppInstalled:SRAuthTypeWeixin]) {
    [SRAuthManager authRequest:SRAuthTypeQQ
                   authSuccess:^(NSString *openID, NSString *unionID) {
                       // Your code
                   } authError:^(NSError *error) {
                       // Your code
                   }];
}
    
// Login
if ([SRAuthManager isAppInstalled:SRAuthTypeWeixin]) {
    [SRAuthManager loginRequest:SRAuthTypeQQ
                   loginSuccess:^(NSString *openID, NSString *unionID, NSString *userNickname, NSString *userAvatarURL) {
                       // Your code
                   } loginError:^(NSError *error) {
                       // Your code
                   }];
}
````

**More information please see the source code.**   

**If you have any question, please issue or contact me.**   

**If you like it, please star me, thanks a lot.**

**Have Fun.**