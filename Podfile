platform :ios, '10.0'
install! 'cocoapods', :deterministic_uuids => false, :warn_for_multiple_pod_sources => false

$BDMVersion = '~> 1.8.0.0'
$AppLovinVersion = '~> 10.3.0'

def bidmachine
  pod "BDMIABAdapter", $BDMVersion
end

def applovin 
  pod 'AppLovinSDK', $AppLovinVersion
end

target 'BidMachineSample' do
  applovin
  bidmachine

end
