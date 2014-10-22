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

private let SingletonSharedInstance = PoemPersistence()

public class PoemPersistence {

    private let userDefaultsKey = "io.fabric.samples.cannonball.poems"

    class var sharedInstance : PoemPersistence {
        return SingletonSharedInstance
    }

    // MARK: Poem Persistence Utilities

    // Save a new poem.
    func persistPoem(poem: Poem) {
        // Retrieve the currently saved poems.
        let userDefaults = NSUserDefaults.standardUserDefaults()
        var poems: [Poem]
        if let poemsArchived: AnyObject = userDefaults.objectForKey(userDefaultsKey) {
            poems = NSKeyedUnarchiver.unarchiveObjectWithData(poemsArchived as NSData) as [Poem]
        } else {
            poems = []
        }

        // Append the newly created poem.
        poems.insert(poem, atIndex: 0)

        // Save the poems.
        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(poems), forKey: userDefaultsKey)
    }

    // Overwrite the poems.
    func overwritePoems(poems: [Poem]) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(NSKeyedArchiver.archivedDataWithRootObject(poems), forKey: userDefaultsKey)
    }

    // Retrieve the poems.
    func retrievePoems()  -> [Poem] {
        var poems: [Poem]
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let poemsArchived: AnyObject = userDefaults.objectForKey(userDefaultsKey) {
            poems = NSKeyedUnarchiver.unarchiveObjectWithData(poemsArchived as NSData) as [Poem]
        } else {
            poems = []
        }
        return poems
    }
    
}
