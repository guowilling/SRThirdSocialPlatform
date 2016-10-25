//
//  WXTableViewController.m
//  SRThirdSocialPlatformDemo
//
//  Created by 郭伟林 on 16/9/14.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "WXTableViewController.h"
#import "SRAuthManager.h"

@interface WXTableViewController ()

@property (nonatomic, copy) NSString *error;
@property (nonatomic, copy) NSString *unionID;
@property (nonatomic, copy) NSString *openID;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatarURL;

@end

@implementation WXTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"微信";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"授权";
                break;
            case 1:
                cell.textLabel.text = @"登录";
                break;
        }
        return cell;
    } else {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"error: %@", self.error];
                break;
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"openID: %@", self.openID];
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"unionID: %@", self.unionID];
                break;
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"nickname: %@", self.nickname];
                break;
            case 4:
                cell.textLabel.text = [NSString stringWithFormat:@"avatar: %@", self.avatarURL];
                //cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.avatarURL]]];
                break;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.error = nil;
    self.openID = nil;
    self.unionID = nil;
    self.nickname = nil;
    self.avatarURL = nil;
    [self.tableView reloadData];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                if ([SRAuthManager isAppInstalled:SRAuthTypeWeixin]) {
                    [SRAuthManager authRequest:SRAuthTypeWeixin
                                   authSuccess:^(NSString *openID, NSString *unionID) {
                                       // Your code
                                       self.error = nil;
                                       self.openID = openID;
                                       self.unionID = unionID;
                                       [self.tableView reloadData];
                                   } authError:^(NSError *error) {
                                       // Your code
                                       self.error = error.domain;
                                       self.openID = nil;
                                       self.unionID = nil;
                                       [self.tableView reloadData];
                                   }];
                }
                break;
            }
            case 1:
            {
                if ([SRAuthManager isAppInstalled:SRAuthTypeWeixin]) {
                    [SRAuthManager loginRequest:SRAuthTypeWeixin
                                   loginSuccess:^(NSString *openID, NSString *unionID, NSString *userNickname, NSString *userAvatarURL) {
                                       self.error = nil;
                                       self.openID = openID;
                                       self.unionID = unionID;
                                       self.nickname = userNickname;
                                       self.avatarURL = userAvatarURL;
                                       [self.tableView reloadData];
                                   } loginError:^(NSError *error) {
                                       self.error = error.domain;
                                       self.openID = nil;
                                       self.unionID = nil;
                                       self.nickname = nil;
                                       self.avatarURL = nil;
                                       [self.tableView reloadData];
                                   }];
                }
                break;
            }
                
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
        }
    }
}

@end
