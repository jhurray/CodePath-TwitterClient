//
//  TWTweetListViewController.m
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/29/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "TWTweetListViewController.h"
#import "TWTweetTableViewCell.h"
#import "UIAlertController+TWUtil.h"
#import "UITableViewCell+TWUtil.h"
#import <BlocksKit/BlocksKit+UIKit.h>

@interface TWTweetListViewController () <UITableViewDelegate, UITableViewDataSource, TWTweetTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray<TWTweet *> *models;
@property (nonatomic, weak) UIRefreshControl *refreshControl;
@property (nonatomic, assign) TWTweetListType type;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, copy) void(^tweetActionCompletion)(TWTweet *, NSError *);
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation TWTweetListViewController

- (instancetype)initWithNavigationDelegate:(TWNavigationDelegate *)navigationDelegate type:(TWTweetListType)type userName:(NSString *)userName
{
    self = [super initWithNavigationDelegate:navigationDelegate];
    if (self) {
        self.type = type;
        self.userName = userName;
        
        __typeof(self) __weak weakSelf = self;
        self.tweetActionCompletion = ^(TWTweet *tweet, NSError *error) {
            if (!error) {
                NSInteger index = [weakSelf.models indexOfObjectPassingTest:^BOOL(TWTweet * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    return [tweet.ID isEqualToString:obj.ID];
                }];
                if (index != NSNotFound && index < weakSelf.models.count) {
                    NSMutableArray<TWTweet *> *newModels = [weakSelf.models mutableCopy];
                    [newModels replaceObjectAtIndex:index withObject:tweet];
                    weakSelf.models = newModels;
                    [weakSelf.tableView reloadData];
                }
            }
            else {
                [UIAlertController showGenericErrorFromViewController:weakSelf];
            }
        };
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl bk_addEventHandler:^(id sender) {
        [self reloadData];
    } forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    self.refreshControl = refreshControl;
    
    UINib *cellNib = [UINib nibWithNibName:@"TWTweetTableViewCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:[TWTweetTableViewCell defaultIdentifier]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.alpha = 0;
    self.tableView.estimatedRowHeight = 120;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.models) {
        self.spinner.hidesWhenStopped = YES;
        [self.spinner startAnimating];
    }
    [self reloadData];
}


- (void)reloadData
{
    [[TWTwitterClient sharedInstance] fetchTweetsWithType:self.type userName:self.userName successBlock:^(NSArray<TWTweet *> *tweets) {
        
        if (!self.models) {
            [UIView animateWithDuration:0.3 animations:^{
                self.tableView.alpha = 1;
                self.spinner.alpha = 0;
            } completion:^(BOOL finished) {
                [self.spinner stopAnimating];
            }];
        }
        
        self.models = tweets;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    } failureBlock:^(NSError *error) {
        [UIAlertController showGenericErrorFromViewController:self];
        [self.refreshControl endRefreshing];
    }];
}


#pragma mark - TWTweetTableViewCellDelegate
- (void)tweetTableViewCellReplySelected:(TWTweetTableViewCell *)cell
{
    [self.navigationDelegate showComposeWithRetweet:cell.model];
}


- (void)tweetTableViewCellRetweetSelected:(TWTweetTableViewCell *)cell
{
    TWTweet *tweet = cell.model;
    if (tweet.isRetweeted) {
        [[TWTwitterClient sharedInstance] unretweetTweetWithID:tweet.ID completion:self.tweetActionCompletion];
    }
    else {
        [[TWTwitterClient sharedInstance] retweetTweetWithID:tweet.ID completion:self.tweetActionCompletion];
    }
}


- (void)tweetTableViewCellFavoriteSelected:(TWTweetTableViewCell *)cell
{
    TWTweet *tweet = cell.model;
    if (tweet.isFavorited) {
        [[TWTwitterClient sharedInstance] unfavoriteTweetWithID:tweet.ID completion:self.tweetActionCompletion];
    }
    else {
        [[TWTwitterClient sharedInstance] favoriteTweetWithID:tweet.ID completion:self.tweetActionCompletion];
    }
    
}


- (void)tweetTableViewCellProfileImageSelected:(TWTweetTableViewCell *)cell
{
    if (!self.disableProfileNavigation) {
        [self.navigationDelegate showUser:cell.model.user];
    }
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWTweet *tweet = self.models[indexPath.row];
    [self.navigationDelegate showTweet:tweet];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWTweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TWTweetTableViewCell defaultIdentifier] forIndexPath:indexPath];
    cell.model = self.models[indexPath.row];
    cell.delegate = self;
    [cell reloadData];
    return cell;
}

@end
