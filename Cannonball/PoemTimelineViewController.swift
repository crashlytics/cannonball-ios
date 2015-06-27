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

class PoemTimelineViewController: TWTRTimelineViewController {

    // Search query for Tweets matching the right hashtags and containing an attached poem picture.
    let poemSearchQuery = "#cannonballapp AND pic.twitter.com AND (#adventure OR #romance OR #nature OR #mystery)"

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Login as a guest on Twitter.
        Twitter.sharedInstance().logInGuestWithCompletion { (session: TWTRGuestSession!, error: NSError!) -> Void in
            // Check we have a valid guest session.
            if let validSession = session {
                // Assign our search query to the data source of the Search Timeline which will then be rendered.
                let client = Twitter.sharedInstance().APIClient
                self.dataSource = TWTRSearchTimelineDataSource(searchQuery: self.poemSearchQuery, APIClient: client)
            }
        }

        // Customize the table view.
        let headerHeight: CGFloat = 15
        let contentHeight = self.view.frame.size.height - headerHeight
        let navHeight = self.navigationController?.navigationBar.frame.height
        let navYOrigin = self.navigationController?.navigationBar.frame.origin.y
        tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, self.tableView.bounds.size.width, headerHeight))
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.cannonballBeigeColor()

        // Customize the navigation bar.
        title = "Popular Poems"
        navigationController?.navigationBar.translucent = true

        // Add an initial offset to the table view to show the animated refresh control.
        let refreshControlOffset = self.refreshControl?.frame.size.height
        tableView.frame.origin.y += refreshControlOffset!
        refreshControl?.beginRefreshing()
    }

}
