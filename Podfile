platform :ios, '10.0'
install! 'cocoapods', :deterministic_uuids => false, :warn_for_multiple_pod_sources => false

source 'https://github.com/appodeal/CocoaPods.git'
source 'https://github.com/CocoaPods/Specs.git'

workspace 'BidMachineSample.xcworkspace'

$ModuleVersion = '~> 0.0.1'

def bidmachine_module
  pod "BidMachineMediationModule/BidMachine", $ModuleVersion
  pod "BidMachineMediationModule/Applovin", $ModuleVersion
  pod "BidMachineMediationModule/AdMob", $ModuleVersion
end

target 'BidMachineSample' do
project 'BidMachineSample/BidMachineSample.xcodeproj'
  bidmachine_module
end



