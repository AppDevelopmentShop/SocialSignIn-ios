//
//  MainViewController.swift
//  SocialSingIn
//
//  Created by Павел Привалов on 7/2/18.
//  Copyright © 2018 Павел Привалов. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
	@IBOutlet weak var facebookButton: UIButton!
	@IBOutlet weak var twitterButton: UIButton!
	@IBOutlet weak var googleButton: UIButton!
	@IBOutlet weak var instagramButton: UIButton!
	@IBOutlet weak var vkButton: UIButton!
	@IBOutlet weak var linkedInButton: UIButton!
	@IBOutlet weak var firstNameLabel: UILabel!
	@IBOutlet weak var lastNameLabel: UILabel!
	@IBOutlet weak var emailLabel: UILabel!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		setLabelText(labels: [firstNameLabel, lastNameLabel, emailLabel], strings: ["", "", ""])
    }
	
	override func viewWillAppear(_ animated: Bool) {
		if !LinkedInClient.shared.isCanSignIn() {
			linkedInButton.isHidden = true
		} else {
			linkedInButton.isHidden = false
		}
	}
	
	@IBAction func onFacebookLogin(_ sender: UIButton) {
		self.socialAction(socialClient: FacebookClient.shared, option: .fb, socialButton: self.facebookButton)
	}
	
	@IBAction func onTwitterLogin(_ sender: UIButton) {
		self.socialAction(socialClient: TwitterClient.shared, option: .twitter, socialButton: self.twitterButton)
	}
	
	@IBAction func onGoogleLogin(_ sender: UIButton) {
		self.socialAction(socialClient: GoogleClient.shared, option: .google, socialButton: self.googleButton)
	}
	
	@IBAction func onVKLogin(_ sender: UIButton) {
		self.socialAction(socialClient: VKClient.shared, option: .vk, socialButton: self.vkButton)
	}
	
	@IBAction func onLinkedInLogin(_ sender: UIButton) {
		self.socialAction(socialClient: LinkedInClient.shared, option: .linkedIn, socialButton: self.linkedInButton)
	}
	
	@IBAction func onInstagramLogin(_ sender: UIButton) {
		self.socialAction(socialClient: InstagramClient.shared, option: .instagram, socialButton: self.instagramButton)
	}
	
	private func socialAction(socialClient: SocialClient, option: OptionToSignIn, socialButton: UIButton) {
		if (socialClient.currentUser != nil) {
			
			socialClient.signOut();
			setLabelText(labels: [firstNameLabel, lastNameLabel, emailLabel], strings: ["", "", ""])
			socialButton.setTitle(" Login with \(option.rawValue.capitalizingFirstLetter())", for: .normal);
		} else {
			socialClient.signIn(parentViewController: self) { (user, token, error) in
				
				let stringsForLabels = ["First name: \(user?.firstName ?? "")",
										"Last name: \(user?.lastName ?? "")",
										"Email: \(user?.email ?? "")"]
				
				self.setLabelText(labels: [self.firstNameLabel, self.lastNameLabel, self.emailLabel], strings: stringsForLabels)
				socialButton.setTitle("Logout \(option.rawValue.capitalizingFirstLetter())", for: .normal)
			}
		}
	}
	
	private func setLabelText(labels: [UILabel], strings: [String]) {
		for label in labels {
			label.text = strings[labels.index(of: label)!]
		}
	}
}
