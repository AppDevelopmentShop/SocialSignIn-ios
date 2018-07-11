# SocialSignIn-iOS
Mini library for sign in using social networking

#### Table of Contents

- [Requirements](#requirements)
- [Instruction](#instruction)
- [Examples](#examples)

## Requirements

Swift 4, Xcode 9, iOS 10.0+

## Instruction

Create ``Podfile``

```bash
pod init
```

Add pods to ``Podfile``
```bash
  use_frameworks!
  pod 'VK-ios-sdk'
  pod 'GoogleSignIn'
  pod 'FBSDKLoginKit'
  pod 'TwitterKit'
  pod 'FHSTwitterEngine', '~> 2.0'
  pod 'InstagramLogin'
  pod 'LinkedinSwift'
```
Create your apps on:
 - https://developers.facebook.com
 - https://www.instagram.com/developer/
 - https://apps.twitter.com
 - https://developer.linkedin.com
 - https://vk.com/dev

Config your ``Info.plist``. Add this source code and change ``<Linked In App Number>``, ``<Facebook App ID>``, ``<VK App ID>``,
``<Google CLient ID>``, ``<Twitter Consumer Key>`` with your app data:
```xml
<key>CFBundleURLTypes</key>
<array>
	<dict>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>li<Linked In App Number></string>
		</array>
	</dict>
	<dict>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>fb<Facebook App ID></string>
		</array>
	</dict>
	<dict>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>vk<VK App ID></string>
		</array>
	</dict>
	<dict>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<string><Google CLient ID></string>
		</array>
	</dict>
	<dict>
		<key>CFBundleTypeRole</key>
		<string>Editor</string>
		<key>CFBundleURLSchemes</key>
		<array>
			<string>twitterkit-<Twitter Consumer Key></string>
		</array>
	</dict>
</array>
 
<key>CFBundleVersion</key>
<string>1</string>
<key>FacebookAppID</key>
<string><Facebook App ID></string>
<key>FacebookDisplayName</key>
<string>AppShop-SignIn-Example</string>
<key>LIAppId</key>
<string><Linked In App Number></string>
<key>LSApplicationQueriesSchemes</key>
<array>
	<string>linkedin</string>
	<string>linkedin-sdk2</string>
	<string>linkedin-sdk</string>
</array>
<key>LSRequiresIPhoneOS</key>
<true/>
<key>NSAppTransportSecurity</key>
<dict>
	<key>NSExceptionDomains</key>
	<dict>
		<key>New item</key>
		<string></string>
		<key>linkedin.com</key>
		<dict>
			<key>NSExceptionAllowsInsecureHTTPLoads</key>
			<true/>
			<key>NSExceptionRequiresForwardSecrecy</key>
			<false/>
			<key>NSIncludesSubdomains</key>
			<true/>
		</dict>
	</dict>
</dict>
```

Add this code to ``AppDelegate.swift``
```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
	let facebook = FacebookClient.shared.applicationLogin(app, open: url, options: options)
	let twitter = TwitterClient.shared.applicationLogin(app, open: url, options: options)
	let linkedIn = LinkedInClient.shared.applicationLogin(app, open: url, options: options)
	let vk = VKClient.shared.applicationLogin(app, open: url, options: options)
	
	return facebook || twitter || linkedIn || vk
}
```
## Examples
Example function for signin/signout
```swift
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
```
