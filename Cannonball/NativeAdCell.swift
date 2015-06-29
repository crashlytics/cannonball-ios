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
import MoPub

class NativeAdCell: UITableViewCell, MPNativeAdRendering {

    // MARK: Properties

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var mainTextLabel: UILabel!

    @IBOutlet weak var callToActionButton: UIButton!

    @IBOutlet weak var mainImageView: UIImageView!

    @IBOutlet weak var iconImageView: UIImageView!

    @IBOutlet weak var containerView: UIView!

    func layoutAdAssets(adObject: MPNativeAd!) {
        // Load ad assets.
        adObject.loadTitleIntoLabel(titleLabel)
        adObject.loadTextIntoLabel(mainTextLabel)
        adObject.loadCallToActionTextIntoLabel(callToActionButton.titleLabel)
        adObject.loadImageIntoImageView(mainImageView)
        adObject.loadIconIntoImageView(iconImageView)

        // Decorate the call to action button.
        callToActionButton.layer.masksToBounds = false
        callToActionButton.layer.borderColor = callToActionButton.titleLabel?.textColor.CGColor
        callToActionButton.layer.borderWidth = 2
        callToActionButton.layer.cornerRadius = 6

        // Decorate the ad container.
        containerView.layer.cornerRadius = 6

        // Add the background color to the main view.
        backgroundColor = UIColor.cannonballBrownColor()
    }

    class func sizeWithMaximumWidth(maximumWidth: CGFloat) -> CGSize {
        return CGSizeMake(maximumWidth, maximumWidth)
    }

    // Return the nib used for the native ad.
    class func nibForAd() -> UINib! {
        return UINib(nibName: "NativeAdCell", bundle: nil)
    }

}
