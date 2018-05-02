#
# Be sure to run `pod lib lint Warp.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = "WarpExt"
    s.version          = "0.1.12"
    s.summary          = "Warp Objective-C Framework for iOS and OS X."

    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    s.description      = <<-DESC
    Warp Objective-C Framework for iOS and OS X. Collection of classes to make iOS development easy.
    DESC

    s.homepage         = "https://github.com/TwoManShow/Warp"
    # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
    s.license          = 'MIT'
    s.author           = { "Lukas Foldyna" => "lukas@twomanshow.co" }
    s.source           = { :git => "https://github.com/TwoManShow/Warp.git", :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/twomanshowapps'

    s.platform     = :ios, '6.0'
    #s.ios.deployment_target = '6.0'
    #s.osx.deployment_target = '10.7'
    s.requires_arc = true

    s.frameworks = 'UIKit'
    s.dependency 'CocoaLumberjack'

    s.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'TARGET_IS_EXTENSION=1 LUMBERMODULE=1 $(inherited)' }

    s.prefix_header_file = 'Resources/Warp_Prefix.pch'
    s.source_files = 'Classes/**/*'

end
