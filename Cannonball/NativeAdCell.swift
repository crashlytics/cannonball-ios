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
        adObject.loadTitleIntoLabel(self.titleLabel)
        adObject.loadTextIntoLabel(self.mainTextLabel)
        adObject.loadCallToActionTextIntoLabel(self.callToActionButton.titleLabel)
        adObject.loadImageIntoImageView(self.mainImageView)
        adObject.loadIconIntoImageView(self.iconImageView)

        // Decorate the call to action button.
        callToActionButton.layer.masksToBounds = false
        callToActionButton.layer.borderColor = callToActionButton.titleLabel?.textColor.CGColor
        callToActionButton.layer.borderWidth = 2
        callToActionButton.layer.cornerRadius = 6

        // Decorate the ad container.
        containerView.layer.cornerRadius = 6

        // Add the background color to the main view.
        self.backgroundColor = UIColor(red: 55/255, green: 31/255, blue: 31/255, alpha: 1.0)
    }

    class func sizeWithMaximumWidth(maximumWidth: CGFloat) -> CGSize {
        return CGSizeMake(maximumWidth, maximumWidth)
    }

    // Return the nib used for the native ad.
    class func nibForAd() -> UINib! {
        return UINib(nibName: "NativeAdCell", bundle: nil)
    }

}
