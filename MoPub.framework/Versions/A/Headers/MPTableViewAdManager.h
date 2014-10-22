//
//  MPTableViewAdManager.h
//  Copyright (c) 2014 MoPub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MPNativeAd;

/**
 * The MPTableViewAdManager class provides convenient functionality for adding advertisements
 * to a table view. Such advertisements are displayed in table view cells alongside your 
 * application's content, and can be styled to support your application's native look and feel.
 *
 * **Warning**: This class has been deprecated. Use the `MPTableViewAdPlacer` class instead to
 * display ads within a table view.
 */

@interface MPTableViewAdManager : NSObject

/** @name Initializing an Ad Manager */

/**
 * Instantiates a table view ad manager with the given table view.
 *
 * @param tableView A table view that will be used to display ads.
 */
- (id)initWithTableView:(UITableView *)tableView __attribute__((deprecated));

/** @name Obtaining Configured Ad Cells */

/**
 * Returns a UITableViewCell instance displaying ad content for the provided ad object.
 *
 * Your table view's data source should use this method to obtain cells displaying ad content.
 * This method automatically dequeues reusable cells from the table view corresponding to
 * the provided _cellClass_.
 *
 * @return The configured cell instance.
 * @param adObject An ad object whose resources should be used to populate the returned cell.
 * @param cellClass A UITableViewCell subclass configured for displaying ads. The class
 * should implement the MPNativeAdRendering protocol.
 * @see MPNativeAdRendering
 */
- (UITableViewCell *)adCellForAd:(MPNativeAd *)adObject cellClass:(Class)cellClass __attribute__((deprecated));

@end
