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
import TwitterKit
import Crashlytics
import MoPub

// Set your MoPub Ad Unit ID just below to display MoPub Native Ads.
let MoPubAdUnitID = ""

class PoemHistoryViewController: UITableViewController, PoemCellDelegate {

    // MARK: Properties

    private let poemTableCellReuseIdentifier = "PoemCell"

    var placer: MPTableViewAdPlacer!

    var poems: [Poem] = []

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Log Answers Custom Event.
        Answers.logCustomEventWithName("Viewed Poem History", customAttributes: nil)

        // Create the Static Native Ad renderer configuration.
        let staticSettings = MPStaticNativeAdRendererSettings()
        staticSettings.renderingViewClass = NativeAdCell.self
        staticSettings.viewSizeHandler = { (maxWidth: CGFloat) -> CGSize in
            return CGSizeMake(maxWidth, maxWidth)
        }
        let staticConfiguration = MPStaticNativeAdRenderer.rendererConfigurationWithRendererSettings(staticSettings)

        // Create the Native Video Ad renderer configuration.
        let videoSettings = MOPUBNativeVideoAdRendererSettings()
        videoSettings.renderingViewClass = staticSettings.renderingViewClass
        videoSettings.viewSizeHandler = staticSettings.viewSizeHandler
        let videoConfiguration = MOPUBNativeVideoAdRenderer.rendererConfigurationWithRendererSettings(videoSettings)

        // Setup the ad placer.
        placer = MPTableViewAdPlacer(tableView: tableView, viewController: self, rendererConfigurations: [staticConfiguration, videoConfiguration])

        // Add targeting parameters.
        let targeting = MPNativeAdRequestTargeting()
        targeting.desiredAssets = Set([kAdIconImageKey, kAdMainImageKey, kAdCTATextKey, kAdTextKey, kAdTitleKey])

        // Begin loading ads and placing them into your feed, using the ad unit ID.
        placer.loadAdsForAdUnitID(MoPubAdUnitID)

        // Retrieve the poems.
        poems = PoemPersistence.sharedInstance.retrievePoems()

        // Customize the navigation bar.
        navigationController?.navigationBar.topItem?.title = ""

        // Remove the poem composer from the navigation controller if we're coming from it.
        if let previousController: AnyObject = navigationController?.viewControllers[1] {
            if previousController.isKindOfClass(PoemComposerViewController.self) {
                navigationController?.viewControllers.removeAtIndex(1)
            }
        }

        // Add a table header and computer the cell height so they perfectly fit the screen.
        let headerHeight: CGFloat = 15
        tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, headerHeight))
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Make sure the navigation bar is not translucent when scrolling the table view.
        navigationController?.navigationBar.translucent = false

        // Display a label on the background if there are no poems to display.
        let noPoemsLabel = UILabel()
        noPoemsLabel.text = "You have not composed any poems yet."
        noPoemsLabel.textAlignment = .Center
        noPoemsLabel.textColor = UIColor.cannonballGreenColor()
        noPoemsLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(14))
        tableView.backgroundView = noPoemsLabel
        tableView.backgroundView?.hidden = true
        tableView.backgroundView?.alpha = 0
        toggleNoPoemsLabel()
    }

    // MARK: UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poems.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Use the MoPub-specific version of the table view method.
        let cell = tableView.mp_dequeueReusableCellWithIdentifier(poemTableCellReuseIdentifier, forIndexPath: indexPath) as! UITableViewCell

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
            let poem = poems[indexPath.row]

            // Remove the poem and reload the table view.
            poems = poems.filter( { $0 != poem })
            tableView.mp_deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)

            // Display the no poems label if this was the last poem.
            toggleNoPoemsLabel()

            // Archive and save the poems again.
            PoemPersistence.sharedInstance.overwritePoems(poems)

            // Log Answers Custom Event.
            Answers.logCustomEventWithName("Removed Poem", customAttributes: nil)
        }
    }

    // MARK: UITableViewDelegate

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView.frame.size.width * 0.75
    }

    // MARK: PoemCellDelegate

    func poemCellWantsToSharePoem(poemCell: PoemCell) {
        // Find the poem displayed at this index path.
        let indexPath = tableView.mp_indexPathForCell(poemCell)
        let poem = poems[indexPath.row]

        // Generate the image of the poem.
        let poemImage = poemCell.capturePoemImage()

        // Use the TwitterKit to create a Tweet composer.
        let composer = TWTRComposer()

        // Prepare the Tweet with the poem and image.
        composer.setText("Just composed a poem! #cannonballapp #\(poem.theme.lowercaseString)")
        composer.setImage(poemImage)

        // Present the composer to the user.
        composer.showFromViewController(self) { result in
            if result == .Done {
                // Log Answers Custom Event.
                Answers.logShareWithMethod("Twitter", contentName: poem.theme, contentType: "Poem", contentId: poem.UUID.description,
                    customAttributes: [
                        "Poem": poem.getSentence(),
                        "Theme": poem.theme,
                        "Length": poem.words.count,
                        "Picture": poem.picture
                    ]
                )
            } else if result == .Cancelled {
                // Log Answers Custom Event.
                Answers.logCustomEventWithName("Cancelled Twitter Sharing",
                    customAttributes: [
                        "Poem": poem.getSentence(),
                        "Theme": poem.theme,
                        "Length": poem.words.count,
                        "Picture": poem.picture
                    ]
                )
            }
        }
    }

    // MARK: Utilities

    private func toggleNoPoemsLabel() {
        if tableView.numberOfRowsInSection(0) == 0 {
            UIView.animateWithDuration(0.15) {
                self.tableView.backgroundView!.hidden = false
                self.tableView.backgroundView!.alpha = 1
            }
        } else {
            UIView.animateWithDuration(0.15,
                animations: {
                    self.tableView.backgroundView!.alpha = 0
                },
                completion: { finished in
                    self.tableView.backgroundView!.hidden = true
                }
            )
        }
    }

}
