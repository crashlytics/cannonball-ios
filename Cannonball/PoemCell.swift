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

protocol PoemCellDelegate : class {

    func poemCellWantsToSharePoem(_ poemCell: PoemCell)

}

class PoemCell: UITableViewCell {

    // MARK: Properties

    weak var delegate: PoemCellDelegate?

    @IBOutlet fileprivate weak var pictureImageView: UIImageView!

    @IBOutlet fileprivate weak var themeLabel: UILabel!

    @IBOutlet fileprivate weak var poemLabel: UILabel!

    @IBOutlet fileprivate weak var shareButton: UIButton!

    fileprivate var gradient: CAGradientLayer!

    override func awakeFromNib() {
        super.awakeFromNib()

        // Create gradient.
        gradient = CAGradientLayer()
        let colors: [AnyObject] = [UIColor.clear.cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.4).cgColor]
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 0.0, y: 0.4)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)

        // Add gradient to ImageView.
        pictureImageView.layer.addSublayer(gradient)

        // Add share button target.
        shareButton.addTarget(self, action: #selector(PoemCell.shareButtonTapped), for: .touchUpInside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
    }

    func configureWithPoem(_ poem: Poem) {
        themeLabel.text = "#\(poem.theme)"
        poemLabel.text = poem.getSentence()
        pictureImageView.image = UIImage(named: poem.picture)
    }

    func capturePoemImage() -> UIImage {
        // Hide the share button.
        shareButton.isHidden = true

        // Capture a PNG of the view.
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let containerViewImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // Show the share button.
        shareButton.isHidden = false

        return containerViewImage!
    }

    func shareButtonTapped() {
        delegate?.poemCellWantsToSharePoem(self)
    }

}
