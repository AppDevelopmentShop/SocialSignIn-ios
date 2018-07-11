//
//  SocialClient.swift
//  CHILLEO
//
//  Created by Nikolay Khramchenko on 5/23/18.
//  Copyright © 2018 Nikolay Khramchenko. All rights reserved.
//

import UIKit

protocol SocialClient {        
    var currentUser: SocialUser? { get }
    var token: String? { get }
    
    func signIn(parentViewController: UIViewController, result: @escaping (_ user: SocialUser?, _ token: String?, _ error: Error?) -> ());
    func signOut();
	
	func isCanSignIn() -> Bool;
	func applicationLogin(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool
}

extension SocialClient {
	func isCanSignIn() -> Bool {
		return true;
	}
	
	func applicationLogin(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
		return true
	}
}

struct SocialUser {
    var firstName: String?;
    var lastName: String?;
    var email: String?;
}

