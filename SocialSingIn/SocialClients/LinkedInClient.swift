//
//  LinkedInClient.swift
//  SocialSingIn
//
//  Created by Павел Привалов on 7/3/18.
//  Copyright © 2018 Павел Привалов. All rights reserved.
//

import UIKit
import LinkedinSwift
import IOSLinkedInAPIFix

fileprivate let LINKEDIN_URL = "linkedin://"
fileprivate let LINKEDIN_ID = "86329tb36n3jl3"
fileprivate let LINKEDIN_SECRET = "1Om5IdYr0vqCfO7S"
fileprivate let LINKEDIN_REQUEST_URL = "https://api.linkedin.com/v1/people/~:(first-name,last-name,email-address)?format=json"

class LinkedInClient: SocialClient {
	
	private var firstName: String?
	private var lastName: String?
	private var email: String?
	private var tokenString: String?
	private var result: ((SocialUser?, String?, Error?) -> ())?;
	
	enum LinkedInPermissions {
		static let profile = "r_basicprofile"
		static let email = "r_emailaddress"
	}
	
	private var linkedinHelper: LinkedinSwiftHelper
	
	static let shared: SocialClient = LinkedInClient();
	
	private init() {
		let configurations = LinkedinSwiftConfiguration(clientId: LINKEDIN_ID, clientSecret: LINKEDIN_SECRET, state: nil, permissions: [LinkedInPermissions.profile, LinkedInPermissions.email], redirectUrl: "https://google.com")
		linkedinHelper = LinkedinSwiftHelper(configuration: configurations!)
	}
	
	var currentUser: SocialUser? {
		get {
			return self.firstName == nil && self.lastName == nil && self.email == nil ? nil : SocialUser(firstName: self.firstName, lastName: self.lastName, email: self.email)
		}
	}
	
	private func getProfileData() {
		if self.token != nil {
			linkedinHelper.requestURL(LINKEDIN_REQUEST_URL, requestType: LinkedinSwiftRequestGet, success: { (response) in
				self.firstName = response.jsonObject["firstName"] as? String
				self.lastName = response.jsonObject["lastName"] as? String
				self.email = response.jsonObject["emailAddress"] as? String
				print(response.jsonObject)
				DispatchQueue.main.async {
					self.result?(self.currentUser, self.token, nil)
				}
				print(response)
			}) { (error) in
				DispatchQueue.main.async {
					self.result?(nil, nil, error)
				}
				print("linkedIn get user error: \(error)")
			}
		}
	}
	
	var token: String? {
		get {
			return tokenString
		}
	}
	
	func signIn(parentViewController: UIViewController, result: @escaping (SocialUser?, String?, Error?) -> ()) {
		linkedinHelper.authorizeSuccess({ (token) in
			self.result = result
			self.tokenString = token.accessToken
			self.getProfileData()
		}, error: { (error) in
			result(nil, nil, error)
			print("login error: \(error.localizedDescription)")
		}) {
			print("user cancel login")
		}
	}
	
	func signOut() {
		linkedinHelper.logout()
		self.tokenString = nil
		self.firstName = nil
		self.lastName = nil
		self.email = nil
	}
	
	func isCanSignIn() -> Bool {
		guard let url = URL(string: LINKEDIN_URL) else {
			return false;
		}
		return UIApplication.shared.canOpenURL(url);
	}

	func applicationLogin(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
		if LinkedinSwiftHelper.shouldHandle(url) {
			return LinkedinSwiftHelper.application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
		}
		return true
	}
}
