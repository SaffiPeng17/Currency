# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Currency' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Currency
  pod 'SnapKit'
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RealmSwift'
  pod 'RxRealm'
  pod 'Charts'
  pod 'lottie-ios'

  target 'CurrencyTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'CurrencyUITests' do
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '5.0'
            config.build_settings['DYLIB_COMPATIBILITY_VERSION'] = ''
        end
    end
end
