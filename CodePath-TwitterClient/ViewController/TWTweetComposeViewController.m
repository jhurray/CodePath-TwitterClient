//
//  TWTweetComposeViewController.m
//  CodePath-TwitterClient
//
//  Created by  Jeffrey Hurray on 1/30/17.
//  Copyright © 2017 Jeffrey Hurray. All rights reserved.
//

#import "TWTweetComposeViewController.h"
#import <BlocksKit/BlocksKit+UIKit.h>
#import "TWUser.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UIAlertController+TWUtil.h"
#import "TWTwitterClient.h"

@interface TWTweetComposeViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, weak) UILabel *textCounter;

@end

#define kMaxCharacterCount 140

@implementation TWTweetComposeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"New Tweet";
    
    UIBarButtonItem *postButton = [[UIBarButtonItem alloc] bk_initWithTitle:@"Post" style:UIBarButtonItemStyleDone handler:^(id sender) {
        [self postTweet];
    }];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton bk_addEventHandler:^(id sender) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    closeButton.frame = CGRectMake(0, 0, 44, 44);
    [closeButton setImage:[UIImage imageNamed:@"close-icon"] forState:UIControlStateNormal];
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    UILabel *textCounter = [[UILabel alloc] init];
    textCounter.textColor = [UIColor grayColor];
    textCounter.text = @kMaxCharacterCount.stringValue;
    [textCounter sizeToFit];
    UIBarButtonItem *counterButton = [[UIBarButtonItem alloc] initWithCustomView:textCounter];
    self.textCounter = textCounter;
    
    self.navigationItem.rightBarButtonItems = @[postButton, counterButton];
    self.navigationItem.leftBarButtonItem = closeButtonItem;
    
    self.imageView.layer.cornerRadius = 8;
    self.imageView.clipsToBounds = YES;
    self.textView.delegate = self;
    TWUser *currentUser = [TWUser currentUser];
    [self.imageView setImageWithURL:currentUser.profileImageURL];
    self.nameLabel.text = currentUser.name;
    self.handleLabel.text = currentUser.handle;
    
    if (self.retweet) {
        self.textView.text = [NSString stringWithFormat:@"%@ RT: \"%@\" ", self.retweet.user.handle, self.retweet.text];
        [self updateTextCounter];
    }
    [self.textView becomeFirstResponder];
}


- (void)postTweet
{
    if (self.textView.text.length > kMaxCharacterCount) {
        NSString *message = [NSString stringWithFormat:@"Too many characters in your tweet! (must be less than %d)", kMaxCharacterCount];
        [UIAlertController showErroWithMessage:message viewController:self];
    }
    else {
        [[TWTwitterClient sharedInstance] postTweetWithStatus:self.textView.text inReplyToTweet:self.retweet completion:^(TWTweet *tweet, NSError *error) {
            if (error) {
                [UIAlertController showGenericErrorFromViewController:self];
            }
            else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}


- (void)updateTextCounter
{
    NSInteger charactersRemaining = (kMaxCharacterCount - self.textView.text.length);
    self.textCounter.text = [NSString stringWithFormat:@"%ld", charactersRemaining];
    self.textCounter.textColor = (charactersRemaining >= 0) ? [UIColor darkGrayColor] : [UIColor redColor];
}


#pragma mark - UITaxtViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    [self updateTextCounter];
}

@end
