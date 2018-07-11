Pod::Spec.new do |s|
  s.name             = 'SocialSignIn-iOS'
  s.version          = '0.1.0'
  s.summary          = 'Social sign in for swift'
  s.description      = <<-DESC
Social sign in library for swift. Install this lib and never write it again
                       DESC
  s.homepage         = 'https://github.com/AppDevelopmentShop/SocialSignIn-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'pprivalov' => 'privalov.pavlo@gmail.com' }
  s.source           = { :git => 'https://github.com/AppDevelopmentShop/SocialSignIn-ios.git',
					  :branch => 'master',
					  :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'SocialSignIn-iOS/Classes/**/*'

  s.frameworks = 'UIKit', 'GoogleSignIn'
  s.dependency 'VK-ios-sdk'
  s.dependency 'FBSDKLoginKit'
  s.dependency 'TwitterKit'
  s.dependency 'FHSTwitterEngine', '~> 2.0'
  s.dependency 'InstagramLogin'
  s.dependency 'LinkedinSwift'
end
