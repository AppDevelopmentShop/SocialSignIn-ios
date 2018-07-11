	//
//  AppDelegate.swift
//  SocialSingIn
//
//  Created by Павел Привалов on 7/2/18.
//  Copyright © 2018 Павел Привалов. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		return true
	}
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
		let facebook = FacebookClient.shared.applicationLogin(app, open: url, options: options)
		let twitter = TwitterClient.shared.applicationLogin(app, open: url, options: options)
		let linkedIn = LinkedInClient.shared.applicationLogin(app, open: url, options: options)
		let vk = VKClient.shared.applicationLogin(app, open: url, options: options)
		
		return facebook || twitter || linkedIn || vk
	}
	
	
}

