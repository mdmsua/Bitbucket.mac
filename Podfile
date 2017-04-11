platform :osx, '10.12'

project "Sources/Bitbucket.xcproj"
workspace "Sources/Bitbucket.xcworkspace"

target 'Bitbucket' do
  use_frameworks!
  pod 'Alamofire', '~> 4.4'
  pod 'AlamofireObjectMapper', '~> 4.1'
  pod 'KeychainAccess', '~> 3.0'
  pod 'Sentry', '~> 2.1'
  pod 'SwiftLint', '~> 0.18'
  target 'Tests' do
    inherit! :search_paths
  end
end
