//
//  MPNativeAdAdapter.h
//  Copyright (c) 2014 MoPub. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPNativeAdAdapter;

/**
 * Classes that conform to the `MPNativeAdAdapter` protocol can have an
 * `MPNativeAdAdapterDelegate` delegate object. You use this delegate to communicate
 * native ad events (such as impressions and clicks occurring) back to the MoPub SDK.
 */
@protocol MPNativeAdAdapterDelegate <NSObject>

@required

/**
 * Asks the delegate for a view controller to use for presenting modal content, such as the in-app
 * browser that can appear when an ad is tapped.
 *
 * @return A view controller that should be used for presenting modal content.
 */
- (UIViewController *)viewControllerForPresentingModalView;

@optional

/**
 * This method is called before the backing native ad logs an impression.
 *
 * @param adAdapter You should pass `self` to allow the MoPub SDK to associate this event with the
 * correct instance of your ad adapter.
 */
- (void)nativeAdWillLogImpression:(id<MPNativeAdAdapter>)adAdapter;

/**
 * This method is called when the user interacts with the ad.
 *
 * @param adAdapter You should pass `self` to allow the MoPub SDK to associate this event with the
 * correct instance of your ad adapter.
 */
- (void)nativeAdDidClick:(id<MPNativeAdAdapter>)adAdapter;

@end

/**
 * The `MPNativeAdAdapter` protocol allows the MoPub SDK to interact with native ad objects obtained
 * from third-party ad networks. An object that adopts this protocol acts as a wrapper for a native
 * ad object, translating its proprietary interface into a common one that the MoPub SDK can
 * understand.
 *
 * An object that adopts this protocol must implement the `properties` property to specify a
 * dictionary of assets, such as title and text, that should be rendered as part of a native ad.
 * When possible, you should place values in the returned dictionary such that they correspond to
 * the pre-defined keys in the MPNativeAdConstants header file.
 *
 * An adopting object must additionally implement -displayContentForURL:rootViewController:completion:
 * to supply the behavior that should occur when the user interacts with the ad.
 *
 * Optional methods of the protocol allow the adopting object to define when and how impressions
 * and interactions should be tracked.
 */
@protocol MPNativeAdAdapter <NSObject>

@required

/** @name Ad Resources */

/**
 * Provides a dictionary of all publicly accessible assets (such as title and text) for the
 * native ad.
 *
 * When possible, you should place values in the returned dictionary such that they correspond to
 * the pre-defined keys in the MPNativeAdConstants header file.
 */
@property (nonatomic, readonly) NSDictionary *properties;

/**
 * The default click-through URL for the ad.
 *
 * This may safely be set to nil if your network doesn't expose this value (for example, it may only
 * provide a method to handle a click, lacking another for retrieving the URL itself).
 */
@property (nonatomic, readonly) NSURL *defaultActionURL;

/** @name Handling Ad Interactions */

@optional

/**
 * Tells the object to open the specified URL using an appropriate mechanism.
 *
 * @param URL The URL to be opened.
 * @param controller The view controller that should be used to present the modal view controller.
 * @param completionBlock The block to be executed when the action defined by the URL has been
 * completed, returning control to the application.
 *
 * Your implementation of this method should either forward the request to the underlying
 * third-party ad object (if it has built-in support for handling ad interactions), or open an
 * in-application modal web browser or a modal App Store controller.
 */
- (void)displayContentForURL:(NSURL *)URL
          rootViewController:(UIViewController *)controller
                  completion:(void (^)(BOOL success, NSError *error))completionBlock;

/**
 * Determines whether MPNativeAd should track impressions
 *
 * If not implemented, this will be assumed to return NO, and MPNativeAd will track impressions.
 * If this returns YES, then MPNativeAd will defer to the MPNativeAdAdapterDelegate callbacks to
 * track impressions.
 */
- (BOOL)enableThirdPartyImpressionTracking;

/**
 * Determines whether MPNativeAd should track clicks
 *
 * If not implemented, this will be assumed to return NO, and MPNativeAd will track clicks.
 * If this returns YES, then MPNativeAd will defer to the MPNativeAdAdapterDelegate callbacks to
 * track clicks.
 */
- (BOOL)enableThirdPartyClickTracking;

/**
 * Tracks an impression for this ad.
 *
 * To avoid reporting discrepancies, you should only implement this method if the third-party ad
 * network requires impressions to be reported manually.
 */
- (void)trackImpression;

/**
 * Tracks a click for this ad.
 *
 * To avoid reporting discrepancies, you should only implement this method if the third-party ad
 * network requires clicks to be reported manually.
 */
- (void)trackClick;

/**
 * The `MPNativeAdAdapterDelegate` to send messages to as events occur.
 *
 * The `delegate` object defines several methods that you should call in order to inform MoPub
 * of interactions with the ad. This delegate needs to be implemented if third party impression and/or
 * click tracking is enabled.
 */
@property (nonatomic, weak) id<MPNativeAdAdapterDelegate> delegate;

/**
 * Specifies how long your ad must be on screen before an impression is tracked.
 *
 * When a view containing a native ad is rendered and presented, the MoPub SDK begins tracking the
 * amount of time the view has been visible on-screen in order to automatically record impressions.
 * This value represents the time required for an impression to be tracked.
 *
 * The default value is `kDefaultRequiredSecondsForImpression`.
 */
@property (nonatomic, readonly) NSTimeInterval requiredSecondsForImpression;

/** @name Responding to an Ad Being Attached to a View */

/**
 * This method will be called when your ad's content is about to be loaded into a view.
 *
 * @param view A view that will contain the ad content.
 *
 * You should implement this method if the underlying third-party ad object needs to be informed
 * of this event.
 */
- (void)willAttachToView:(UIView *)view;

/**
 * This method will be called when your ad's content is removed from a view.
 *
 * @param view A view that did contain the ad content.
 *
 * You should implement this method if the underlying third-party ad object needs to be informed
 * of this event while not invalidating the ad.
 */
-  (void)didDetachFromView:(UIView *)view;

@end
