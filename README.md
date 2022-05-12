
![BidMachine iOS](https://appodeal-ios.s3-us-west-1.amazonaws.com/docs/bidmachine.png)
# BidMachine-iOS-postbid-demo


[<img src="https://img.shields.io/badge/SDK%20Version-1.9.3-brightgreen">](https://docs.bidmachine.io/docs/in-house-mediation-1)
[<img src="https://img.shields.io/badge/Applovin%20MAX%20Version-11.3.3-blue">](https://dash.applovin.com/documentation/mediation/ios/getting-started/integration)
[<img src="https://img.shields.io/badge/AdMob%20Version-9.4.0-blue">](https://developers.google.com/admob/ios/quick-start)

* [Overview](#post-bid-overview)
* [PreBid Block](#prebid-block)
* [PostBid block](#postbid-block)
* [Showing the loaded ad object](#showing-the-loaded-ad-object)
    + [Banner](#banner)
    + [AutorefreshBanner](#autorefresh-banner)
    + [Interstitial](#interstitial)
    + [Rewarded](#rewarded)

## Post Bid Overview

Showing an ad object is performed in 4 stages:

1) [PreBid block](#prebid-block) - Loading ad objects
2) [PostBid block](#postbid-block) - Loading  ad objects based on Prebid block max price result
3) [Mediation block](#mediation-blick) - The choice of the maximum price occurs between all loaded advertising objects
4) [Showing the max price loaded ad object](#showing-the-loaded-ad-object)

The operation of each block is described below.

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

#### PreBid Mediated Ad Networks:

| Ad Network  | Adapter                                                                                                   | Type Class                                                                                                                  |
|-------------|-----------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| BidMachine  | [BidMachinePreBidNetwork](BidMachineMediationAdapters/BidMachineMediationAdapter/BidMachineNetwork.swift) | [BidMachineBannerAdapter](BidMachineMediationAdapters/BidMachineMediationAdapter/BidMachineBannerAdapter.swift)             |
|             |                                                                                                           | [BidMachineInterstitialAdapter](BidMachineMediationAdapters/BidMachineMediationAdapter/BidMachineInterstitialAdapter.swift) |
|             |                                                                                                           | [BidMachineRewardedAdapter](BidMachineMediationAdapters/BidMachineMediationAdapter/BidMachineRewardedAdapter.swift)         |
| ApplovinMAX | [ApplovinPreBidNetwork](BidMachineMediationAdapters/ApplovinMediationAdapter/ApplovinNetwork.swift) | [ApplovinBannerAdapter](BidMachineMediationAdapters/ApplovinMediationAdapter/ApplovinBannerAdapter.swift)                   |
|             |                                                                                                           | [ApplovinInterstitialAdapter](BidMachineMediationAdapters/ApplovinMediationAdapter/ApplovinInterstitialAdapter.swift)       |
|             |                                                                                                           | [ApplovinRewardedAdapter](BidMachineMediationAdapters/ApplovinMediationAdapter/ApplovinRewardedAdapter.swift)               |

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

#### PostBid Mediated Ad Networks:

| Ad Network | Adapter                                                                                                    | Type Class                                                                                                                  |
|------------|------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| BidMachine | [BidMachinePostBidNetwork](BidMachineMediationAdapters/BidMachineMediationAdapter/BidMachineNetwork.swift) | [BidMachineBannerAdapter](BidMachineMediationAdapters/BidMachineMediationAdapter/BidMachineBannerAdapter.swift)             |
|            |                                                                                                            | [BidMachineInterstitialAdapter](BidMachineMediationAdapters/BidMachineMediationAdapter/BidMachineInterstitialAdapter.swift) |
|            |                                                                                                            | [BidMachineRewardedAdapter](BidMachineMediationAdapters/BidMachineMediationAdapter/BidMachineRewardedAdapter.swift)         |
| AdMob      | [AdMobPostBidNetwork](BidMachineMediationAdapters/AdMobMediationAdapter/AdMobNetwork.swift)                | [AdMobBannerAdapter](BidMachineMediationAdapters/AdMobMediationAdapter/AdMobBannerAdapter.swift)                            |
|            |                                                                                                            | [AdMobInterstitialAdapter](BidMachineMediationAdapters/AdMobMediationAdapter/AdMobInterstitialAdapter.swift)                |
|            |                                                                                                            | [AdMobRewardedAdapter](BidMachineMediationAdapters/AdMobMediationAdapter/AdMobRewardedAdapter.swift)                        |


## Mediation Block

Mediation block finds the maximum loaded ad from those that have filled in prebid and postbid blocks and returns it to the final adObject

Comparison is based on the price of downloaded ad

``` swift
extension Array where Element == MediationAdapter {
    
    func maxPriceAdaptor() -> Element? {
        return self.sorted { $0.price >= $1.price }.first
    }
}
```

The result of the mediation block can be seen in the console

``` objc
----- Start Mediation Block
------------ Loaded Adapters: ["< Applovin_Max : 0.0 >", "< Bidmachine : 1.74545 >", "< Bidmachine : 1.752814 >", "< Googlemobileads : 2.0 >"]
------------ 🔥🥳 Max Price Adapter 🥳🔥: < Googlemobileads : 2.0 > 🎉🎉🎉
----- Complete Mediation Block
```

## Showing the loaded ad object

#### Banner

#### Autorefresh Banner

#### Interstitial

#### Rewarded
