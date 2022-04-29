# BidMachine-iOS-postbid-demo

[<img src="https://img.shields.io/badge/SDK%20Version-1.9.2-brightgreen">](https://github.com/bidmachine/BidMachine-iOS-SDK)
[<img src="https://img.shields.io/badge/Applovin%20MAX%20Version-11.3.3-blue">](https://dash.applovin.com/documentation/mediation/ios/getting-started/integration)

* [Overview](#overview)
* [Loading Applovin MAX](#loading-applovin-max)
* [Loading BidMachine based on Applovin MAX result](#loading-bidmachine-based-on-applovin-max-result)
* [Showing the loaded ad object](#showing-the-loaded-ad-object)
* [Sample](#sample)

## Overview

Showing an ad object is performed in 3 stages:

1) Loading Applovin MAX
2) Loading BidMachine based on Applovin MAX result
3) Showing the max price loaded ad object

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
