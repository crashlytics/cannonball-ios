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

import TwitterKit

enum PoemTweetsResult {
    case Tweets([TWTRTweet])
    case Error(NSError)
}

private let TwitterAPISearchURL = "https://api.twitter.com/1.1/search/tweets.json"
private let PoemSearchQuery = "#cannonballapp AND pic.twitter.com AND (#adventure OR #romance OR #nature OR #mystery)"

extension TWTRAPIClient {

    // Search for poems on Twitter.
    func searchPoemTweets(completion: PoemTweetsResult -> ()) {
        // Login as a guest on Twitter to search Tweets.
        Twitter.sharedInstance().logInGuestWithCompletion { (session: TWTRGuestSession!, error: NSError!) -> Void in

            // Setup a Dictionary to store the parameters of the request.
            var parameters = Dictionary<String, String>()
            parameters["q"] = PoemSearchQuery
            parameters["count"] = "50"

            // Prepare the Twitter API request.
            var maybeError: NSError?
            var request = self.URLRequestWithMethod("GET", URL: TwitterAPISearchURL, parameters: parameters, error: &maybeError)

            if let error = maybeError {
                completion(.Error(error))
                return
            }

            // Perform the Twitter API request.
            self.sendTwitterRequest(request, completion: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                if error != nil {
                    completion(.Error(error))
                    return
                }

                let poemSearchResult = tweetsFromJSONData(data)

                completion(poemSearchResult)
            })
        }
    }

}

private func tweetsFromJSONData(jsonData: NSData) -> PoemTweetsResult {
    // Parse the JSON response.
    var maybeJSONError: NSError?
    let jsonData: AnyObject? = NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions(0), error: &maybeJSONError)

    // Check for parsing errors.
    if let JSONError = maybeJSONError {
        return PoemTweetsResult.Error(JSONError)
    } else {
        // Make the JSON data a dictionary.
        let jsonDictionary = jsonData as [String:AnyObject]

        // Extract the Tweets and create Tweet objects from the JSON data.
        let jsonTweets = jsonDictionary["statuses"] as NSArray
        let tweets = TWTRTweet.tweetsWithJSONArray(jsonTweets) as [TWTRTweet]

        return .Tweets(tweets)
    }
}
