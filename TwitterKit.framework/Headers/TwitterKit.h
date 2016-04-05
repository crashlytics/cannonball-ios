//
//  TwitterKit.h
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//


#import <Accounts/Accounts.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import <UIKit/UIKit.h>

#if __has_feature(modules)
@import TwitterCore;
#else
#import <TwitterCore/TwitterCore.h>
#endif


#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
#error "TwitterKit doesn't support iOS 7.x and lower. Please, change your minimum deployment target to iOS 8.0"
#endif

#import <TwitterKit/Twitter.h>
#import <TwitterKit/TWTRAPIClient.h>
#import <TwitterKit/TWTRCardConfiguration.h>
#import <TwitterKit/TWTRCollectionTimelineDataSource.h>
#import <TwitterKit/TWTRComposer.h>
#import <TwitterKit/TWTRComposerTheme.h>
#import <TwitterKit/TWTRComposerViewController.h>
#import <TwitterKit/TWTRJSONConvertible.h>
#import <TwitterKit/TWTRListTimelineDataSource.h>
#import <TwitterKit/TWTRLogInButton.h>
#import <TwitterKit/TWTRNotificationConstants.h>
#import <TwitterKit/TWTROAuthSigning.h>
#import <TwitterKit/TWTRSearchTimelineDataSource.h>
#import <TwitterKit/TWTRTimelineDataSource.h>
#import <TwitterKit/TWTRTimelineType.h>
#import <TwitterKit/TWTRTimelineViewController.h>
#import <TwitterKit/TWTRTweet.h>
#import <TwitterKit/TWTRTweetDetailViewController.h>
#import <TwitterKit/TWTRTweetTableViewCell.h>
#import <TwitterKit/TWTRTweetView.h>
#import <TwitterKit/TWTRTweetViewDelegate.h>
#import <TwitterKit/TWTRUser.h>
#import <TwitterKit/TWTRUserTimelineDataSource.h>

