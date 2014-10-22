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
import MoPub
import TwitterKit

// Set your MoPub Ad Unit ID just below to display MoPub Native Ads.
let MoPubAdUnitID = ""

class PoemHistoryViewController: UITableViewController, PoemCellDelegate {

    // MARK: Properties

    let deletePoemPromptMessage = "Are you sure you would like to delete this poem from your history?"

    private let poemTableCellReuseIdentifier = "PoemCell"

    var placer: MPTableViewAdPlacer!

    var poems: [Poem] = []

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the MoPub ad positioning.
        var positioning = MPServerAdPositioning()

        // Instanciate the MPTableViewAdPlacer.
        placer = MPTableViewAdPlacer(tableView: self.tableView, viewController: self, adPositioning: positioning, defaultAdRenderingClass: NativeAdCell.self)

        // Add targeting parameters.
        var targeting = MPNativeAdRequestTargeting()
        targeting.desiredAssets = NSSet(objects: kAdIconImageKey, kAdMainImageKey, kAdCTATextKey, kAdTextKey, kAdTitleKey)

        // Begin loading ads and placing them into your feed, using the ad unit ID.
        placer.loadAdsForAdUnitID(MoPubAdUnitID)

        // Retrieve the poems.
        self.poems = PoemPersistence.sharedInstance.retrievePoems();

        // Customize the navigation bar.
        self.navigationController?.navigationBar.topItem?.title = ""

        // Remove the poem composer from the navigation controller if we're coming from it.
        if let previousController: AnyObject = self.navigationController?.viewControllers[1] {
            if previousController.isKindOfClass(PoemComposerViewController.self) {
                self.navigationController?.viewControllers.removeAtIndex(1)
            }
        }

        // Add a table header and computer the cell height so they perfectly fit the screen.
        let headerHeight: CGFloat = 20
        let contentHeight = self.view.frame.size.height - headerHeight
        let navHeight = self.navigationController?.navigationBar.frame.height
        let navYOrigin = self.navigationController?.navigationBar.frame.origin.y
        self.tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, self.tableView.bounds.size.width, headerHeight))
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Make sure the navigation bar is not translucent when scrolling the table view.
        self.navigationController?.navigationBar.translucent = false
    }

    // MARK: UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poems.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Use the MoPub-specific version of the table view method.
        let cell = tableView.mp_dequeueReusableCellWithIdentifier(poemTableCellReuseIdentifier, forIndexPath: indexPath) as UITableViewCell

        if let poemCell = cell as? PoemCell {
            poemCell.delegate = self
            let poem = poems[indexPath.row]
            poemCell.configureWithPoem(poem)
        }

        return cell
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Find the poem displayed at this index path.
            var poem = self.poems[indexPath.row]

            // Remove the poem and reload the table view.
            self.poems = self.poems.filter( { $0 != poem })
            self.tableView.mp_deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)

            // Archive and save the poems again.
            PoemPersistence.sharedInstance.overwritePoems(self.poems)
        }
    }

    // MARK: UITableViewDelegate

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.tableView.frame.size.width * 0.75
    }

    // MARK: PoemCellDelegate

    func poemCellWantsToSharePoem(poemCell: PoemCell) {
        // Find the poem displayed at this index path.
        let indexPath = self.tableView.mp_indexPathForCell(poemCell)
        let poem = self.poems[indexPath.row]

        // Generate the image of the poem.
        let poemImage = poemCell.capturePoemImage()

        // Use the TwitterKit to create a Tweet composer.
        let composer = TWTRComposer()

        // Prepare the Tweet with the poem and image.
        composer.setText("Just composed a poem! #cannonballapp #\(poem.theme.lowercaseString)")
        composer.setImage(poemImage)

        // Present the composer to the user.
        composer.showWithCompletion({ (result: TWTRComposerResult!) -> Void in
            if result == .Done {
                println("Tweet composition completed")
            }
        })
    }
}
