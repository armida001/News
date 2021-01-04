platform :ios, '9.0'
inhibit_all_warnings!
use_frameworks!
project 'News.xcodeproj'

abstract_target 'CommonPods' do
  target 'News' do
    pod 'FeedKit'
    pod 'R.swift'
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxDataSources'
    pod 'Alamofire'
    pod 'SwiftyJSON'
    pod 'Kingfisher'
    pod 'RealmSwift'
    pod 'KissXML'
    pod 'Fuse'
    pod 'Branch'   
    pod "RxWebSocket"
    pod 'MGSwipeTableCell'  
  end
end

DEFAULT_SWIFT_VERSION = '5.0'
POD_SWIFT_VERSION_MAP = {
  'Fuse' => '4.2'
}

post_install do |installer|
  installer.pods_project.targets.each do |target|
    swift_version = POD_SWIFT_VERSION_MAP[target.name] || DEFAULT_SWIFT_VERSION
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = swift_version
      config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
      config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
      config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
    end
  end
end
