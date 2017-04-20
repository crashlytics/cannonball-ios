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
import QuartzCore
import Crashlytics

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
        logoView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        logoView.image = UIImage(named: "Logo")?.withRenderingMode(.alwaysTemplate)
        logoView.tintColor = UIColor.cannonballGreenColor()
        logoView.frame.origin.x = (view.frame.size.width - logoView.frame.size.width) / 2
        logoView.frame.origin.y = -logoView.frame.size.height - 10
        navigationController?.view.addSubview(logoView)
        navigationController?.view.bringSubview(toFront: logoView)
        let logoTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ThemeChooserViewController.logoTapped))
        logoView.isUserInteractionEnabled = true
        logoView.addGestureRecognizer(logoTapRecognizer)

        // Prevent vertical bouncing.
        tableView.alwaysBounceVertical = false

        // Add a table header and computer the cell height so they perfectly fit the screen.
        let headerHeight: CGFloat = 15
        let contentHeight = view.frame.size.height - headerHeight
        let navHeight = navigationController?.navigationBar.frame.height
        let navYOrigin = navigationController?.navigationBar.frame.origin.y
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: headerHeight))

        // Compute the perfect table cell height to fit the content.
        let themeTableCellHeight = (contentHeight - navHeight! - navYOrigin!) / CGFloat(themes.count)
        tableView.rowHeight = themeTableCellHeight

        // Customize the navigation bar.
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.cannonballGreenColor()]
        navigationController?.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.topItem?.title = ""
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Animate the logo when the view appears.
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions(),
            animations: {
                // Place the frame at the correct origin position.
                self.logoView.frame.origin.y = 8
            },
            completion: nil
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Make sure the navigation bar is translucent.
        navigationController?.navigationBar.isTranslucent = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Move the logo view off screen if a new controller was pushed.
        if let vcCount = navigationController?.viewControllers.count, vcCount > 1 {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions(),
                animations: {
                    // Place the frame at the correct origin position.
                    self.logoView.frame.origin.y = -self.logoView.frame.size.height - 10
                },
                completion: nil
            )
        }
    }

    // MARK: UIStoryboardSegue Handling

    // Pass the selected theme to the poem composer.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (sender! as AnyObject).isKind(of: ThemeCell.self) {
            let indexPath = tableView.indexPathForSelectedRow
            if let row = indexPath?.row {
                // Pass the selected theme to the poem composer.
                let poemComposerViewController = segue.destination as! PoemComposerViewController
                poemComposerViewController.theme = themes[row]

                // Tie this selected theme to any crashes in Crashlytics.
                Crashlytics.sharedInstance().setObjectValue(themes[row].name, forKey: "Theme")

                // Log Answers Custom Event.
                Answers.logCustomEvent(withName: "Selected Theme", customAttributes: ["Theme": themes[row].name])
            }
        }
    }

    // Bring the about view when tapping the logo.
    func logoTapped() {
        performSegue(withIdentifier: "ShowAbout", sender: self)
    }

    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return themes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: themeTableCellReuseIdentifier, for: indexPath) as! ThemeCell

        // Find the corresponding theme.
        let theme = themes[indexPath.row]

        // Configure the cell with the theme.
        cell.configureWithTheme(theme)

        // Return the theme cell.
        return cell
    }

}
