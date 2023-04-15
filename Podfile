# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'payment_app' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for payment_app

  target 'payment_appTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'payment_appUITests' do
    # Pods for testing
  end

pod 'Firebase/Analytics'
pod 'Firebase/Messaging'
pod 'Firebase/Crashlytics'
pod 'Kingfisher', '~> 7.0'
pod 'Stripe'

  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
              config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
              config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
          end
      end
  end

end
