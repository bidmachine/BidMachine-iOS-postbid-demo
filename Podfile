platform :ios, '10.0'
install! 'cocoapods', :deterministic_uuids => false, :warn_for_multiple_pod_sources => false

$BDMVersion = '~> 1.9.2.0'
$AppLovinVersion = '~> 11.3.3'

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
