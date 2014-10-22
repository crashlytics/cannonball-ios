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
import QuartzCore

class ThemeChooserViewController: UITableViewController {

    // MARK: Properties

    @IBOutlet weak var historyButton: UIBarButtonItem!

    @IBOutlet weak var tweetsButton: UIBarButtonItem!

    var logoView: UIImageView!

    var themes: [Theme] = []

    let themeTableCellReuseIdentifier = "ThemeCell"

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Retrieve the themes.
        themes = Theme.getThemes()

        // Add the logo view to the top (not in the navigation bar title in order to position it better).
        logoView = UIImageView(frame: CGRectMake(0, 0, 40, 40))
        logoView.image = UIImage(named: "Logo")?.imageWithRenderingMode(.AlwaysTemplate)
        logoView.tintColor = UIColor.cannonballGreenColor()
        logoView.frame.origin.x = (self.view.frame.size.width - logoView.frame.size.width) / 2
        logoView.frame.origin.y = -logoView.frame.size.height - 10
        self.navigationController?.view.addSubview(logoView)
        self.navigationController?.view.bringSubviewToFront(logoView)
        let logoTapRecognizer = UITapGestureRecognizer(target: self, action: Selector("logoTapped"))
        logoView.userInteractionEnabled = true
        logoView.addGestureRecognizer(logoTapRecognizer)

        // Prevent vertical bouncing.
        self.tableView.alwaysBounceVertical = false

        // Add a table header and computer the cell height so they perfectly fit the screen.
        let headerHeight: CGFloat = 20
        let contentHeight = self.view.frame.size.height - headerHeight
        let navHeight = self.navigationController?.navigationBar.frame.height
        let navYOrigin = self.navigationController?.navigationBar.frame.origin.y
        self.tableView.tableHeaderView = UIView(frame: CGRectMake(0, 0, self.tableView.bounds.size.width, headerHeight))

        // Compute the perfect table cell height to fit the content.
        let themeTableCellHeight = (contentHeight - navHeight! - navYOrigin!) / CGFloat(themes.count)
        self.tableView.rowHeight = themeTableCellHeight

        // Customize the navigation bar.
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.cannonballGreenColor()]
        self.navigationController?.navigationBar.titleTextAttributes = titleDict
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.topItem?.title = ""
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Animate the logo when the view appears.
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .CurveEaseInOut, animations: { () -> Void in
            // Place the frame at the correct origin position.
            self.logoView.frame.origin.y = 8
        }, completion: nil)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Make sure the navigation bar is translucent.
        self.navigationController?.navigationBar.translucent = true
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        // Move the logo view off screen if a new controller was pushed.
        if self.navigationController?.viewControllers.count > 1 {
            UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .CurveEaseInOut, animations: { () -> Void in
                // Place the frame at the correct origin position.
                self.logoView.frame.origin.y = -self.logoView.frame.size.height - 10
            }, completion: nil)
        }
    }

    // MARK: UIStoryboardSegue Handling

    // Pass the selected theme to the poem composer.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender!.isKindOfClass(ThemeCell) {
            let indexPath = self.tableView.indexPathForSelectedRow()
            if let row = indexPath?.row {
                let poemComposerViewController = segue.destinationViewController as PoemComposerViewController
                poemComposerViewController.theme = self.themes[row]
            }
        }
    }

    // Bring the about view when tapping the logo.
    func logoTapped() {
        self.performSegueWithIdentifier("ShowAbout", sender: self)
    }

    // MARK: UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return themes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(themeTableCellReuseIdentifier, forIndexPath: indexPath) as ThemeCell

        // Find the corresponding theme.
        let theme = themes[indexPath.row]

        // Configure the cell with the theme.
        cell.configureWithTheme(theme)

        // Return the theme cell.
        return cell
    }

}
