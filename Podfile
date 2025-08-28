# Uncomment the next line to define a global platform for your project
# platform :ios, '13.0'

source "https://github.com/AmaniTechnologiesLtd/Mobile_SDK_Repo"
source "https://github.com/CocoaPods/Specs"

target 'BioLoginDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for BioLoginDemo

  pod 'AmaniSDK', '3.4.16'
  pod 'AmaniUI', '1.2.9'

end

post_install do |installer|
  xcode_base_version = `xcodebuild -version | grep 'Xcode' | awk '{print $2}' | cut -d . -f 1`

  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        # This block is for xcode 15
        if config.base_configuration_reference && Integer(xcode_base_version) >= 15
          xcconfig_path = config.base_configuration_reference.real_path
          xcconfig = File.read(xcconfig_path)
          xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
          File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
        end
        config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
        if target.name == 'AmaniUI'
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
        end
      end
    end
  end
end
