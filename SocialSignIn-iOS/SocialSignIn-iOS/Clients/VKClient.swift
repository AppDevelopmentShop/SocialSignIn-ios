//
//  VKClient.swift
//  CHILLEO
//
//  Created by Nikolay Khramchenko on 5/23/18.
//  Copyright © 2018 Nikolay Khramchenko. All rights reserved.
//

import UIKit
import VK_ios_sdk

fileprivate let VK_APP_ID = "6622677";

class VKClient: NSObject, SocialClient {
    
    private enum VKPermissions {
        static let email = "email";
        static let friends = "friends";
    }
    
    static let shared: SocialClient = VKClient();
    
    var currentUser: SocialUser? {
        get {
            if (VKSdk.accessToken()?.localUser == nil) {
                return nil;
            }

            let firstName = VKSdk.accessToken().localUser.first_name;
            let lastName = VKSdk.accessToken().localUser.last_name;
            
            return SocialUser(firstName: firstName, lastName: lastName, email: nil);
        }
    }
    
    var token: String? {
        get {
            return VKSdk.accessToken()?.accessToken;
        }
    }
    
    private override init() {
        super.init();
        VKSdk.initialize(withAppId: VK_APP_ID);
        VKSdk.instance().register(self);
        VKSdk.instance().uiDelegate = self;
    }
    
    private var parentViewController: UIViewController?;
    private var result: ((SocialUser?, String?, Error?) -> ())?;
    
    func signIn(parentViewController: UIViewController, result: @escaping (SocialUser?, String?, Error?) -> ()) {
        self.parentViewController = parentViewController;
        self.result = result;
        VKSdk.authorize([VKPermissions.friends, VKPermissions.email]);
    }
    
    func signOut() {
        VKSdk.forceLogout();
    }
	
	func applicationLogin(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
		return VKSdk.processOpen(url, fromApplication: (options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String) ?? "")
	}
}

extension VKClient: VKSdkDelegate, VKSdkUIDelegate {
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
		
    }
    
    func vkSdkAuthorizationStateUpdated(with result: VKAuthorizationResult!) {
        self.result?(self.currentUser, self.token, result.error);
    }
    
    func vkSdkDidDismiss(_ controller: UIViewController!) {
        
    }
    
    func vkSdkTokenHasExpired(_ expiredToken: VKAccessToken!) {
		
    }
    
    func vkSdkAccessTokenUpdated(_ newToken: VKAccessToken!, oldToken: VKAccessToken!) {
        
    }
    
    func vkSdkUserAuthorizationFailed() {
        
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.parentViewController?.present(controller, animated: true, completion: nil);
    }
    
    func vkSdkWillDismiss(_ controller: UIViewController!) {

    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        
    }
    
}
