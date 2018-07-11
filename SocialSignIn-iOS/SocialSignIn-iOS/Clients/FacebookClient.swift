//
//  FacebookClient.swift
//  CHILLEO
//
//  Created by Nikolay Khramchenko on 5/23/18.
//  Copyright © 2018 Nikolay Khramchenko. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class FacebookClient: SocialClient {
    
    private enum FacebookPermissions {
        static let email = "email";
        static let user_friends = "user_friends";
        static let user_gender = "user_gender";
        static let user_birthday = "user_birthday";
    }
    
    static let shared: SocialClient = FacebookClient();
    
    private var facebookLoginManager: FBSDKLoginManager;
    
    var currentUser: SocialUser? {
        get {
            if (FBSDKProfile.current() == nil) {
                return nil;
            }
            
            let firstName = FBSDKProfile.current().firstName;
            let lastName = FBSDKProfile.current().lastName;
            
            return SocialUser(firstName: firstName, lastName: lastName, email: nil);
        }
    }
    
    var token: String? {
        get {
            return FBSDKAccessToken.current()?.tokenString;
        }
    }
    
    private init() {
        self.facebookLoginManager = FBSDKLoginManager();
    }
    
    func signIn(parentViewController: UIViewController, result: @escaping (SocialUser?, String?, Error?) -> ()) {
        self.facebookLoginManager.logIn(withReadPermissions: [FacebookPermissions.email, FacebookPermissions.user_friends, FacebookPermissions.user_gender, FacebookPermissions.user_birthday], from: parentViewController) { (loginResult, error) in
            if (error  == nil) {
                FBSDKProfile.loadCurrentProfile(completion: { (profile, error) in
                    result(self.currentUser, self.token, error);
                });
            } else {
                result(self.currentUser, self.token, error);
            }
        }
    }
    
    func signOut() {
        self.facebookLoginManager.logOut();
    }
    
	func applicationLogin(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
		return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options);
	}
}
