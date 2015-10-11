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
import Crashlytics
import TwitterKit

class AboutViewController: UIViewController {

    // MARK: References

    @IBOutlet weak var signOutButton: UIButton!

    var logoView: UIImageView!

    // MARK: View Life Cycle

    override func viewDidLoad() {
        // Add the logo view to the top (not in the navigation bar title to have it bigger).
        logoView = UIImageView(frame: CGRectMake(0, 0, 40, 40))
        logoView.image = UIImage(named: "Logo")?.imageWithRenderingMode(.AlwaysTemplate)
        logoView.tintColor = UIColor.cannonballGreenColor()
        logoView.frame.origin.x = (view.frame.size.width - logoView.frame.size.width) / 2
        logoView.frame.origin.y = 8

        // Add the logo view to the navigation controller and bring it to the front.
        navigationController?.view.addSubview(logoView)
        navigationController?.view.bringSubviewToFront(logoView)

        // Customize the navigation bar.
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.cannonballGreenColor()]
        navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        navigationController?.navigationBar.tintColor = UIColor.cannonballGreenColor()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()

        // Log Answers Custom Event.
        Answers.logCustomEventWithName("Viewed About", customAttributes: nil)
    }

    // MARK: IBActions

    @IBAction func dismiss(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func learnMore(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "http://t.co/cannonball")!)
    }

    @IBAction func signOut(sender: AnyObject) {
        // Remove any Twitter or Digits local sessions for this app.
        Twitter.sharedInstance().logOut()
        Digits.sharedInstance().logOut()

        // Remove user information for any upcoming crashes in Crashlytics.
        Crashlytics.sharedInstance().setUserIdentifier(nil)
        Crashlytics.sharedInstance().setUserName(nil)

        // Log Answers Custom Event.
        Answers.logCustomEventWithName("Signed Out", customAttributes: nil)

        // Present the Sign In again.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInViewController: UIViewController! = storyboard.instantiateViewControllerWithIdentifier("SignInViewController") 
        presentViewController(signInViewController, animated: true, completion: nil)
    }

}
