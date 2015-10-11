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

class PoemTimelineViewController: TWTRTimelineViewController {

    // MARK: Properties

    // Search query for Tweets matching the right hashtags and containing an attached poem picture.
    let poemSearchQuery = "#cannonballapp AND pic.twitter.com AND (#adventure OR #romance OR #nature OR #mystery)"

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Log Answers Custom Event.
        Answers.logCustomEventWithName("Viewed Poem Timeline", customAttributes: nil)

        // Login as a guest on Twitter.
        Twitter.sharedInstance().logInGuestWithCompletion { session, error in
            // Check we have a valid guest session.
            if session != nil {
                // Assign our search query to the data source of the Search Timeline which will then be rendered.
                let client = Twitter.sharedInstance().APIClient
                self.dataSource = TWTRSearchTimelineDataSource(searchQuery: self.poemSearchQuery, APIClient: client)
            }
        }

        // Customize the table view.
        let headerHeight: CGFloat = 15
        tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, tableView.bounds.size.width, headerHeight))
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.cannonballBeigeColor()

        // Customize the navigation bar.
        title = "Popular Poems"
        navigationController?.navigationBar.translucent = true

        // Add an initial offset to the table view to show the animated refresh control.
        let refreshControlOffset = refreshControl?.frame.size.height
        tableView.frame.origin.y += refreshControlOffset!
        refreshControl?.tintColor = UIColor.cannonballGreenColor()
        refreshControl?.beginRefreshing()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Make sure the navigation bar is not translucent when scrolling the table view.
        navigationController?.navigationBar.translucent = false

        // Display a label on the background if there are no recent Tweets to display.
        let noTweetsLabel = UILabel()
        noTweetsLabel.text = "Sorry, there are no recent Tweets to display."
        noTweetsLabel.textAlignment = .Center
        noTweetsLabel.textColor = UIColor.cannonballGreenColor()
        noTweetsLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(14))
        tableView.backgroundView = noTweetsLabel
        tableView.backgroundView?.hidden = true
        tableView.backgroundView?.alpha = 0
        toggleNoTweetsLabel()
    }

    // MARK: Utilities

    private func toggleNoTweetsLabel() {
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
