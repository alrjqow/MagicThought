#
#  Be sure to run `pod spec lint MagicThought.podspec" to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it"s definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

# s.name         = "MagicThought"
#s.version      = "0.0.1"
# s.summary      = "A short description of MagicThought."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don"t worry about the indent, CocoaPods strips it!
# s.description  = <<-DESC

#s.homepage     = "http://EXAMPLE/MagicThought"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See http://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are "MIT", "BSD" and "Apache License, Version 2.0".
  #

#s.license      = "MIT (example)"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you"d rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

#s.author             = { "monda" => "" }
  # Or just: s.author    = "monda"
  # s.authors            = { "monda" => "" }
  # s.social_media_url   = "http://twitter.com/monda"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # s.platform     = :ios
  # s.platform     = :ios, "5.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

#s.source       = { :git => "http://EXAMPLE/MagicThought.git", :tag => "#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

#s.source_files  = "Classes", "Classes/**/*.{h,m}"
#s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don"t preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  # s.frameworks = "SomeFramework", "AnotherFramework"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

s.name = "MagicThought"
s.version = "1.2.9"
s.summary = "MagicThought for ios."
s.description = "the MagicThought for ios."
s.homepage = "https://github.com/alrjqow/MagicThought"
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "alrjqow" => "764032554@qq.com" }

s.platform = :ios, "8.0"

s.source = { :git => "https://github.com/alrjqow/MagicThought.git", :tag =>"#{s.version}", :branch => "master" }

#s.prefix_header_file = 'MagicThought/Config/MagicThought.pch'
s.source_files = "MagicThought/MTKit.h"

s.subspec 'Config' do |config|
config.source_files = 'MagicThought/Config/*.{h,m}'
end

s.subspec 'Protocol' do |protocol|
protocol.source_files = 'MagicThought/Category/NSString/*.{h}', 'MagicThought/Protocol/*.{h,m}'
end

s.subspec 'Style' do |style|
style.source_files = 'MagicThought/Style/*.{h,m}'
end

s.subspec 'Manager' do |manager|
manager.source_files = 'MagicThought/Manager/*.{h,m}','MagicThought/Category/NSString/NSString+Exist.{m,h}', 'MagicThought/Category/CLLocation/CLLocation+Mar.{m,h}', 'MagicThought/Config/MTConst.{h,m}'
end

s.subspec '文件处理' do |fileHandle|
fileHandle.source_files = 'MagicThought/文件处理/*.{h,m}','MagicThought/Category/NSString/NSString+Exist.{m,h}'
end

s.subspec 'Json转换' do |jsonEncode|
jsonEncode.source_files = 'MagicThought/Json转换/*.{h,m}'
end

s.subspec '波纹效果' do |wave|
wave.source_files = 'MagicThought/波纹效果/*.{h,m}'
end

s.subspec '图片处理' do |imageHandle|
imageHandle.source_files = 'MagicThought/图片处理/*.{h,m}', 'MagicThought/Config/MTConst.{h,m}'
imageHandle.dependency 'MagicThought/文件处理'
end

s.subspec 'Category' do |category|

category.subspec 'NSString' do |string|
string.source_files = 'MagicThought/Category/NSString/*.{m,h}'
end

category.subspec 'CLLocation' do |location|
location.source_files = 'MagicThought/Category/CLLocation/*.{m,h}'
end

category.subspec 'NSObject' do |object|
object.source_files = 'MagicThought/Category/NSObject/*.{m,h}'
end

category.subspec 'UIButton' do |button|
button.source_files = 'MagicThought/Category/UIButton/*.{m,h}'
end

category.subspec 'UIColor' do |color|
color.source_files = 'MagicThought/Category/UIColor/*.{m,h}'
end

category.subspec 'UIDevice' do |device|
device.source_files = 'MagicThought/Category/UIDevice/*.{m,h}'
device.dependency 'MagicThought/Category/NSString'
device.dependency 'MagicThought/Config'
device.dependency "SSKeychain"
end

category.subspec 'UILabel' do |label|
label.source_files = 'MagicThought/Category/UILabel/*.{m,h}'
label.dependency 'MagicThought/Category/NSString'
end

category.subspec 'UINavigationBar' do |navigationBar|
navigationBar.source_files = 'MagicThought/Category/UINavigationBar/*.{m,h}'
navigationBar.dependency 'MagicThought/Category/UIDevice'
navigationBar.dependency 'MagicThought/Config'
end

category.subspec 'UIView' do |view|
view.source_files = 'MagicThought/Category/UIView/*.{m,h}'
view.dependency 'MagicThought/Style'
view.dependency 'MagicThought/Config'

view.subspec 'UIView+Shadow' do |view_shadow|

view_shadow.source_files = 'MagicThought/Category/UIView/UIView+Shadow/*.{m,h}', 'MagicThought/Config/MTConst.{h,m}'

end

end




category.subspec 'UIViewController' do |viewController|
viewController.source_files = 'MagicThought/Category/UIViewController/*.{m,h}'
viewController.dependency 'MagicThought/Manager'

viewController.subspec 'UIViewController+Modal' do |viewController_modal|
viewController_modal.source_files = 'MagicThought/Category/UIViewController/UIViewController+Modal/*.{m,h}'

end

end




end



#s.resources = "MagicThought/MagicThought/MagicThought/*"
s.framework = "UIKit"
# s.frameworks = “SomeFramework”, “AnotherFramework”
# s.library = “iconv”
# s.libraries = “iconv”, “xml2”
s.requires_arc = true
# s.xcconfig = { “HEADER_SEARCH_PATHS” => “$(SDKROOT)/usr/include/libxml2” }


s.dependency "Masonry"

s.dependency "AFNetworking"

s.dependency "MJRefresh"

s.dependency "MJExtension"

s.dependency "MBProgressHUD"

s.dependency "SVProgressHUD"

s.dependency "YTKNetwork"

s.dependency "IQKeyboardManager"

s.dependency "SDWebImage"

s.dependency "TTTAttributedLabel"

s.dependency "SSKeychain"

s.dependency "LDProgressView"


end
