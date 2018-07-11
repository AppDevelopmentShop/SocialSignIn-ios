//
//  TwitterClient.swift
//  SocialSingIn
//
//  Created by Павел Привалов on 7/2/18.
//  Copyright © 2018 Павел Привалов. All rights reserved.
//

import UIKit
import TwitterCore
import TwitterKit
import FHSTwitterEngine

fileprivate let TWITTER_CONSUMER_KEY = "ZHAF7OGWEjBAhj3xBMlmk2JxX"
fileprivate let TWITTER_CONSUMER_SECRET = "zJKfsjaWGp6ZdSC7D2yU23DziIw0OYjRDeQX0VTBcwHdZTPGwI"

class TwitterClient: NSObject, SocialClient {
	
	static let shared: SocialClient = TwitterClient()
	private var twitterEngine: FHSTwitterEngine
	
	var currentUser: SocialUser? {
		get {
			if !twitterEngine.isAuthorized() {
				return nil
			}
			
			var userFirstName: String?

			userFirstName = twitterEngine.authenticatedUsername

			return SocialUser(firstName: userFirstName, lastName: nil, email: nil)
		}
	}
	
	var token: String? {
		get {
			guard let token = twitterEngine.accessToken.key else {
				return nil
			}
			
			return token
		}
	}
	
	private var parentViewController: UIViewController?;
	
	private override init() {
		self.twitterEngine = FHSTwitterEngine.shared()
	}
	
	func signIn(parentViewController: UIViewController, result: @escaping (SocialUser?, String?, Error?) -> ()) {
		self.parentViewController = parentViewController;
		if !twitterEngine.isAuthorized() {
			twitterEngine.permanentlySetConsumerKey(TWITTER_CONSUMER_KEY, andSecret: TWITTER_CONSUMER_SECRET)
			let logginViewController = twitterEngine.loginController { (success) in
				if success {
					result(self.currentUser, self.token, nil)
				} else {
					result(nil, nil, nil)
				}
			} as UIViewController
			let nvc = UINavigationController()
			let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dissmissViewController))
			
			logginViewController.navigationItem.leftBarButtonItem = cancelButton
			nvc.pushViewController(logginViewController, animated: false)
			parentViewController.present(nvc, animated: true, completion: nil)
		}
	}
	
	@objc func dissmissViewController() {
		self.parentViewController?.presentedViewController?.dismiss(animated: true, completion: nil);
	}
	
	func signOut() {
		twitterEngine.clearConsumer()
	}
	
	func applicationLogin(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
		return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
	}
}
