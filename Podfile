platform :ios, '14.0'

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
  end
 end
end


target 'Vectors' do

use_frameworks!
inhibit_all_warnings!

pod 'SwiftLint'
pod 'SwiftGen'
pod 'SnapKit'
pod 'RxSwift'
pod 'RxCocoa'
pod 'RealmSwift'

end
