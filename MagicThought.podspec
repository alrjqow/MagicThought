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
s.version = "1.8.3"
s.summary = "MagicThought for ios."
s.description = "the MagicThought for ios."
s.homepage = "https://github.com/alrjqow/MagicThought"
s.license = { :type => "MIT", :file => "LICENSE" }
s.author = { "alrjqow" => "764032554@qq.com" }

s.platform = :ios, "8.0"

s.source = { :git => "https://github.com/alrjqow/MagicThought.git", :tag =>"#{s.version}", :branch => "master" }

#s.prefix_header_file = 'MagicThought/Config/MagicThought.pch'
s.source_files = "MagicThought/MTKit.h", 'MagicThought/README.md'

s.subspec 'Dependency' do |dependency|
dependency.source_files = 'MagicThought/Dependency/*.{h,m}'
end


s.subspec 'MTProtocol' do |protocol|
protocol.source_files = 'MagicThought/MTProtocol/*.{h,m}'
end

s.subspec 'MTStyle' do |style|
style.source_files = 'MagicThought/MTStyle/*.{h,m}'
style.dependency 'MagicThought/Dependency'
end


s.subspec 'MTNetwork' do |network|
network.source_files = 'MagicThought/MTNetwork/*.{h,m}'
network.dependency 'MagicThought/Dependency'
end


s.subspec 'Category' do |category|

category.source_files = 'MagicThought/Category/*.{h,m}'

category.subspec 'NSString' do |string|
string.source_files = 'MagicThought/Category/NSString/*.{m,h}'
string.dependency 'MagicThought/Dependency'
end

category.subspec 'CLLocation' do |location|
location.source_files = 'MagicThought/Category/CLLocation/*.{m,h}'
end

category.subspec 'NSObject' do |object|
object.source_files = 'MagicThought/Category/NSObject/*.{m,h}'
object.dependency 'MagicThought/MTProtocol'
end

category.subspec 'UIButton' do |button|
button.source_files = 'MagicThought/Category/UIButton/*.{m,h}'
end

category.subspec 'UIColor' do |color|
color.source_files = 'MagicThought/Category/UIColor/*.{m,h}'
end


category.subspec 'UILabel' do |label|
label.source_files = 'MagicThought/Category/UILabel/*.{m,h}'
label.dependency 'MagicThought/Dependency'
end


category.subspec 'UIView' do |view|
view.source_files = 'MagicThought/Category/UIView/*.{m,h}'
end

category.subspec 'UIViewController' do |viewController|
viewController.source_files = 'MagicThought/Category/UIViewController/*.{m,h}'
viewController.dependency 'MagicThought/Dependency'
end

end


s.subspec 'MTDelegateMode' do |delegateMode|
delegateMode.source_files = 'MagicThought/MTDelegateMode/*.{h,m}'

delegateMode.dependency 'MagicThought/MTProtocol'
delegateMode.dependency 'MagicThought/MTStyle'
delegateMode.dependency 'MagicThought/Dependency'
end


s.subspec 'SubClass' do |subClass|

subClass.source_files = 'MagicThought/SubClass/*.{m,h}'

subClass.subspec 'WKWebView' do |webView|
webView.source_files = 'MagicThought/SubClass/WKWebView/*.{m,h}'
webView.dependency 'MagicThought/Dependency'
end

subClass.subspec 'UIButton' do |button|
button.source_files = 'MagicThought/SubClass/UIButton/*.{m,h}'
button.dependency 'MagicThought/Dependency'
button.dependency 'MagicThought/MTProtocol'
end

subClass.subspec 'UITableViewCell' do |tableViewCell|
tableViewCell.source_files = 'MagicThought/SubClass/UITableViewCell/*.{m,h}'
tableViewCell.dependency 'MagicThought/MTDelegateMode'
end

end

s.subspec 'MTRefresh' do |mtRefresh|
mtRefresh.source_files = 'MagicThought/MTRefresh/*.{m,h}'
mtRefresh.dependency 'MagicThought/MTProtocol'
mtRefresh.dependency 'MagicThought/Dependency'
end


s.subspec 'MTFileHandle' do |fileHandle|
fileHandle.source_files = 'MagicThought/MTFileHandle/*.{h,m}'
fileHandle.dependency 'MagicThought/Dependency'
end

s.subspec 'MTImageHandle' do |imageHandle|
imageHandle.source_files = 'MagicThought/MTImageHandle/*.{h,m}'
imageHandle.dependency 'MagicThought/MTFileHandle'
imageHandle.dependency 'MagicThought/Dependency'
end

s.subspec 'MTHud' do |hud|
hud.source_files = 'MagicThought/MTHud/*.{h,m}'
hud.resources = "MagicThought/MTHud/MTHud.bundle"
hud.dependency 'MagicThought/MTImageHandle'
hud.dependency 'MagicThought/Dependency'
hud.dependency 'MagicThought/Category'
end

s.subspec 'MTJsonTransform' do |jsonEncode|
jsonEncode.source_files = 'MagicThought/MTJsonTransform/*.{h,m}'
end

s.subspec 'MTTapWaveEffect' do |wave|
wave.source_files = 'MagicThought/MTTapWaveEffect/*.{h,m}'
end

s.subspec 'MTTextFieldVerify' do |textVerify|
textVerify.source_files = 'MagicThought/MTTextFieldVerify/*.{h,m}'

lock.dependency 'MagicThought/MTDelegateMode'
textVerify.dependency 'MagicThought/Category'
textVerify.dependency 'MagicThought/MTProtocol'
textVerify.dependency 'MagicThought/MTStyle'
textVerify.dependency 'MagicThought/Dependency'
end

s.subspec 'MTGestureLock' do |lock|
lock.source_files = 'MagicThought/MTGestureLock/*.{h,m}'
lock.dependency 'MagicThought/MTDelegateMode'
lock.dependency 'MagicThought/Dependency'
end

s.subspec 'MTSpiltView' do |spilt|
spilt.source_files = 'MagicThought/MTSpiltView/*.{h,m}'
spilt.dependency 'MagicThought/MTDelegateMode'
spilt.dependency 'MagicThought/Dependency'
end

s.subspec 'MTCountdownRing' do |count|
count.source_files = 'MagicThought/MTCountdownRing/*.{h,m}'
count.dependency 'MagicThought/MTDelegateMode'
count.dependency 'MagicThought/Dependency'
end

s.subspec 'MTImagePlay' do |imagePlay|
imagePlay.source_files = 'MagicThought/MTImagePlay/*.{h,m}'
imagePlay.dependency 'MagicThought/MTDelegateMode'
imagePlay.dependency 'MagicThought/Dependency'
imagePlay.dependency 'MagicThought/MTProtocol'
end

s.subspec 'MTSlideView' do |slide|
slide.source_files = 'MagicThought/MTSlideView/*.{h,m}'
slide.dependency 'MagicThought/Dependency'
slide.dependency 'MagicThought/Category'
end

s.subspec 'MTAlert' do |alert|
alert.source_files = 'MagicThought/MTAlert/*.{h,m}'
alert.dependency 'MagicThought/MTDelegateMode'
alert.dependency 'MagicThought/MTTextFieldVerify'
alert.dependency 'MagicThought/Category'
end

s.subspec 'MTFileSelect' do |fileSelect|
fileSelect.source_files = 'MagicThought/MTFileSelect/*.{h,m}'
fileSelect.dependency 'MagicThought/Dependency'
end

s.subspec 'MTManager' do |manager|
manager.source_files = 'MagicThought/MTManager/*.{h,m}'

manager.dependency 'MagicThought/MTAlert'
manager.dependency 'MagicThought/Dependency'
manager.dependency 'MagicThought/Category'
end

s.subspec 'Library' do |library|

library.source_files = 'MagicThought/Library/*.{h,m}'

library.subspec 'TZImagePickerController' do |imagePickerController|
imagePickerController.source_files = 'MagicThought/Library/TZImagePickerController/*.{m,h}'
imagePickerController.resources = "MagicThought/Library/TZImagePickerController/TZImagePickerController.bundle"

imagePickerController.dependency 'MagicThought/Dependency'
imagePickerController.dependency 'MagicThought/MTImageHandle'
end

end

s.subspec 'MTTenScroll' do |tenScroll|
tenScroll.source_files = 'MagicThought/MTTenScroll/**/*.{m,h}'
tenScroll.dependency 'MagicThought/MTStyle'
tenScroll.dependency 'MagicThought/MTNetwork'
tenScroll.dependency 'MagicThought/MTDelegateMode'
tenScroll.dependency 'MagicThought/Dependency'
tenScroll.dependency 'MagicThought/MTListController'
end

s.subspec 'MTBaseCell' do |baseCell|
baseCell.source_files = 'MagicThought/MTBaseCell/*.{h,m}'
baseCell.dependency 'MagicThought/MTTextFieldVerify'
baseCell.dependency 'MagicThought/MTStyle'
baseCell.dependency 'MagicThought/MTDelegateMode'
baseCell.dependency 'MagicThought/Dependency'
end

s.subspec 'MTViewController' do |viewController|

viewController.source_files = 'MagicThought/MTViewController/*.{m,h}'

viewController.subspec 'UIViewController+Progress' do |progress|
progress.source_files = 'MagicThought/MTViewController/UIViewController + Progress/*.{m,h}'
progress.dependency 'MagicThought/MTStyle'
progress.dependency 'MagicThought/Dependency'
end

viewController.subspec 'UIViewController+PickView' do |pickView|
pickView.source_files = 'MagicThought/MTViewController/UIViewController + PickView/*.{m,h}'
pickView.resources = "MagicThought/MTViewController/UIViewController + PickView/*.xib"
pickView.dependency 'MagicThought/Dependency'
end

viewController.subspec 'UIViewController+Base' do |base|
base.source_files = 'MagicThought/MTViewController/UIViewController + Base/*.{m,h}'
base.dependency 'MagicThought/MTHud'
base.dependency 'MagicThought/MTNetwork'
base.dependency 'MagicThought/MTDelegateMode'
base.dependency 'MagicThought/MTProtocol'
base.dependency 'MagicThought/Category/UIViewController'
base.dependency 'MagicThought/Dependency'
end

viewController.subspec 'UIViewController+FeedBackInfo' do |feedBackInfo|
feedBackInfo.source_files = 'MagicThought/MTViewController/UIViewController + FeedBackInfo/*.{m,h}'
feedBackInfo.dependency 'MagicThought/MTStyle'
feedBackInfo.dependency 'MagicThought/Dependency'
feedBackInfo.dependency 'MagicThought/Category'
feedBackInfo.dependency 'MagicThought/MTViewController/UIViewController+Base'
end

viewController.subspec 'UIViewController+MTSafariView' do |safariView|
safariView.source_files = 'MagicThought/MTViewController/UIViewController + MTSafariView/*.{m,h}'
safariView.resources = "MagicThought/MTViewController/UIViewController + MTSafariView/MTSafariViewController.bundle"
safariView.dependency 'MagicThought/SubClass/WKWebView'
safariView.dependency 'MagicThought/Dependency'
safariView.dependency 'MagicThought/MTViewController/UIViewController+Base'
end


end


s.subspec 'MTListController' do |listController|
listController.source_files = 'MagicThought/MTListController/*.{h,m}'
listController.dependency 'MagicThought/MTRefresh'
listController.dependency 'MagicThought/MTNetwork'
listController.dependency 'MagicThought/MTViewController/UIViewController+Base'
listController.dependency 'MagicThought/MTDelegateMode'
listController.dependency 'MagicThought/Dependency'
end

s.subspec 'MTCustomCamera' do |camera|
camera.source_files = 'MagicThought/MTCustomCamera/*.{h,m}'
camera.resources = "MagicThought/MTCustomCamera/MTVideoController.bundle"
camera.dependency 'MagicThought/MTImageHandle'
camera.dependency 'MagicThought/MTHud'
camera.dependency 'MagicThought/MTCountdownRing'
camera.dependency 'MagicThought/MTManager'
camera.dependency 'MagicThought/MTProtocol'
camera.dependency 'MagicThought/Dependency'
end

s.subspec 'MTNavigationController' do |navigationController|

navigationController.source_files = 'MagicThought/MTNavigationController/**/*.{m,h}'

navigationController.dependency 'MagicThought/MTStyle'
navigationController.dependency 'MagicThought/MTProtocol'
navigationController.dependency 'MagicThought/Dependency'
end


s.subspec 'MTAlert2' do |alert2|

alert2.source_files = 'MagicThought/MTAlert2/**/*.{m,h}'

alert2.subspec 'Model' do |model|
model.source_files = 'MagicThought/MTAlert2/Model/*.{m,h}'
model.dependency 'MagicThought/MTDelegateMode'
model.dependency 'MagicThought/Dependency'
end

alert2.subspec 'Controller' do |controller|
controller.source_files = 'MagicThought/MTAlert2/Controller/*.{m,h}', 'MagicThought/MTAlert2/Service/*.{m,h}'
controller.dependency 'MagicThought/MTAlert2/Model'
controller.dependency 'MagicThought/MTStyle'
controller.dependency 'MagicThought/MTDelegateMode'
controller.dependency 'MagicThought/MTViewController/UIViewController+Base'
controller.dependency 'MagicThought/Dependency'
end

end


s.subspec 'MTImageShowAndBrowser' do |imageBrowser|

imageBrowser.source_files = 'MagicThought/MTImageShowAndBrowser/**/*.{m,h}'
imageBrowser.resources = "MagicThought/MTImageShowAndBrowser/MTPhotoBrowser.bundle"

imageBrowser.dependency 'MagicThought/Library/TZImagePickerController'
imageBrowser.dependency 'MagicThought/MTNavigationController'
imageBrowser.dependency 'MagicThought/MTCustomCamera'
imageBrowser.dependency 'MagicThought/MTImageHandle'
imageBrowser.dependency 'MagicThought/MTAlert2'
imageBrowser.dependency 'MagicThought/MTAlert'
imageBrowser.dependency 'MagicThought/Category'
imageBrowser.dependency 'MagicThought/MTManager'
imageBrowser.dependency 'MagicThought/MTProtocol'
imageBrowser.dependency 'MagicThought/MTDelegateMode'
imageBrowser.dependency 'MagicThought/Dependency'

end


s.subspec 'MTChart' do |chart|
chart.source_files = 'MagicThought/MTChart/*.{m,h}'
chart.dependency 'MagicThought/Dependency'
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

s.dependency "SAMKeychain"

s.dependency "LDProgressView"


end
