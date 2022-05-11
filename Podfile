platform :ios, '10.0'
install! 'cocoapods', :deterministic_uuids => false, :warn_for_multiple_pod_sources => false

workspace 'BidMachineSample.xcworkspace'

$BDMVersion = '~> 1.9.3.0'
$AppLovinVersion = '~> 11.3.3'
$GAMVersion = '~> 9.4.0'

def bidmachine
  pod "BDMIABAdapter", $BDMVersion
end

def applovin 
  pod 'AppLovinSDK', $AppLovinVersion
end

def google 
  pod 'Google-Mobile-Ads-SDK', $GAMVersion
end

target 'BidMachineSample' do
project 'BidMachineSample/BidMachineSample.xcodeproj'
  applovin
  bidmachine
  google
end

target 'BidMachineMediationAdapter' do
  project 'BidMachineMediationAdapters/BidMachineMediationAdapters.xcodeproj'
  bidmachine
end

target 'ApplovinMediationAdapter' do
  project 'BidMachineMediationAdapters/BidMachineMediationAdapters.xcodeproj'
  applovin
end

target 'AdMobMediationAdapter' do
  project 'BidMachineMediationAdapters/BidMachineMediationAdapters.xcodeproj'
  google
end



