//
// Copyright (C) 2014 Twitter, Inc. and other contributors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//         http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import UIKit
import Fabric
import Crashlytics
import TwitterKit
import DigitsKit
import MoPub

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        // Developers: Welcome! Get started with Fabric.app.
        let welcome = "Welcome to Cannonball! Please onboard with the Fabric Mac app. Check the instructions in the README file."
        assert(NSBundle.mainBundle().objectForInfoDictionaryKey("Fabric") != nil, welcome)

        // Register Crashlytics, Twitter, Digits and MoPub with Fabric.
        Fabric.with([Crashlytics.self, Twitter.self, Digits.self, MoPub.self])

        // Check for an existing Twitter or Digits session before presenting the sign in screen.
        if Twitter.sharedInstance().sessionStore.session() == nil && Digits.sharedInstance().session() == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signInViewController: AnyObject! = storyboard.instantiateViewControllerWithIdentifier("SignInViewController")
            window?.rootViewController = signInViewController as? UIViewController
        }

        return true
    }

}
