//
//  Digits.h
//
//  Copyright (c) 2014 Twitter. All rights reserved.
//

#import "DGTSession.h"
#import "DGTAuthenticateButton.h"

@class UIViewController;

/**
 *  The `Digits` class contains the main methods to implement the Digits authentication flow.
 *
 *  @warning You must first properly initialize the Twitter kit in order to use Digits. Consult the Twitter kit documentation for more information.
 */
@interface Digits : NSObject

/**
 *  Returns the unique Digits object (singleton).
 *
 *  @return The Digits singleton.
 */
+ (Digits *)sharedInstance;

/**
 *  Starts the authentication flow UI. The UI is presented as a modal off of the top-most view controller. The modal title is the application name.
 *
 *  @param completion Block called after the authentication flow has ended.
 */
- (void)authenticateWithCompletion:(DGTAuthenticationCompletion)completion;

/**
 *  Starts the authentication flow UI. The UI is presented as a modal off of the top-most view controller.
 *
 *  @param title      Title for the modal screens.
 *  @param completion Block called after the authentication flow has ended.
 */
- (void)authenticateWithTitle:(NSString *)title completion:(DGTAuthenticationCompletion)completion;

/**
 *  Starts the authentication flow UI.
 *
 *  @param viewController    View controller used to present the modal authentication view.
 *  @param title             Title for the modal screens.
 *  @param completion        Block called after the authentication flow has ended.
 */
- (void)authenticateWithViewController:(UIViewController *)viewController title:(NSString *)title completion:(DGTAuthenticationCompletion)completion;

/**
 *  Deletes the local Twitter user session from this app. This will not remove the system Twitter account nor make a network request to invalidate the session. Subsequent calls to `authenticateWith` methods will start a new Digits authentication flow.
 */
- (void)logOut;

@end
