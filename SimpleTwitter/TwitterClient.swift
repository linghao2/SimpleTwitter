//
//  TwitterClient.swift
//  SimpleTwitter
//
//  Created by LING HAO on 4/13/17.
//  Copyright © 2017 CodePath. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "iJ6kM3R7kUyjgwFFJNmOdy9hH", consumerSecret: "qVu0Wo6R0Zvq4gVGtlGwjQwR52ewPhWUEJffi0QtzyRx0yd5Oa")
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?
    
    func login(success: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        loginSuccess = success
        loginFailure = failure
        
        deauthorize()
        fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string: "simpleTwitter://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            print("I got a token")
            
            if let token = requestToken?.token {
                let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
                UIApplication.shared.open(url, options: [:], completionHandler: { (success: Bool) in
                    print("open success!")
                })
            }
        }, failure: { (error:Error?) in
            self.loginFailure?(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: User.userDidLogout, object: nil)
    }
    
    func handleOpenUrl(_ url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (credential: BDBOAuth1Credential?) in
            print("got access token!")
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
        }, failure: { (error: Error?) in
            self.loginFailure?(error!)
        })

    }
    
    func userTimeline(screenName: String?, success: @escaping ([Tweet]) -> Void, failure: @escaping (Error) -> Void) {
        var parameter: [String: Any?]?
        if screenName != nil {
            parameter = ["screen_name": screenName]
        }
        get("1.1/statuses/user_timeline.json", parameters: parameter, progress: { (Progress) in
            print("progress")
        }, success: { (task: URLSessionDataTask, response: Any?) in
            //print("**user timeline response: \(response)")
            let tweets = Tweet.tweetsWithArray(dictionaries: response as! [Dictionary<String, Any?>])
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }

    
    func homeTimeline(success: @escaping ([Tweet]) -> Void, failure: @escaping (Error) -> Void) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: { (Progress) in
            print("progress")
        }, success: { (task: URLSessionDataTask, response: Any?) in
            //print("**timeline response: \(response)")
            let tweets = Tweet.tweetsWithArray(dictionaries: response as! [Dictionary<String, Any?>])
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func currentAccount(success: @escaping (User) -> Void, failure: @escaping (Error) -> Void) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: { (progress: Progress) in
            print("progress")
        }, success: { (task: URLSessionDataTask, response: Any?) in
            let user = User(dictionary: response as! Dictionary<String, Any?>)
            success(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func tweet(tweet: String!, success: @escaping (Tweet)->(), failure: @escaping (Error)->()) {
        post("1.1/statuses/update.json", parameters: ["status": tweet], progress: { (progress: Progress) in
            print("progress")
        }, success: { (task: URLSessionDataTask, response: Any?) in
            print("**tweet response: \(response)")
            let dictionary = response as! Dictionary<String, Any?>
            let tweet = Tweet(dictionary: dictionary)
            success(tweet)
        }) { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
    }
    
    func retweet(id: String!) {
        let url = "1.1/statuses/retweet/\(id!).json"
        post(url, parameters: nil, progress: { (progress: Progress) in
            print("progress")
        }, success: { (task: URLSessionDataTask, response: Any?) in
            print("**retweet response: \(response)")
        }) { (task: URLSessionDataTask?, error: Error) in
            print("retweet error \(error.localizedDescription)")
        }
    }
    
    func favorite(id: String!) {
        post("1.1/favorites/create.json", parameters: ["id": id], progress: { (progress: Progress) in
            print(progress)
        }, success: { (task: URLSessionDataTask, response: Any?) in
            print("**favorite response: \(response)")
        }) { (task: URLSessionDataTask?, error: Error) in
            print("retweet error \(error.localizedDescription)")
        }
    }
}

