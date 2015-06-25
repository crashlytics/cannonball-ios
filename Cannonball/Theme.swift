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

public class Theme {

    let name: String

    let words: [String]

    let pictures: [String]

    init?(jsonDictionary: [String: AnyObject]) {
        if let optionalName = jsonDictionary["name"] as? String,
           let optionalWords = jsonDictionary["words"] as? [String],
           let optionalPictures = jsonDictionary["pictures"] as? [String]
        {
            self.name = optionalName
            self.words = optionalWords
            self.pictures = optionalPictures
        } else {
            self.name = ""
            self.words = []
            self.pictures = []
            return nil
        }
    }

    public func getRandomWords(wordCount: Int) -> [String] {
        var words = [String](self.words)

        // Sort randomly the elements of the dictionary.
        sort(&words, { (_,_) in return arc4random() < arc4random() })

        // Return the desired number of words.
        return Array(words[0..<wordCount])
    }

    public func getRandomPicture() -> String? {
        var pictures = [String](self.pictures)

        // Sort randomly the pictures.
        sort(&pictures, { (_,_) in return arc4random() < arc4random() })

        // Return the first picture.
        return pictures.first
    }

    class func getThemes() -> [Theme] {
        var themes = [Theme]()
        let path = NSBundle.mainBundle().pathForResource("Themes", ofType: "json")!
        if let jsonData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil),
           let jsonArray = NSJSONSerialization.JSONObjectWithData(jsonData, options: nil, error: nil) as? [AnyObject] {
            themes = jsonArray.flatMap() {
                let theme = Theme(jsonDictionary: $0 as! [String:AnyObject])
                return theme != nil ? [theme!] : []
            }
        }
        return themes
    }

}
