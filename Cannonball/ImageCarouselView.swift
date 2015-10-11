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

protocol ImageCarouselDataSource: class {
    func numberOfImagesInImageCarousel(imageCarousel: ImageCarouselView) -> Int
    func imageCarousel(imageCarousel: ImageCarouselView, imageAtIndex index: Int) -> UIImage
}

class ImageCarouselView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    weak var delegate: ImageCarouselDataSource?

    func reloadData() {
        collectionView.reloadData()
    }

    private(set) var currentImageIndex: Int = 0

    // MARK: Private

    private var collectionViewLayout: UICollectionViewFlowLayout!

    private var collectionView: UICollectionView!

    private let CellReuseID = "ImageCarouselCell"

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    required override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    private func commonInit() {
        collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .Horizontal
        collectionViewLayout.minimumInteritemSpacing = 0
        collectionViewLayout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: bounds, collectionViewLayout: collectionViewLayout)
        collectionView.pagingEnabled = true

        collectionView.showsHorizontalScrollIndicator = false

        collectionView.registerClass(ImageCarouselCollectionViewCell.self, forCellWithReuseIdentifier: CellReuseID)

        collectionView.dataSource = self
        collectionView.delegate = self

        addSubview(collectionView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        collectionView.frame = bounds
        collectionView.backgroundColor = UIColor.cannonballBeigeColor()

        collectionViewLayout.itemSize = bounds.size
    }

    // MARK: UICollectionView

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return delegate?.numberOfImagesInImageCarousel(self) ?? 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        precondition(delegate != nil, "Delegate should be set by now")

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellReuseID, forIndexPath: indexPath) as! ImageCarouselCollectionViewCell

        cell.image = delegate?.imageCarousel(self, imageAtIndex: indexPath.row)

        return cell
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // Update the currently displayed picture.
        // Note: indexPathsForVisibleItems() can return multiple items hence the calculation below for accuracy.
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect))
        let indexPath = collectionView.indexPathForItemAtPoint(visiblePoint)
        currentImageIndex = indexPath!.row
    }

}
