//
//  MPNativeAdRendering.h
//  Copyright (c) 2013 MoPub. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MPNativeAd.h"

/**
 * The MPNativeAdRendering protocol provides methods for displaying ad content in
 * custom view classes.
 */

@protocol MPNativeAdRendering <NSObject>

/**
 * Populates a view's relevant subviews with ad content.
 *
 * Your implementation of this method should call one or more of the methods listed below.
 *
 * @param adObject An object containing ad assets (text, images) which may be loaded
 * into appropriate subviews (UILabel, UIImageView) via convenience methods.
 * @see [MPNativeAd loadTextIntoLabel:]
 * @see [MPNativeAd loadTitleIntoLabel:]
 * @see [MPNativeAd loadIconIntoImageView:]
 * @see [MPNativeAd loadImageIntoImageView:]
 * @see [MPNativeAd loadCallToActionTextIntoLabel:]
 * @see [MPNativeAd loadCallToActionTextIntoButton:]
 * @see [MPNativeAd loadImageForURL:intoImageView:]
 */
- (void)layoutAdAssets:(MPNativeAd *)adObject;

@optional

/**
 * Returns size of the rendering object given a maximum width.
 *
 * @param maximumWidth The maximum width intended for the size of the view.
 *
 * @return a CGSize that corresponds to the given maximumWidth.
 */
+ (CGSize)sizeWithMaximumWidth:(CGFloat)maximumWidth;

/**
 * Specifies a nib object containing a view that should be used to render ads.
 *
 * If you want to use a nib object to render ads, you must implement this method.
 *
 * @return an initialized UINib object. This is not allowed to be `nil`.
 */
+ (UINib *)nibForAd;

@end
