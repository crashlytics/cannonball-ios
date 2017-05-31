//
// Copyright (C) 2017 Google, Inc. and other contributors.
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
        Answers.logCustomEvent(withName: "Viewed Poem Timeline", customAttributes: nil)

        let client = TWTRAPIClient()
        self.dataSource = TWTRSearchTimelineDataSource(searchQuery: self.poemSearchQuery, apiClient: client)

        // Customize the table view.
        let headerHeight: CGFloat = 15
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: headerHeight))
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.cannonballBeigeColor()

        // Customize the navigation bar.
        title = "Popular Poems"
        navigationController?.navigationBar.isTranslucent = true

        // Add an initial offset to the table view to show the animated refresh control.
        let refreshControlOffset = refreshControl?.frame.size.height
        tableView.frame.origin.y += refreshControlOffset!
        refreshControl?.tintColor = UIColor.cannonballGreenColor()
        refreshControl?.beginRefreshing()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Make sure the navigation bar is not translucent when scrolling the table view.
        navigationController?.navigationBar.isTranslucent = false

        // Display a label on the background if there are no recent Tweets to display.
        let noTweetsLabel = UILabel()
        noTweetsLabel.text = "Sorry, there are no recent Tweets to display."
        noTweetsLabel.textAlignment = .center
        noTweetsLabel.textColor = UIColor.cannonballGreenColor()
        noTweetsLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(14))
        tableView.backgroundView = noTweetsLabel
        tableView.backgroundView?.isHidden = true
        tableView.backgroundView?.alpha = 0
        toggleNoTweetsLabel()
    }

    // MARK: Utilities

    fileprivate func toggleNoTweetsLabel() {
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
