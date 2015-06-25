//
//  MPNativeAdDelegate.h
//  MoPub
//
//  Copyright (c) 2014 MoPub. All rights reserved.
//

/**
 * The delegate of an `MPNativeAd` object must adopt the `MPNativeAdDelegate` protocol. It must
 * implement `viewControllerForPresentingModalView` to provide a root view controller from which
 * the ad view should present modal content.
 */

@protocol MPNativeAdDelegate <NSObject>

@required

/** @name Managing Modal Content Presentation */

/**
 * Asks the delegate for a view controller to use for presenting modal content, such as the in-app
 * browser that can appear when an ad is tapped.
 *
 * @return A view controller that should be used for presenting modal content.
 */
- (UIViewController *)viewControllerForPresentingModalView;

@end