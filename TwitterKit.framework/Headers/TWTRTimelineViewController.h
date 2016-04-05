//
//  TWTRTimelineViewController.h
//  TwitterKit
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitterKit/TWTRTimelineDataSource.h>
@protocol TWTRTweetViewDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 This class is a `UITableViewController` subclass that displays `TWTRTweetTableViewCell` cells. It handles cell-reuse, cell-configuration, and loading more Tweets from the given timeline once the last cell is displayed.

 ## Usage

 Initialize this class with any object that conforms to the `TWTRTimelineDataSource` protocol. We provide two such classes, `TWTRUserTimelineDataSource` and `TWTRSearchTimelineDataSource`. These provide `TWTRTweet` objects to this table view which then configures the instances of `TWTRTweetTableViewCell`.

    // Create the data source
    TWTRAPIClient *client = [[TWTRAPIClient alloc] init];
    TWTRUserTimelineDataSource *dataSource = [[TWTRUserTimelineDataSource alloc] initWithScreenName:@"jack" APIClient:client];

    // Create the timeline view controller
    TWTRTimelineViewController *timeline = [[TWTRTimelineViewController alloc] initWithDataSource:dataSource];

 ## Loading More

 This class loads the first batch of `TWTRTweet` objects from the Twitter API when `viewWillAppear:` is received. It also handles loading more tweets automatically once the last cell has been shown.

 */
@interface TWTRTimelineViewController : UITableViewController

/**
  The source of `TWTRTweet` objects for this `TWTRTimelineViewController`.

  May be set to update the Tweets being shown by this table view. Must be set on the main thread.
 */
@property (nonatomic, copy) id<TWTRTimelineDataSource> dataSource;

/**
 *  Whether action buttons (Like, Share) should be shown on the `TWTRTweetTableViewCell`s inside the tableview.
 */
@property (nonatomic) BOOL showTweetActions;

/**
 * If set, this value will be passed to all TWTRTweetView instances in the timeline.
 */
@property (nonatomic, weak) id<TWTRTweetViewDelegate> tweetViewDelegate;

/**
 Initializes a timeline view controller. Does not start loading tweets until
 `viewWillAppear:` is called.
 
 This method must be used to initialize this class. The `init` method is unavailable.
 
 @param dataSource   A timeline data source object that conforms to the `TWTRTimelineDataSource` protocol.
 
 @return A fully initialized `TWTRTimelineViewController` or nil if the data source is missing.
 */
- (instancetype)initWithDataSource:(nullable id<TWTRTimelineDataSource>)dataSource;

- (instancetype)initWithStyle:(UITableViewStyle)style NS_UNAVAILABLE;

/**
 *  Asynchronously refresh and replace all the data in the table view with the latest `TWTRTweet`s.
 */
- (void)refresh;

@end

NS_ASSUME_NONNULL_END
