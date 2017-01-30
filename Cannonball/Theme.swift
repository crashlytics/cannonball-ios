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

import Foundation

open class Theme {

    let name: String

    let words: [String]

    let pictures: [String]

    init?(jsonDictionary: [String : AnyObject]) {
        if let optionalName = jsonDictionary["name"] as? String,
           let optionalWords = jsonDictionary["words"] as? [String],
           let optionalPictures = jsonDictionary["pictures"] as? [String]
        {
            name = optionalName
            words = optionalWords
            pictures = optionalPictures
        } else {
            name = ""
            words = []
            pictures = []
            return nil
        }
    }

    open func getRandomWords(_ wordCount: Int) -> [String] {
        var wordsCopy = [String](words)

        // Sort randomly the elements of the dictionary.
        wordsCopy.sort(by: { (_,_) in return arc4random() < arc4random() })

        // Return the desired number of words.
        return Array(wordsCopy[0..<wordCount])
    }

    open func getRandomPicture() -> String? {
        var picturesCopy = [String](pictures)

        // Sort randomly the pictures.
        picturesCopy.sort(by: { (_,_) in return arc4random() < arc4random() })

        // Return the first picture.
        return picturesCopy.first
    }

    class func getThemes() -> [Theme] {
        var themes = [Theme]()
        let path = Bundle.main.path(forResource: "Themes", ofType: "json")!
        if let jsonData = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe),
           let jsonArray = (try? JSONSerialization.jsonObject(with: jsonData, options: [])) as? [AnyObject] {
            themes = jsonArray.flatMap() {
                return Theme(jsonDictionary: $0 as! [String : AnyObject])
            }
        }
        return themes
    }

}
