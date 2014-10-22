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

class ThemeCell: UITableViewCell {

    // MARK: Properties

    @IBOutlet private weak var nameLabel: UILabel!

    @IBOutlet private weak var pictureImageView: UIImageView!

    private var gradient: CAGradientLayer!

    override func awakeFromNib() {
        // Add the gradient to the picture image view.
        gradient = CAGradientLayer()
        let colors: [AnyObject] = [UIColor.clearColor().CGColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).CGColor]
        gradient.frame = pictureImageView.frame
        gradient.colors = colors
        gradient.startPoint = CGPointMake(0.0, 0.4)
        gradient.endPoint = CGPointMake(0.0, 1.0)
        pictureImageView.layer.addSublayer(gradient)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradient.frame = pictureImageView.frame
    }

    func configureWithTheme(theme: Theme) {
        // Add category name.
        nameLabel.text = "#\(theme.name)"

        // Add background picture.
        pictureImageView.image = UIImage(named: theme.getRandomPicture()!)
    }

}
