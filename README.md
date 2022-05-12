
![BidMachine iOS](https://appodeal-ios.s3-us-west-1.amazonaws.com/docs/bidmachine.png)
# BidMachine-iOS-postbid-demo


[<img src="https://img.shields.io/badge/SDK%20Version-1.9.3-brightgreen">](https://docs.bidmachine.io/docs/in-house-mediation-1)
[<img src="https://img.shields.io/badge/Applovin%20MAX%20Version-11.3.3-blue">](https://dash.applovin.com/documentation/mediation/ios/getting-started/integration)
[<img src="https://img.shields.io/badge/AdMob%20Version-9.4.0-blue">](https://developers.google.com/admob/ios/quick-start)

* [Overview](#overview)
* [Loading Applovin MAX](#loading-applovin-max)
* [Loading BidMachine based on Applovin MAX result](#loading-bidmachine-based-on-applovin-max-result)
* [Showing the loaded ad object](#showing-the-loaded-ad-object)
* [Sample](#sample)

## Post Bid Overview

Showing an ad object is performed in 4 stages:

1) [PreBid block](#prebid-block) - Loading ad objects
2) PostBid block - Loading  ad objects based on Prebid block max price result
3) Mediation block - The choice of the maximum price occurs between all loaded advertising objects
4) Showing the max price loaded ad object

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

## Loading Applovin MAX

How to load the Applovin MAX ad object,
see [the official documentation](https://dash.applovin.com/documentation/mediation/ios/getting-started/integration).

## Loading BidMachine based on Applovin MAX result

How to load the BidMachine ad object,
see [the official documentation](https://docs.bidmachine.io/docs/in-house-mediation-1).

Loading the Applovin MAX ad object may finish with two results: ```didLoadAd:```
or ```didFailToLoadAdForAdUnitIdentifier:withError```

* If loading finished successful, then start load BidMachine with the price from the Applovin MAX
  object (```MAAd.revenue```) multiplied by 1000.

* If loading did not complete successfully, then start loading BidMachine, either without price (by
  default it will be 0.01), or specify the price you need.

## Showing the loaded ad object

After the loading stage, you should give preference to the BidMachine ad object when displaying the
ad, since it was requested with a price floor that is higher than the price of the loaded ad from
Applovin MAX, therefore the you will gain more revenue from that.

## Autorefresh Banner

The autorefresh banner is presented in the demo using the [BMAutorefreshBanner](BidMachineSample/BMAutorefreshBanner.m) class.
With it, you can show a banner with a frequency of 15 seconds.
The customizable banner uses post-bid mediation to maximize profits.

The choice of the maximum price occurs between all loaded advertising objects. [Example](BidMachineSample/BMBannerPostbidController.m#L72)

``` objc
    BMMediationBanner *winner = [mediationBanners bm_maxPriceBanner:^BMMediationBanner *(BMMediationBanner *prev, BMMediationBanner *next) {
        return next.ECPM >= prev.ECPM ? next : prev;
    }];
```

## Sample

* [Interstitial](BidMachineSample/Interstitial.m)
* [Rewarded](BidMachineSample/Rewarded.m)
* [Banner](BidMachineSample/Banner.m)
* [AutorefreshBanner](BidMachineSample/ABanner.m)
