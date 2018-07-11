//
//  GoogleClient.swift
//  CHILLEO
//
//  Created by Nikolay Khramchenko on 5/23/18.
//  Copyright © 2018 Nikolay Khramchenko. All rights reserved.
//

import UIKit
import GoogleSignIn

fileprivate let GOOGLE_CLIENT_ID = "261150649882-90tto6q9eb2qoqv762qc0b2idn0ouq62.apps.googleusercontent.com";

class GoogleClient: NSObject, SocialClient {
    
    static let shared: SocialClient = GoogleClient();
    
    private enum Google {
        static let googleId: Int = -100;
        static let phoneNumber: String = "";
    }
    
    var currentUser: SocialUser? {
        get {
            if (GIDSignIn.sharedInstance().currentUser == nil) {
                return nil;
            }
            
            let firstName = GIDSignIn.sharedInstance().currentUser.profile.givenName;
            let lastName = GIDSignIn.sharedInstance().currentUser.profile.familyName;
            let email = GIDSignIn.sharedInstance().currentUser.profile.email;
            
            return SocialUser(firstName: firstName, lastName: lastName, email: email);
        }
    }
    
    var token: String? {
        get {
            if (GIDSignIn.sharedInstance().currentUser == nil) {
                return nil;
            }
            
            return GIDSignIn.sharedInstance().currentUser.authentication.idToken;
        }
    }
    
    private override init() {
        super.init();
        GIDSignIn.sharedInstance().delegate = self;
        GIDSignIn.sharedInstance().uiDelegate = self;
        GIDSignIn.sharedInstance().clientID = GOOGLE_CLIENT_ID;
    }
    
    private var parentViewController: UIViewController?;
    private var result: ((SocialUser?, String?, Error?) -> ())?;
    
    func signIn(parentViewController: UIViewController, result: @escaping (SocialUser?, String?, Error?) -> ()) {
        self.parentViewController = parentViewController;
        self.result = result;
        GIDSignIn.sharedInstance().signIn()
    }
    
    func signOut() {
        GIDSignIn.sharedInstance().signOut();
    }
    
}

extension GoogleClient: GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        self.result?(self.currentUser, self.token, error);
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.parentViewController?.present(viewController, animated: true, completion: nil);
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.parentViewController?.dismiss(animated: true, completion: nil);
    }
    
    
}
