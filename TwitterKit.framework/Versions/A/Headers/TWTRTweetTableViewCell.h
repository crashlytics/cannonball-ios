//
//  TWTRTweetTableViewCell.h
//
//  Copyright (c) 2014 Twitter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TWTRTweet;
@class TWTRTweetView;

/**
 *  A table view cell subclass which displays a Tweet.
 */
@interface TWTRTweetTableViewCell : UITableViewCell

/**
 *  The Tweet view inside this cell. Holds all relevant text and images.
 */
@property (nonatomic, strong, readonly) TWTRTweetView *tweetView;

/**
 *  Configures the existing Tweet view with a Tweet. Updates labels, images, and thumbnails.
 *
 *  @param tweet The `TWTRTweet` model object for the Tweet to display.
 */
- (void)configureWithTweet:(TWTRTweet *)tweet;

/**
 *  Returns the height calculated using a given width. Generally just for use with prototype cells.
 *
 *  @param width The table view cell width.
 */
- (CGFloat)calculatedHeightForWidth:(CGFloat)width;

@end
