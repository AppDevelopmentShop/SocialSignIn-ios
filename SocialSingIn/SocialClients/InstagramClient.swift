//
//  InstagramClient.swift
//  SocialSingIn
//
//  Created by Павел Привалов on 7/5/18.
//  Copyright © 2018 Павел Привалов. All rights reserved.
//

import UIKit
import InstagramLogin

fileprivate let INSTAGRAM_CLIENT_ID = "990a579b2dc246769bd1f9d8cb6101ad"
fileprivate let INSTAGRAM_CLIENT_SECRET = "c3426c68a37f4cd9b7c7a8ae54e4f758"
fileprivate let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
fileprivate let INSTAGRAM_APIURl = "https://api.instagram.com/v1/users/self/?access_token="
fileprivate let INSTAGRAM_REDIRECT_URI = "google.com"
fileprivate let INSTAGRAM_SCOPE = "basic+public_content"
fileprivate var INSTAGRAM_ACCESS_TOKEN: String?

fileprivate let APP_HEIGHT = UIScreen.main.bounds.height
fileprivate let APP_WIDTH = UIScreen.main.bounds.width

class InstagramClient: NSObject, SocialClient {
	
	private var loginViewController: UIViewController!
	private var loginWebView: UIWebView!
	private var nvc: UINavigationController!
	
	static var shared: SocialClient = InstagramClient()
	
	private var fullName: String?
	private var firstName: String?
	private var lastName: String?
	private var result: ((SocialUser?, String?, Error?) -> ())?;
	
	var currentUser: SocialUser? {
		get {
			return self.firstName == nil && self.lastName == nil ? nil : SocialUser(firstName: self.firstName, lastName: self.lastName, email: nil)
		}
	}
	
	private func getSessionData() {
		guard let url = URL(string: INSTAGRAM_APIURl + (INSTAGRAM_ACCESS_TOKEN ?? "")) else {
			return
		}
		let session = URLSession.shared
		
		session.dataTask(with: url) { (data, response, error) in
			guard let data = data else { return }
			
			do {
				guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {
					return
				}
				if let jsonData = json["data"] as? [String : Any] {
					self.fullName = jsonData["full_name"] as? String
					self.firstName = self.fullName?.split(separator: " ").first?.description
					self.lastName = self.fullName?.split(separator: " ").last?.description
					DispatchQueue.main.async {
						self.result?(self.currentUser, self.token, nil)
					}
				}
			} catch {
				print("get current user from insta error: \(error)")
				DispatchQueue.main.async {
					self.result?(self.currentUser, self.token, error)
				}
				return
			}
		}.resume()
	}
	
	var token: String? {
		get {
			return INSTAGRAM_ACCESS_TOKEN
		}
	}
	
	private override init() {
		super.init()
		
		createWebView()
	}
	
	private func createWebView() {
		self.nvc = UINavigationController()
		self.loginViewController = UIViewController()
		
		let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dissmissViewController))
		let navigationBarHeight = nvc.navigationBar.frame.height
		let statusBarHeight = UIApplication.shared.statusBarFrame.height
		let appTopDistance = navigationBarHeight + statusBarHeight
		
		self.loginWebView = UIWebView()
		loginViewController.view.addSubview(loginWebView)
		
		let trailingConstraint = NSLayoutConstraint(item: loginWebView, attribute: .trailing, relatedBy: .equal, toItem: loginViewController.view, attribute: .trailing, multiplier: 1, constant: 0)
		let leadingConstraint = NSLayoutConstraint(item: loginWebView, attribute: .leading, relatedBy: .equal, toItem: loginViewController.view, attribute: .leading, multiplier: 1, constant: 0)
		let topConstraint = NSLayoutConstraint(item: loginWebView, attribute: .top, relatedBy: .equal, toItem: loginViewController.view, attribute: .top, multiplier: 1, constant: appTopDistance)
		let bottomConstraint = NSLayoutConstraint(item: loginWebView, attribute: .bottom, relatedBy: .equal, toItem: loginViewController.view, attribute: .bottom, multiplier: 1, constant: 0)
		
		NSLayoutConstraint.activate([trailingConstraint, leadingConstraint, topConstraint, bottomConstraint])
		self.loginWebView.translatesAutoresizingMaskIntoConstraints = false
		self.loginViewController.view.addConstraints([trailingConstraint, leadingConstraint, topConstraint, bottomConstraint])
		self.loginViewController.view.layoutIfNeeded()
		
		loginWebView.delegate = self
		loginViewController.navigationItem.leftBarButtonItem = cancelButton
		nvc.pushViewController(loginViewController, animated: false)
	}
	
	@objc func dissmissViewController() {
		self.loginViewController.dismiss(animated: true, completion: nil)
	}
	
	func signIn(parentViewController: UIViewController, result: @escaping (SocialUser?, String?, Error?) -> ()) {
		let authURL = String(format: "%@?client_id=%@&redirect_uri=http://%@&response_type=token&scope=%@&DEBUG=True", arguments: [INSTAGRAM_AUTHURL, INSTAGRAM_CLIENT_ID, INSTAGRAM_REDIRECT_URI, INSTAGRAM_SCOPE ])
		let urlRequest =  URLRequest.init(url: URL.init(string: authURL)!)
		
		loginWebView.loadRequest(urlRequest)
		self.result = result
		parentViewController.present(nvc, animated: true)
	}
	
	private func getToken(request: URLRequest) -> String? {
		
		let requestURLString = (request.url?.absoluteString)! as String
		
		if requestURLString.hasPrefix("http://" + INSTAGRAM_REDIRECT_URI) {
			let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
			let token = requestURLString[range.upperBound...]
			return token.description
		}
		return nil
	}
	
	func signOut() {
		INSTAGRAM_ACCESS_TOKEN = nil
		self.firstName = nil
		self.lastName = nil
	}
	
	
}

extension InstagramClient: UIWebViewDelegate {
	func webViewDidStartLoad(_ webView: UIWebView) {
	}
	
	func webViewDidFinishLoad(_ webView: UIWebView) {
	}
	
	func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		
		guard let url = request.url else {
			return true;
		}
		
		if (url.host == INSTAGRAM_REDIRECT_URI) {
			loginViewController.dismiss(animated: true, completion: nil)
			INSTAGRAM_ACCESS_TOKEN = getToken(request: request)
			getSessionData()
		}
		
		return true;
	}
}
