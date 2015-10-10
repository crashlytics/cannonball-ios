//
//  TWTRTweetViewDelegate.h
//
//  Copyright (c) 2015 Twitter. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TWTRSession;
@class TWTRTweetView;
@class TWTRTweet;
@protocol TWTRSessionStore;

NS_ASSUME_NONNULL_BEGIN

typedef void (^TWTRAuthenticationCompletionHandler)(id<TWTRSessionStore> sessionStore, NSString *userID);

/**
 Delegate for `TWTRTweetView` to receive updates on the user interacting with this particular Tweet view.
 
    // Create the tweet view
    TWTRTweetView *tweetView = [[TWTRTweetView alloc] initWithTweet:tweet];
    // Set the delegate
    tweetView.delegate = self;
 */
@protocol TWTRTweetViewDelegate <NSObject>

@optional

/**
 *  The tweet view was tapped. Implement to show your own webview if desired using the `permalinkURL` property on the `TWTRTweet` object passed in.
 *
 *  @param tweetView The Tweet view that was tapped.
 *  @param tweet     The Tweet model object being shown.
 */
- (void)tweetView:(TWTRTweetView *)tweetView didSelectTweet:(TWTRTweet *)tweet;

/**
 *  The tweet view image was tapped.
 *
 *  @param tweetView The Tweet view that was tapped.
 *  @param image     The exact UIImage data shown by the Tweet view.
 *  @param imageURL  The full URL of the image being shown.
 */
- (void)tweetView:(TWTRTweetView *)tweetView didTapImage:(UIImage *)image withURL:(NSURL *)imageURL;

/**
 *  A URL in the text of a tweet was tapped. Implement to show your own webview rather than opening Safari.
 *
 *  @param tweetView The Tweet view that was tapped.
 *  @param url       The URL that was tapped.
 */
- (void)tweetView:(TWTRTweetView *)tweetView didTapURL:(NSURL *)url;

/**
 *  The Tweet view "Share" button was tapped and the `UIActivityViewController` was shown.
 *
 *  @param tweetView The Tweet view that was tapped.
 *  @param tweet     The Tweet model object being shown.
 */
- (void)tweetView:(TWTRTweetView *)tweetView willShareTweet:(TWTRTweet *)tweet;

/**
 *  The share action for a Tweet was completed.
 *
 *  @param tweetView The Tweet view that was tapped.
 *  @param tweet     The Tweet model object being shown.
 *  @param shareType The share action that was completed. (e.g. `UIActivityTypePostToFacebook`, `UIActivityTypePostToTwitter`, or `UIActivityTypeMail`)
 */
- (void)tweetView:(TWTRTweetView *)tweetView didShareTweet:(TWTRTweet *)tweet withType:(NSString *)shareType;

/**
 *  The share action for a Tweet was cancelled.
 *
 *  @param tweetView The Tweet view handling the share action.
 *  @param tweet     The Tweet model object represented.
 */
- (void)tweetView:(TWTRTweetView *)tweetView cancelledShareTweet:(TWTRTweet *)tweet;

/**
 *  The Tweet view favorite button was tapped and the action was completed with
 *  the Twitter API.
 *
 *  @param tweetView The Tweet view showing this Tweet object.
 *  @param tweet     The Tweet model that was just favorited.
 */
- (void)tweetView:(TWTRTweetView *)tweetView didFavoriteTweet:(TWTRTweet *)tweet;

/**
 *  The Tweet view unfavorite button was tapped and the action was completed with 
 *  the Twitter API.
 *
 *  @param tweetView The Tweet view showing this Tweet object.
 *  @param tweet     The Tweet model object that was just unfavorited.
 */
- (void)tweetView:(TWTRTweetView *)tweetView didUnfavoriteTweet:(TWTRTweet *)tweet;

/**
 *  Requests authentication from the delegate to use for a network request that requires user context.
 *
 *  @param tweetView                        The Tweet view showing this Tweet object.
 *  @param authenticationCompletionHandler  The completion block that your delegate method must call to provide the necessary
 *                                          user context e.g. user session.
 */
- (void)tweetView:(TWTRTweetView *)tweetView willRequireAuthenticationCompletionHandler:(TWTRAuthenticationCompletionHandler)authenticationCompletionHandler;

@end

NS_ASSUME_NONNULL_END
