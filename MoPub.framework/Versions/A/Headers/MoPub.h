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

#define MoPubKit [[MoPub alloc] init]

@interface MoPub : NSObject

- (void)start;
- (NSString *)version;
- (NSString *)bundleIdentifier;

@end