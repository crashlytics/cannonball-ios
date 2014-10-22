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

public class Poem: NSObject, NSCoding {

    // MARK: Types

    // String constants used to archive the stored properties of a poem.
    private struct SerializationKeys {
        static let words = "words"
        static let picture = "picture"
        static let theme = "theme"
        static let date = "date"
        static let uuid = "uuid"
    }

    // The words composing a poem.
    public var words: [String] = []

    // The picture used as a background of a poem.
    public var picture: String = ""

    // The theme name of the poem.
    public var theme: String = ""

    // The date a poem is completed.
    public var date = NSDate()

    // An underlying identifier for each poem.
    public private(set) var UUID = NSUUID()

    // MARK: Initialization

    override init() {
        super.init()
    }

    // Initialize a Poem instance will all its properties, including a UUID.
    private init(words: [String], picture: String, theme: String, date: NSDate, UUID: NSUUID) {
        self.words = words
        self.picture = picture
        self.theme = theme
        self.date = date
        self.UUID = UUID
    }

    // Initialize a Poem instance with all its public properties.
    convenience init(words: [String], picture: String, theme: String, date: NSDate) {
        self.init(words: words, picture: picture, theme: theme, date: date, UUID: NSUUID())
    }

    // Retrieve the poem words as one sentence.
    func getSentence() -> String {
        return " ".join(words)
    }

    // MARK: NSCoding

    required public init(coder aDecoder: NSCoder) {
        words = aDecoder.decodeObjectForKey(SerializationKeys.words) as [String]
        picture = aDecoder.decodeObjectForKey(SerializationKeys.picture) as String
        theme = aDecoder.decodeObjectForKey(SerializationKeys.theme) as String
        date = aDecoder.decodeObjectForKey(SerializationKeys.date) as NSDate
        UUID = aDecoder.decodeObjectForKey(SerializationKeys.uuid) as NSUUID
    }

    public func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(words, forKey: SerializationKeys.words)
        aCoder.encodeObject(picture, forKey: SerializationKeys.picture)
        aCoder.encodeObject(theme, forKey: SerializationKeys.theme)
        aCoder.encodeObject(date, forKey: SerializationKeys.date)
        aCoder.encodeObject(UUID, forKey: SerializationKeys.uuid)
    }

    // MARK: Overrides

    // Two poems are equal only if their UUIDs match.
    override public func isEqual(object: AnyObject?) -> Bool {
        if let poem = object as? Poem {
            return UUID == poem.UUID
        }

        return false
    }

}
