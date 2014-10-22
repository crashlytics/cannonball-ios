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

class PoemComposerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ImageCarouselDataSource, CountdownViewDelegate {

    var theme: Theme! {
        didSet {
            // Randomize the order of pictures.
            self.themePictures = theme.pictures.sorted { (_, _) in arc4random() < arc4random() }
        }
    }

    // MARK: Properties

    private var poem: Poem

    private var themePictures: [String] = []

    private var bankWords: [String] = []

    private let countdownView: CountdownView

    private let wordCount = 20

    private let timeoutSeconds = 60

    @IBOutlet private weak var doneButton: UIBarButtonItem!

    @IBOutlet private weak var shuffleButton: UIButton!

    @IBOutlet private weak var bankCollectionView: UICollectionView!

    @IBOutlet private weak var poemCollectionView: UICollectionView!

    @IBOutlet private weak var poemHeightContraint: NSLayoutConstraint!

    @IBOutlet private weak var imageCarousel: ImageCarouselView!

    // MARK: IBActions

    @IBAction func shuffleWordBank() {
        refreshWordBank()
        bankCollectionView.reloadData()
    }

    // MARK: View Life Cycle

    required init(coder aDecoder: NSCoder) {
        self.countdownView = CountdownView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), countdownTime: timeoutSeconds)
        self.poem = Poem()
        super.init(coder: aDecoder)
        self.countdownView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Trigger a first word bank refresh to retrieve a selection of words.
        bankCollectionView.clipsToBounds = false
        refreshWordBank()

        // Customize the navigation bar.
        self.navigationItem.rightBarButtonItem?.enabled = false
        self.navigationController?.navigationBar.translucent = true

        // Add the countdown view.
        countdownView.frame.origin.x = (self.view.frame.size.width - countdownView.frame.size.width) / 2
        countdownView.frame.origin.y = -countdownView.frame.size.height - 10
        self.navigationController?.view.addSubview(countdownView)
        self.navigationController?.view.bringSubviewToFront(countdownView)

        countdownView.countdownTime = timeoutSeconds

        imageCarousel.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Make sure the navigation bar is translucent.
        self.navigationController?.navigationBar.translucent = true

        // Animate the countdown to make it appear and start the timer when the view appears.
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .CurveEaseInOut, animations: { () -> Void in
            // Place the countdown frame at the correct origin position.
            self.countdownView.frame.origin.y = 10
            }) { (finished) -> Void in
                self.countdownView.start()
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        self.countdownView.stop()

        // Animate the countdown off screen.
        UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .CurveEaseInOut, animations: { () -> Void in
            // Place the frame at the correct origin position.
            self.countdownView.frame.origin.y = -self.countdownView.frame.size.height - 10
            }, completion: nil)
    }

    // MARK: UIStoryboardSegue Handling

    // Only perform the segue to the history if there is a composed poem.
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "ShowHistory" {
            return poem.words.count > 0
        }
        return true
    }

    // Prepare for the segue to the history.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Save the poem.
        savePoem()
    }

    // MARK: CountdownViewDelegate

    func countdownView(countdownView: CountdownView, didCountdownTo second: Int) {
        switch(second) {
        case 0:
            if poem.words.count > 0 {
                // Perform the segue to go the poem history.
                self.performSegueWithIdentifier("ShowHistory", sender: self.countdownView)
            } else {
                // Go back to the theme chooser.
                self.navigationController?.popViewControllerAnimated(true)
            }
        case 10:
            // Change the color of Shuffle to red as well.
            shuffleButton.setTitleColor(UIColor(red: 238/255, green: 103/255, blue: 100/255, alpha: 1.0), forState: .Normal)
        default:
            break
        }
    }

    // MARK: UICollectionViewDataSource

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bankCollectionView {
            return bankWords.count
        } else if collectionView == poemCollectionView {
            return poem.words.count
        }

        return 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PoemComposerWordCell", forIndexPath: indexPath) as PoemComposerWordCell

        cell.contentView.frame = cell.bounds
        cell.contentView.autoresizingMask = .FlexibleWidth | .FlexibleHeight

        var word = ""
        if collectionView == bankCollectionView {
            word = bankWords[indexPath.row]
        } else if collectionView == poemCollectionView {
            word = poem.words[indexPath.row]
        }

        // Inject the word in the cell.
        cell.word.text = word
        cell.word.frame = cell.bounds

        // Draw the border using the same color as the word.
        cell.layer.masksToBounds = false
        cell.layer.borderColor = cell.word.textColor.CGColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 3

        // Add a subtle opacity to poem words for better readability on top of pictures.
        if collectionView == poemCollectionView {
            cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        }

        // Make sure the cell is not hidden.
        cell.hidden = false

        return cell
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView!) -> Int {
        return 1
    }

    // MARK: UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // A word in the bank has been tapped.
        if collectionView == bankCollectionView {
            // Fade out and hide the word in the bank.
            if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
                UIView.animateWithDuration(0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .CurveEaseInOut, animations: { () -> Void in
                    cell.alpha = 0
                }) { (finished) -> Void in
                    cell.hidden = true
                }
            }
            // Add the word to the poem.
            let word = bankWords[indexPath.row]
            poem.words.append(word)
            // Display the word in the poem.
            displayWord(word, inCollectionView: poemCollectionView)
            // A word in the poem has been tapped.
        } else if collectionView == poemCollectionView {
            // Fade out then remove the word from the poem.
            if let cell = collectionView.cellForItemAtIndexPath(indexPath) {
                UIView.animateWithDuration(0.15, animations: { () -> Void in
                    cell.alpha = 0
                }) { (finished) -> Void in
                    collectionView.performBatchUpdates({
                        collectionView.deleteItemsAtIndexPaths([indexPath])
                    }, completion: { _ in
                        self.resizePoemToFitContentSize()
                        cell.alpha = 1
                    })
                }
            }
            // Display the word back in the bank.
            let word = poem.words[indexPath.row]
            displayWord(word, inCollectionView: bankCollectionView)
            // Remove the word from the poem.
            poem.words.removeAtIndex(indexPath.row)
        }

        // Update the tick icon state.
        self.navigationItem.rightBarButtonItem?.enabled = poem.words.count > 0
    }

    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var word = ""
        if collectionView == bankCollectionView {
            word = bankWords[indexPath.row]
        } else if collectionView == poemCollectionView {
            word = poem.words[indexPath.row]
        }
        return sizeForWord(word)
    }

    // MARK: UICollectionView Utilities

    func sizeForWord(word: String) -> CGSize {
        return CGSize(width: 18 + countElements(word) * 10, height: 32)
    }

    func resizePoemToFitContentSize() {
        UIView.animateWithDuration(0.15, animations: { () -> Void in
            self.poemHeightContraint.constant = self.poemCollectionView.contentSize.height
            self.view.layoutIfNeeded()
        })
    }

    func savePoem() {
        // Save the poem current completion date.
        poem.date = NSDate()

        // Save the theme name for the poem.
        poem.theme = theme.name

        // Save the currently displayed picture.
        poem.picture = self.themePictures[self.imageCarousel.currentImageIndex]

        PoemPersistence.sharedInstance.persistPoem(self.poem)
    }

    func refreshWordBank() {
        bankWords = theme.getRandomWords(wordCount - poem.words.count) as [String]
    }

    func displayWord(word: String, inCollectionView collectionView: UICollectionView!) {
        if collectionView == bankCollectionView {
            for (index, bankWord) in enumerate(bankWords) {
                // Look for the word in the word bank.
                if word == bankWord {
                    // Find the corresponding cell in the collection view and unhide it.
                    if let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) {
                        if cell.hidden {
                            // Unhide and animate the cell again.
                            cell.hidden = false
                            UIView.animateWithDuration(0.15, animations: { () -> Void in
                                cell.alpha = 1
                            })
                            // Return since we found it.
                            return
                        }
                    }
                }
            }
            // The word has not been found because a shuffle likely happened, so append it again.
            bankWords.append(word)
            collectionView.reloadData()
        } else if collectionView == poemCollectionView {
            // Retrieve the index path of the last word of the poem.
            let poemIndexPath = NSIndexPath(forItem: poem.words.count - 1, inSection: 0)

            // Insert the cell for this word.
            collectionView.performBatchUpdates({
                collectionView.insertItemsAtIndexPaths([poemIndexPath])
            }, completion: { _ in
                self.resizePoemToFitContentSize()
            })

            // Fade in so it appears more smoothly.
            if let cell = collectionView.cellForItemAtIndexPath(poemIndexPath) {
                cell.alpha = 0
                UIView.animateWithDuration(0.15, animations: { () -> Void in
                    cell.alpha = 1
                })
            }
        }
    }

    // MARK: ImageCarouselViewDelegate

    func numberOfImagesInImageCarousel(imageCarousel: ImageCarouselView) -> Int {
        return countElements(self.themePictures)
    }

    func imageCarousel(imageCarousel: ImageCarouselView, imageAtIndex index: Int) -> UIImage {
        return UIImage(named: self.themePictures[index])!
    }

}
