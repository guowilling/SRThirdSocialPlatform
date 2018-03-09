//
//  WXTableViewController.m
//  SRThirdSocialPlatformDemo
//
//  Created by 郭伟林 on 16/9/14.
//  Copyright © 2016年 SR. All rights reserved.
//

#import "WXTableViewController.h"
#import "SRThirdSocialManager.h"

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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:nil];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"授权";
                break;
            case 1:
                cell.textLabel.text = @"登录";
                break;
        }
    } else {
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
                break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
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
                if ([SRThirdSocialManager isAppInstalled:SRThirdSocialWX]) {
                    [SRThirdSocialManager authRequest:SRThirdSocialWX
                                          authSuccess:^(NSString *openID, NSString *unionID) {
                                              self.error = nil;
                                              self.openID = openID;
                                              self.unionID = unionID;
                                              [self.tableView reloadData];
                                          } authError:^(NSError *error) {
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
                if ([SRThirdSocialManager isAppInstalled:SRThirdSocialWX]) {
                    [SRThirdSocialManager loginRequest:SRThirdSocialWX
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
        }
    }
}

@end
