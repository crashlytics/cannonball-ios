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
import Crashlytics

class PoemComposerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ImageCarouselDataSource, CountdownViewDelegate {

    var theme: Theme! {
        didSet {
            // Randomize the order of pictures.
            themePictures = theme.pictures.sorted { (_, _) in arc4random() < arc4random() }
        }
    }

    // MARK: Properties

    fileprivate var poem: Poem

    fileprivate var themePictures: [String] = []

    fileprivate var bankWords: [String] = []

    fileprivate let countdownView: CountdownView

    fileprivate let wordCount = 20

    fileprivate let timeoutSeconds = 60

    @IBOutlet fileprivate weak var doneButton: UIBarButtonItem!

    @IBOutlet fileprivate weak var shuffleButton: UIButton!

    @IBOutlet fileprivate weak var bankCollectionView: UICollectionView!

    @IBOutlet fileprivate weak var poemCollectionView: UICollectionView!

    @IBOutlet fileprivate weak var poemHeightContraint: NSLayoutConstraint!

    @IBOutlet fileprivate weak var imageCarousel: ImageCarouselView!

    // MARK: IBActions

    @IBAction func shuffleWordBank() {
        refreshWordBank()
        bankCollectionView.reloadData()

        // Log Answers Custom Event.
        Answers.logCustomEvent(withName: "Shuffled Words", customAttributes: nil)
    }

    // MARK: View Life Cycle

    required init?(coder aDecoder: NSCoder) {
        countdownView = CountdownView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), countdownTime: timeoutSeconds)
        poem = Poem()
        super.init(coder: aDecoder)
        countdownView.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Trigger a first word bank refresh to retrieve a selection of words.
        bankCollectionView.clipsToBounds = false
        refreshWordBank()

        // Customize the navigation bar.
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationController?.navigationBar.isTranslucent = true

        // Add the countdown view.
        countdownView.frame.origin.x = (view.frame.size.width - countdownView.frame.size.width) / 2
        countdownView.frame.origin.y = -countdownView.frame.size.height - 10
        navigationController?.view.addSubview(countdownView)
        navigationController?.view.bringSubview(toFront: countdownView)

        countdownView.countdownTime = timeoutSeconds

        imageCarousel.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Make sure the navigation bar is translucent.
        navigationController?.navigationBar.isTranslucent = true

        // Animate the countdown to make it appear and start the timer when the view appears.
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions(),
            animations: {
                // Place the countdown frame at the correct origin position.
                self.countdownView.frame.origin.y = 10
            },
            completion: { finished in
                self.countdownView.start()
            }
        )
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if !(navigationController?.viewControllers)!.contains(self) {
            // Back was pressed because self is no longer in the navigation stack.
            // Log Answers Custom Event.
            Answers.logCustomEvent(withName: "Stopped Composing Poem",
                customAttributes: [
                    "Poem": poem.getSentence(),
                    "Theme": theme.name,
                    "Length": poem.words.count,
                    "Picture": themePictures[imageCarousel.currentImageIndex]
                ]
            )
        }

        countdownView.stop()

        // Animate the countdown off screen.
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions(),
            animations: {
                // Place the frame at the correct origin position.
                self.countdownView.frame.origin.y = -self.countdownView.frame.size.height - 10
            },
            completion: nil
        )
    }

    // MARK: UIStoryboardSegue Handling

    // Only perform the segue to the history if there is a composed poem.
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "ShowHistory" {
            return poem.words.count > 0
        }
        return true
    }

    // Prepare for the segue to the history.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Save the poem.
        savePoem()

        // Enhance Crashlytics reports with Advanced Custom Logging.
        CLSLogv("Finished Poem: %d words in theme %@ with picture %@.", getVaList([poem.words.count, poem.theme, poem.picture]))

        // Log Answers Custom Event.
        Answers.logCustomEvent(withName: "Finished Composing Poem",
            customAttributes: [
                "Poem": poem.getSentence(),
                "Theme": poem.theme,
                "Length": poem.words.count,
                "Picture": poem.picture
            ]
        )
    }

    // MARK: CountdownViewDelegate

    func countdownView(_ countdownView: CountdownView, didCountdownTo second: Int) {
        switch(second) {
        case 0:
            if poem.words.count > 0 {
                // Perform the segue to go the poem history.
                performSegue(withIdentifier: "ShowHistory", sender: countdownView)
            } else {
                // Go back to the theme chooser.
                _ = navigationController?.popViewController(animated: true)
            }
        case 10:
            // Change the color of Shuffle to red as well.
            shuffleButton.setTitleColor(UIColor(red: 238/255, green: 103/255, blue: 100/255, alpha: 1.0), for: UIControlState())
        default:
            break
        }
    }

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == bankCollectionView {
            return bankWords.count
        } else if collectionView == poemCollectionView {
            return poem.words.count
        }

        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PoemComposerWordCell", for: indexPath) as! PoemComposerWordCell

        cell.contentView.frame = cell.bounds
        cell.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

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
        cell.layer.borderColor = cell.word.textColor.cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 3

        // Add a subtle opacity to poem words for better readability on top of pictures.
        if collectionView == poemCollectionView {
            cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        }

        // Make sure the cell is not hidden.
        cell.isHidden = false

        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    // MARK: UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if collectionView == bankCollectionView {
            // A word in the bank has been tapped.

            // Fade out and hide the word in the bank.
            if let cell = collectionView.cellForItem(at: indexPath) {
                UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: UIViewAnimationOptions(),
                    animations: {
                        cell.alpha = 0
                    },
                    completion: { finished in
                        cell.isHidden = true
                    }
                )
            }

            // Add the word to the poem.
            let word = bankWords[indexPath.row]
            poem.words.append(word)

            // Display the word in the poem.
            displayWord(word, inCollectionView: poemCollectionView)

        } else if collectionView == poemCollectionView {
            // A word in the poem has been tapped.

            // Fade out then remove the word from the poem.
            if let cell = collectionView.cellForItem(at: indexPath) {
                UIView.animate(withDuration: 0.15,
                    animations: {
                        cell.alpha = 0
                    },
                    completion: { finished in
                        collectionView.performBatchUpdates({
                            collectionView.deleteItems(at: [indexPath])
                            },
                            completion: { _ in
                                self.resizePoemToFitContentSize()
                                cell.alpha = 1
                            }
                        )
                    }
                )
            }

            // Display the word back in the bank.
            let word = poem.words[indexPath.row]
            displayWord(word, inCollectionView: bankCollectionView)

            // Remove the word from the poem.
            poem.words.remove(at: indexPath.row)
        }

        // Update the tick icon state.
        navigationItem.rightBarButtonItem?.isEnabled = poem.words.count > 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var word = ""
        if collectionView == bankCollectionView {
            word = bankWords[indexPath.row]
        } else if collectionView == poemCollectionView {
            word = poem.words[indexPath.row]
        }
        return sizeForWord(word)
    }

    // MARK: UICollectionView Utilities

    func sizeForWord(_ word: String) -> CGSize {
        return CGSize(width: 18 + word.characters.count * 10, height: 32)
    }

    func resizePoemToFitContentSize() {
        UIView.animate(withDuration: 0.15, animations: {
            self.poemHeightContraint.constant = self.poemCollectionView.contentSize.height
            self.view.layoutIfNeeded()
        }) 
    }

    func savePoem() {
        // Save the poem current completion date.
        poem.date = Date()

        // Save the theme name for the poem.
        poem.theme = theme.name

        // Save the currently displayed picture.
        poem.picture = themePictures[imageCarousel.currentImageIndex]

        // Make the poem object persist.
        PoemPersistence.sharedInstance.persistPoem(poem)
    }

    func refreshWordBank() {
        bankWords = theme.getRandomWords(wordCount - poem.words.count) as [String]
    }

    func displayWord(_ word: String, inCollectionView collectionView: UICollectionView!) {

        if collectionView == bankCollectionView {

            // Look for the word in the word bank.
            for (index, bankWord) in bankWords.enumerated() {
                if word == bankWord {
                    // Find the corresponding cell in the collection view and unhide it.
                    if let cell = collectionView.cellForItem(at: IndexPath(item: index, section: 0)) {
                        if cell.isHidden {
                            // Unhide and animate the cell again.
                            cell.isHidden = false
                            UIView.animate(withDuration: 0.15, animations: {
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

            // Display the new word accordingly at the last position.
            let bankIndexPath = IndexPath(item: bankWords.count - 1, section: 0)
            collectionView.insertItems(at: [bankIndexPath])

        } else if collectionView == poemCollectionView {

            // Retrieve the index path of the last word of the poem.
            let poemIndexPath = IndexPath(item: poem.words.count - 1, section: 0)

            // Insert the cell for this word.
            collectionView.performBatchUpdates({
                collectionView.insertItems(at: [poemIndexPath])
                },
                completion: { _ in
                    self.resizePoemToFitContentSize()
                }
            )

            // Fade in so it appears more smoothly.
            if let cell = collectionView.cellForItem(at: poemIndexPath) {
                cell.alpha = 0
                UIView.animate(withDuration: 0.15, animations: {
                    cell.alpha = 1
                }) 
            }
        }
    }

    // MARK: ImageCarouselViewDelegate

    func numberOfImagesInImageCarousel(_ imageCarousel: ImageCarouselView) -> Int {
        return themePictures.count
    }

    func imageCarousel(_ imageCarousel: ImageCarouselView, imageAtIndex index: Int) -> UIImage {
        return UIImage(named: themePictures[index])!
    }

}
