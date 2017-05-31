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

import Foundation

open class Poem: NSObject, NSCoding {

    // MARK: Types

    // String constants used to archive the stored properties of a poem.
    fileprivate struct SerializationKeys {
        static let words = "words"
        static let picture = "picture"
        static let theme = "theme"
        static let date = "date"
        static let uuid = "uuid"
    }

    // The words composing a poem.
    open var words: [String] = []

    // The picture used as a background of a poem.
    open var picture: String = ""

    // The theme name of the poem.
    open var theme: String = ""

    // The date a poem is completed.
    open var date = Date()

    // An underlying identifier for each poem.
    open fileprivate(set) var UUID = Foundation.UUID()

    // MARK: Initialization

    override init() {
        super.init()
    }

    // Initialize a Poem instance will all its properties, including a UUID.
    fileprivate init(words: [String], picture: String, theme: String, date: Date, UUID: Foundation.UUID) {
        self.words = words
        self.picture = picture
        self.theme = theme
        self.date = date
        self.UUID = UUID
    }

    // Initialize a Poem instance with all its public properties.
    convenience init(words: [String], picture: String, theme: String, date: Date) {
        self.init(words: words, picture: picture, theme: theme, date: date, UUID: Foundation.UUID())
    }

    // Retrieve the poem words as one sentence.
    func getSentence() -> String {
        return words.joined(separator: " ")
    }

    // MARK: NSCoding

    required public init?(coder aDecoder: NSCoder) {
        words = aDecoder.decodeObject(forKey: SerializationKeys.words) as! [String]
        picture = aDecoder.decodeObject(forKey: SerializationKeys.picture) as! String
        theme = aDecoder.decodeObject(forKey: SerializationKeys.theme) as! String
        date = aDecoder.decodeObject(forKey: SerializationKeys.date) as! Date
        UUID = aDecoder.decodeObject(forKey: SerializationKeys.uuid) as! Foundation.UUID
    }

    open func encode(with aCoder: NSCoder) {
        aCoder.encode(words, forKey: SerializationKeys.words)
        aCoder.encode(picture, forKey: SerializationKeys.picture)
        aCoder.encode(theme, forKey: SerializationKeys.theme)
        aCoder.encode(date, forKey: SerializationKeys.date)
        aCoder.encode(UUID, forKey: SerializationKeys.uuid)
    }

    // MARK: Overrides

    // Two poems are equal only if their UUIDs match.
    override open func isEqual(_ object: Any?) -> Bool {
        if let poem = object as? Poem {
            return UUID == poem.UUID
        }

        return false
    }

}
