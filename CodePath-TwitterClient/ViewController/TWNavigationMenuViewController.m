//
//  TWNavigationMenuViewController.m
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/30/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "TWNavigationMenuViewController.h"
#import "UITableViewCell+TWUtil.h"
#import <BlocksKit+UIKit.h>

@interface TWNavigationMenuViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingSpaceConstraint;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;

@end



@implementation TWNavigationMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = 88;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:[UITableViewCell defaultIdentifier]];
    [self.tableView reloadData];
    
    [self.dismissButton bk_addEventHandler:^(id sender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationDelegate showModule:(TWNavigationModule)indexPath.row animated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return TWNavigationModuleCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[UITableViewCell defaultIdentifier] forIndexPath:indexPath];
    switch ((TWNavigationModule)indexPath.row) {
        case TWNavigationModuleTimeline:
            cell.textLabel.text = @"Timeline";
            break;
        case TWNavigationModuleProfile:
            cell.textLabel.text = @"Profile";
            break;
        case TWNavigationModuleMentions:
            cell.textLabel.text = @"Mentions";
            break;
        case TWNavigationModuleLogin:
            cell.textLabel.text = @"Sign Out";
            break;
        case TWNavigationModuleBieber:
            cell.textLabel.text = @"Bieber";
            break;
        case TWNavigationModuleHome:
            cell.textLabel.text = @"Home";
            break;
        default:
            break;
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:24 weight:8];
    cell.textLabel.frame = cell.contentView.bounds;
    return cell;
}


@end
