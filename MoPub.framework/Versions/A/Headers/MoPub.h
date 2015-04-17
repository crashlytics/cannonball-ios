//
//  MoPub.h
//  MoPub
//
//  Copyright (c) 2014 MoPub. All rights reserved.
//

#import "MPAdConversionTracker.h"
#import "MPAdView.h"
#import "MPBannerCustomEvent.h"
#import "MPBannerCustomEventDelegate.h"
#import "MPConstants.h"
#import "MPInterstitialAdController.h"
#import "MPInterstitialCustomEvent.h"
#import "MPInterstitialCustomEventDelegate.h"
#import "MPNativeAd.h"
#import "MPNativeAdAdapter.h"
#import "MPNativeAdConstants.h"
#import "MPNativeCustomEvent.h"
#import "MPNativeCustomEventDelegate.h"
#import "MPNativeAdError.h"
#import "MPNativeAdRendering.h"
#import "MPNativeAdRequest.h"
#import "MPNativeAdRequestTargeting.h"
#import "MPTableViewAdManager.h"
#import "MPCollectionViewAdPlacer.h"
#import "MPTableViewAdPlacer.h"
#import "MPClientAdPositioning.h"
#import "MPServerAdPositioning.h"
#import "MPNativeAdSampleTableViewCell.h"
#import "MPNativeAdSampleView.h"
#import "MPNativeAdDelegate.h"

// Import these frameworks for module support.
#import <AdSupport/AdSupport.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import <StoreKit/StoreKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <UIKit/UIKit.h>

#define MoPubKit [MoPub sharedInstance]

@interface MoPub : NSObject

/**
 * Returns the MoPub singleton object.
 *
 * @return The MoPub singleton object.
 */
+ (MoPub *)sharedInstance;

/**
 * A Boolean value indicating whether the MoPub SDK should use Core Location APIs to automatically
 * derive targeting information for location-based ads.
 *
 * When set to NO, the SDK will not attempt to determine device location. When set to YES, the
 * SDK will periodically try to listen for location updates in order to request location-based ads.
 * This only occurs if location services are enabled and the user has already authorized the use
 * of location services for the application. The default value is YES.
 *
 * @param enabled A Boolean value indicating whether the SDK should listen for location updates.
 */
@property (nonatomic, assign) BOOL locationUpdatesEnabled;

- (void)start;
- (NSString *)version;
- (NSString *)bundleIdentifier;

@end
