# SocialSignIn-iOS

[![CI Status](https://img.shields.io/travis/pprivalov/SocialSignIn-iOS.svg?style=flat)](https://travis-ci.org/pprivalov/SocialSignIn-iOS)
[![Version](https://img.shields.io/cocoapods/v/SocialSignIn-iOS.svg?style=flat)](https://cocoapods.org/pods/SocialSignIn-iOS)
[![License](https://img.shields.io/cocoapods/l/SocialSignIn-iOS.svg?style=flat)](https://cocoapods.org/pods/SocialSignIn-iOS)
[![Platform](https://img.shields.io/cocoapods/p/SocialSignIn-iOS.svg?style=flat)](https://cocoapods.org/pods/SocialSignIn-iOS)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SocialSignIn-iOS is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SocialSignIn-iOS'
```
Add to AppDelegate.swift
```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
	let facebook = FacebookClient.shared.applicationLogin(app, open: url, options: options)
	let twitter = TwitterClient.shared.applicationLogin(app, open: url, options: options)
	let linkedIn = LinkedInClient.shared.applicationLogin(app, open: url, options: options)
	let vk = VKClient.shared.applicationLogin(app, open: url, options: options)

	return facebook || twitter || linkedIn || vk
}
```

## Author

pprivalov, privalov.pavlo@gmail.com

## License

SocialSignIn-iOS is available under the MIT license. See the LICENSE file for more info.
