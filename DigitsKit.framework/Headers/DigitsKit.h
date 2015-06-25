//
//  DigitsKit.h
//  DigitsKit
//
//  Copyright (c) 2015 Twitter Inc. All rights reserved.
//

#if __has_feature(modules)
@import AddressBook;
@import Foundation;
@import UIKit;
#else
#import <AddressBook/AddressBook.h>
#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
#error "Digits doesn't support iOS 6.x and lower. Please, change your minimum deployment target to iOS 7.0"
#endif

#import <TwitterCore/TwitterCore.h>

#import "DGTContacts.h"
#import "DGTContactsUploadResult.h"
#import "DGTErrors.h"
#import "DGTOAuthSigning.h"
#import "DGTSessionUpdateDelegate.h"
#import "DGTUser.h"
#import "Digits.h"

/**
 *  `DigitsKit` can be used as an element in the array passed to the `+[Fabric with:]`.
 */
#define DigitsKit [Digits sharedInstance]