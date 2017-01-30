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

    fileprivate let poemTableCellReuseIdentifier = "PoemCell"

    var placer: MPTableViewAdPlacer!

    var poems: [Poem] = []

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Log Answers Custom Event.
        Answers.logCustomEvent(withName: "Viewed Poem History", customAttributes: nil)

        // Create the Static Native Ad renderer configuration.
        let staticSettings = MPStaticNativeAdRendererSettings()
        staticSettings.renderingViewClass = NativeAdCell.self
        staticSettings.viewSizeHandler = { (maxWidth: CGFloat) -> CGSize in
            return CGSize(width: maxWidth, height: maxWidth)
        }
        let staticConfiguration = MPStaticNativeAdRenderer.rendererConfiguration(with: staticSettings)

        // Create the Native Video Ad renderer configuration.
        let videoSettings = MOPUBNativeVideoAdRendererSettings()
        videoSettings.renderingViewClass = staticSettings.renderingViewClass
        videoSettings.viewSizeHandler = staticSettings.viewSizeHandler
        let videoConfiguration = MOPUBNativeVideoAdRenderer.rendererConfiguration(with: videoSettings)

        // Setup the ad placer.
        placer = MPTableViewAdPlacer(tableView: tableView, viewController: self, rendererConfigurations: [staticConfiguration as Any, videoConfiguration as Any])

        // Add targeting parameters.
        let targeting = MPNativeAdRequestTargeting()
        targeting.desiredAssets = Set([kAdIconImageKey, kAdMainImageKey, kAdCTATextKey, kAdTextKey, kAdTitleKey])

        // Begin loading ads and placing them into your feed, using the ad unit ID.
        placer.loadAds(forAdUnitID: MoPubAdUnitID)

        // Retrieve the poems.
        poems = PoemPersistence.sharedInstance.retrievePoems()

        // Customize the navigation bar.
        navigationController?.navigationBar.topItem?.title = ""

        // Remove the poem composer from the navigation controller if we're coming from it.
        if let previousController: AnyObject = navigationController?.viewControllers[1] {
            if previousController.isKind(of: PoemComposerViewController.self) {
                navigationController?.viewControllers.remove(at: 1)
            }
        }

        // Add a table header and computer the cell height so they perfectly fit the screen.
        let headerHeight: CGFloat = 15
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: headerHeight))
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Make sure the navigation bar is not translucent when scrolling the table view.
        navigationController?.navigationBar.isTranslucent = false

        // Display a label on the background if there are no poems to display.
        let noPoemsLabel = UILabel()
        noPoemsLabel.text = "You have not composed any poems yet."
        noPoemsLabel.textAlignment = .center
        noPoemsLabel.textColor = UIColor.cannonballGreenColor()
        noPoemsLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(14))
        tableView.backgroundView = noPoemsLabel
        tableView.backgroundView?.isHidden = true
        tableView.backgroundView?.alpha = 0
        toggleNoPoemsLabel()
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return poems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Use the MoPub-specific version of the table view method.
        let cell = tableView.mp_dequeueReusableCell(withIdentifier: poemTableCellReuseIdentifier, for: indexPath) as! UITableViewCell

        if let poemCell = cell as? PoemCell {
            poemCell.delegate = self
            let poem = poems[indexPath.row]
            poemCell.configureWithPoem(poem)
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Find the poem displayed at this index path.
            let poem = poems[indexPath.row]

            // Remove the poem and reload the table view.
            poems = poems.filter( { $0 != poem })
            tableView.mp_deleteRows(atIndexPaths: [indexPath], with: .automatic)

            // Display the no poems label if this was the last poem.
            toggleNoPoemsLabel()

            // Archive and save the poems again.
            PoemPersistence.sharedInstance.overwritePoems(poems)

            // Log Answers Custom Event.
            Answers.logCustomEvent(withName: "Removed Poem", customAttributes: nil)
        }
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.width * 0.75
    }

    // MARK: PoemCellDelegate

    func poemCellWantsToSharePoem(_ poemCell: PoemCell) {
        // Find the poem displayed at this index path.
        let indexPath = tableView.mp_indexPath(for: poemCell)
        let poem = poems[(indexPath?.row)!]

        // Generate the image of the poem.
        let poemImage = poemCell.capturePoemImage()

        // Use the TwitterKit to create a Tweet composer.
        let composer = TWTRComposer()

        // Prepare the Tweet with the poem and image.
        composer.setText("Just composed a poem! #cannonballapp #\(poem.theme.lowercased())")
        composer.setImage(poemImage)

        // Present the composer to the user.
        composer.show(from: self) { result in
            if result == .done {
                // Log Answers Custom Event.
                Answers.logShare(withMethod: "Twitter", contentName: poem.theme, contentType: "Poem", contentId: poem.UUID.description,
                    customAttributes: [
                        "Poem": poem.getSentence(),
                        "Theme": poem.theme,
                        "Length": poem.words.count,
                        "Picture": poem.picture
                    ]
                )
            } else if result == .cancelled {
                // Log Answers Custom Event.
                Answers.logCustomEvent(withName: "Cancelled Twitter Sharing",
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

    fileprivate func toggleNoPoemsLabel() {
        if tableView.numberOfRows(inSection: 0) == 0 {
            UIView.animate(withDuration: 0.15, animations: {
                self.tableView.backgroundView!.isHidden = false
                self.tableView.backgroundView!.alpha = 1
            }) 
        } else {
            UIView.animate(withDuration: 0.15,
                animations: {
                    self.tableView.backgroundView!.alpha = 0
                },
                completion: { finished in
                    self.tableView.backgroundView!.isHidden = true
                }
            )
        }
    }

}
