
![BidMachine iOS](https://appodeal-ios.s3-us-west-1.amazonaws.com/docs/bidmachine.png)
# BidMachine-iOS-postbid-demo

* [Get started](#get-started)
* [Overview](#post-bid-overview)
* [PreBid Block](#prebid-block)
* [PostBid block](#postbid-block)
* [Mediation Block](#mediation_block)

## Get started

In order to use the [module](https://github.com/bidmachine/BidMachine-iOS-Mediation-SDK), you need to add the following specs to the Podfile

``` ruby
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
```

[To initialize the module, use the instruction](https://github.com/bidmachine/BidMachine-iOS-Mediation-SDK#initialization)

## Post Bid Overview

Showing an ad object is performed in 4 stages:

1) [PreBid block](#prebid-block) - Loading ad objects
2) [PostBid block](#postbid-block) - Loading  ad objects based on Prebid block max price result
3) [Mediation block](#mediation-block) - The choice of the maximum price occurs between all loaded advertising objects
4) [Showing the max price loaded ad object](#showing-the-loaded-ad-object)

The operation of each block is described below.

[AdNetwork support for the each mediation block](https://github.com/bidmachine/BidMachine-iOS-Mediation-SDK#adaptors)

## PreBid Block

The prebid block makes requests to ad networks through their adapters. Ad networks are loaded in parallel. At the end of the download of all ad networks, we will have an intermediate result of downloading ad

The result of the prebid block can be seen in the console

``` objc
----- Start Prebid Block
------- Mediated Adapters: ["< Bidmachine : 0.0 >", "< Applovin_Max : 0.0 >"]
------- Mediated Price: 0.0
------------ Loaded Adapters: ["< Applovin_Max : 0.0 >", "< Bidmachine : 1.74545 >"]
----- Complete Prebid Block
```

## PostBid Block

The postbid block makes requests to ad networks through their adapters. Ad networks are loaded in parallel. The postbid block uses the maximum price of the completed ad objects from the prebid block. Postbid adapters use this price to download ads with a higher bid.

The result of the postbid block can be seen in the console

``` objc
----- Start Postbid Block
------- Mediated Adapters: ["< Bidmachine : 0.0 >", "< Googlemobileads : 0.0 >"]
------- Mediated Price: 1.74545
------------ Loaded Adapters: ["< Bidmachine : 1.752814 >", "< Googlemobileads : 2.0 >"]
----- Complete Postbid Block
```

## Mediation Block

Mediation block finds the maximum loaded ad from those that have filled in prebid and postbid blocks and returns it to the final adObject

The result of the mediation block can be seen in the console

``` objc
----- Start Mediation Block
------------ Loaded Adapters: ["< Applovin_Max : 0.0 >", "< Bidmachine : 1.74545 >", "< Bidmachine : 1.752814 >", "< Googlemobileads : 2.0 >"]
------------ 🔥🥳 Max Price Adapter 🥳🔥: < Googlemobileads : 2.0 > 🎉🎉🎉
----- Complete Mediation Block
```


