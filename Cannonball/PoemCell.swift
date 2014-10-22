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

protocol PoemCellDelegate : class {

    func poemCellWantsToSharePoem(poemCell: PoemCell)

}

class PoemCell: UITableViewCell {

    // MARK: Properties

    weak var delegate: PoemCellDelegate?

    @IBOutlet private weak var pictureImageView: UIImageView!

    @IBOutlet private weak var themeLabel: UILabel!

    @IBOutlet private weak var poemLabel: UILabel!

    @IBOutlet private weak var shareButton: UIButton!

    private var gradient: CAGradientLayer!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Create gradient.
        gradient = CAGradientLayer()
        let colors: [AnyObject] = [UIColor.clearColor().CGColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).CGColor]
        gradient.colors = colors
        gradient.startPoint = CGPointMake(0.0, 0.4)
        gradient.endPoint = CGPointMake(0.0, 1.0)

        // Add gradient to ImageView.
        self.pictureImageView.layer.addSublayer(gradient)

        // Add share button target.
        self.shareButton.addTarget(self, action: Selector("shareButtonTapped"), forControlEvents: .TouchUpInside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        gradient.frame = pictureImageView.frame
    }

    func configureWithPoem(poem: Poem) {
        themeLabel.text = "#\(poem.theme)"
        poemLabel.text = poem.getSentence()
        pictureImageView.image = UIImage(named: poem.picture)
    }

    func capturePoemImage() -> UIImage {
        // Hide the share button.
        shareButton.hidden = true

        // Capture a PNG of the view.
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        self.layer.renderInContext(UIGraphicsGetCurrentContext())
        var containerViewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Show the share button.
        shareButton.hidden = false

        return containerViewImage
    }

    func shareButtonTapped() {
        delegate?.poemCellWantsToSharePoem(self)
    }

}
