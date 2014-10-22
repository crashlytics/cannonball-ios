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
import XCTest

class PoemPersistenceTests: XCTestCase {

    let poemPersistence = PoemPersistence.sharedInstance

    override func setUp() {
        super.setUp()

        poemPersistence.overwritePoems([])
    }

    // Tests overwritePoems method.

    func testNoPoems() {
        var poem = Poem(words: ["Test test test", "test"], picture: "falseURL", theme: "Romance", date: NSDate())
        poemPersistence.persistPoem(poem)
        poemPersistence.overwritePoems([])
        var poems: [Poem] = poemPersistence.retrievePoems()
        XCTAssertEqual(poems, [])
    }

    // Tests persistPoem as well as retrievePoems.
    func testPersistPoem() {
        var poem = Poem(words: ["Test test test", "test"], picture: "falseURL", theme: "Romance", date: NSDate())
        poemPersistence.persistPoem(poem)
        var poems: [Poem] = poemPersistence.retrievePoems()
        XCTAssertNotNil(poems, "Poem not persisted")
        XCTAssertEqual(poems[0], poem);
    }

}
