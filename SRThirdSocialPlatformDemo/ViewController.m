//
//  ViewController.m
//  autoDemo
//
//  Created by zwm on 15/5/14.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import "ViewController.h"
#import "WXTableViewController.h"
#import "WBTableViewController.h"
#import "QQTableViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"第三方社交平台功能";
    
    [self.view addSubview:({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                              style:UITableViewStyleGrouped];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView;
    })];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:nil];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"微信";
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"微博";
    } else {
        cell.textLabel.text = @"QQ";
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        WXTableViewController *wxTVC = [[WXTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:wxTVC animated:YES];
    } else if (indexPath.row == 1) {
        WBTableViewController *wbTVC = [[WBTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:wbTVC animated:YES];
    } else {
        QQTableViewController *qqTVC = [[QQTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:qqTVC animated:YES];
    }
}

@end
