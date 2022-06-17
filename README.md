
![BidMachine iOS](https://appodeal-ios.s3-us-west-1.amazonaws.com/docs/bidmachine.png)
# BidMachine-iOS-postbid-demo

* [Overview](#post-bid-overview)
* [PreBid Block](#prebid-block)
    + [Mediated Ad Networks](#prebid-mediated-ad-networks)
* [PostBid block](#postbid-block)
    + [Mediated Ad Networks](#postbid-mediated-ad-networks)
* [Showing the loaded ad object](#showing-the-loaded-ad-object)
    + [Banner](#banner)
    + [AutorefreshBanner](#autorefresh-banner)
    + [Interstitial](#interstitial)
    + [Rewarded](#rewarded)

## Get started

In order to use the module, you need to add the following specs to the Podfile

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

## Initialize module

https://github.com/bidmachine/BidMachine-iOS-Mediation-SDK/tree/develop#initialization


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

#### PreBid Mediated Ad Networks

| Ad Network  | Adapter                                                                                                   | Type Class                                                                                                                  |
|:------------|:----------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------|
| BidMachine  | [BidMachinePreBidNetwork](BidMachineMediationAdapters/BidMachineMediationAdapter/BidMachineNetwork.swift) | [BidMachineBannerAdapter](BidMachineMediationAdapters/BidMachineMediationAdapter/BidMachineBannerAdapter.swift)             |
|             |                                                                                                           | [BidMachineInterstitialAdapter](BidMachineMediationAdapters/BidMachineMediationAdapter/BidMachineInterstitialAdapter.swift) |
|             |                                                                                                           | [BidMachineRewardedAdapter](BidMachineMediationAdapters/BidMachineMediationAdapter/BidMachineRewardedAdapter.swift)         |
| ApplovinMAX | [ApplovinPreBidNetwork](BidMachineMediationAdapters/ApplovinMediationAdapter/ApplovinNetwork.swift)       | [ApplovinBannerAdapter](BidMachineMediationAdapters/ApplovinMediationAdapter/ApplovinBannerAdapter.swift)                   |
|             |                                                                                                           | [ApplovinInterstitialAdapter](BidMachineMediationAdapters/ApplovinMediationAdapter/ApplovinInterstitialAdapter.swift)       |
|             |                                                                                                           | [ApplovinRewardedAdapter](BidMachineMediationAdapters/ApplovinMediationAdapter/ApplovinRewardedAdapter.swift)               |

#### Adapter Features

In the prebid block, you need to get the price of the loaded ad object from the adapters

##### BidMachine

Each loaded BidMachine object contains price information - Example:

``` swift

func getPrice(from ad: BDMInterstitial) -> Double {
    return ad.auctionInfo.price
}

```

##### ApplovinMax 

Each loaded MAX object contains price information - Example:

``` swift

func getPrice(from ad: MAAd) -> Double {
    return ad.revenue * 1000
}


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

#### PostBid Mediated Ad Networks

| Ad Network | Adapter                                                                                                    | Type Class                                                                                                                  |
|:-----------|:-----------------------------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------|
| BidMachine | [BidMachinePostBidNetwork](BidMachineMediationAdapters/BidMachineMediationAdapter/BidMachineNetwork.swift) | [BidMachineBannerAdapter](BidMachineMediationAdapters/BidMachineMediationAdapter/BidMachineBannerAdapter.swift)             |
|            |                                                                                                            | [BidMachineInterstitialAdapter](BidMachineMediationAdapters/BidMachineMediationAdapter/BidMachineInterstitialAdapter.swift) |
|            |                                                                                                            | [BidMachineRewardedAdapter](BidMachineMediationAdapters/BidMachineMediationAdapter/BidMachineRewardedAdapter.swift)         |
| AdMob      | [AdMobPostBidNetwork](BidMachineMediationAdapters/AdMobMediationAdapter/AdMobNetwork.swift)                | [AdMobBannerAdapter](BidMachineMediationAdapters/AdMobMediationAdapter/AdMobBannerAdapter.swift)                            |
|            |                                                                                                            | [AdMobInterstitialAdapter](BidMachineMediationAdapters/AdMobMediationAdapter/AdMobInterstitialAdapter.swift)                |
|            |                                                                                                            | [AdMobRewardedAdapter](BidMachineMediationAdapters/AdMobMediationAdapter/AdMobRewardedAdapter.swift)                        |


#### Adapter Features

In the postbid block you must request an ad for each adapter with a preset price

##### BidMachine

To download BidMachine with a preset price, you need to send price floors to the request - Example:

``` swift

    func load(_ price: Double) {
        let request = BDMInterstitialRequest()
        if price > 0 {
            request.priceFloors = [price].compactMap {
                let floor = BDMPriceFloor()
                floor.id = "mediation_price"
                floor.value = NSDecimalNumber(value: $0)
                return floor
            }
        }
    
        interstitial.populate(with: request)
    }

```

##### AdMob 

To download AdMob, you need to choose the right adUnitId for the price and make a request with it - Example:

``` swift

    /**
     * Finds the first [LineItem] whose price is equal to or greater than the price floor and loads it.
     * Each ad unit is configured in the [AdMob dashboard](https://apps.admob.com).
     */
    func load(_ price: Double) {
        guard let lineItem = Constants.lineItems.lineItemWithPrice(price) else {
            self.loadingDelegate.flatMap { $0.failLoad(self, MediationError.noContent("Can't find AdMob line item"))}
            return
        }
        
        
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: lineItem.unitId, request: request) { }
    }

```

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

``` objc
@interface Banner ()<BMMBannerDelegate>

@property (weak, nonatomic) IBOutlet BMMBanner *banner;

@end

@implementation Banner

- (void)loadBanner {
    self.banner.delegate = self;
    self.banner.controller = self;
    [self.banner loadAd]
}

#pragma mark - BMMBannerDelegate

- (void)bannerDidLoadAd:(BMMBanner * _Nonnull)ad {
    
}

- (void)bannerFailToLoadAd:(BMMBanner * _Nonnull)ad with:(NSError * _Nonnull)error {
    
}

- (void)bannerFailToPresentAd:(BMMBanner * _Nonnull)ad with:(NSError * _Nonnull)error {
  
}

- (void)bannerWillPresentScreenAd:(BMMBanner * _Nonnull)ad {
    
}

- (void)bannerDidDismissScreenAd:(BMMBanner * _Nonnull)ad {
    
}

- (void)bannerDidTrackImpression:(BMMBanner * _Nonnull)ad {
    
}

- (void)bannerRecieveUserAction:(BMMBanner * _Nonnull)ad {
    
}

@end

```

#### Autorefresh Banner

``` objc
@interface ABanner () <BMMAutorefreshBannerDelegate>

@property (weak, nonatomic) IBOutlet BMMAutorefreshBanner *autorefreshBanner;

@end

@implementation ABanner

- (void)loadBanner {
    self.autorefreshBanner.delegate = self;
    self.autorefreshBanner.controller = self;
    [self.autorefreshBanner loadAd];
}

- (void)hideBanner {
    [self.autorefreshBanner hideAd];
}

#pragma mark - BMMAutorefreshBannerDelegate

- (void)autorefreshBannerDidDismissScreenAd:(BMMAutorefreshBanner * _Nonnull)ad {
    
}

- (void)autorefreshBannerDidLoadAd:(BMMAutorefreshBanner * _Nonnull)ad {
    
}

- (void)autorefreshBannerDidTrackImpression:(BMMAutorefreshBanner * _Nonnull)ad {
    
}

- (void)autorefreshBannerFailToLoadAd:(BMMAutorefreshBanner * _Nonnull)ad with:(NSError * _Nonnull)error {
    
}

- (void)autorefreshBannerFailToPresentAd:(BMMAutorefreshBanner * _Nonnull)ad with:(NSError * _Nonnull)error {
    
}

- (void)autorefreshBannerRecieveUserAction:(BMMAutorefreshBanner * _Nonnull)ad {
    
}

- (void)autorefreshBannerWillPresentScreenAd:(BMMAutorefreshBanner * _Nonnull)ad {
    
}

@end

```

#### Interstitial

``` objc
@interface Interstitial ()<BMMInterstitialDelegate>

@property (nonatomic, strong) BMMInterstitial *intestitial;

@end

@implementation Interstitial

- (void)loadInterstitial {
    self.intestitial = BMMInterstitial.new;
    self.intestitial.delegate = self;
    [self.intestitial loadAd];
}

- (void)showInterstitial {
    [self.intestitial presentFrom:self];
}

#pragma mark - BMMInterstitialDelegate

- (void)interstitialDidLoadAd:(BMMInterstitial *)ad {
    
}

- (void)interstitialFailToLoadAd:(BMMInterstitial *)ad with:(NSError *)error {
    
}

- (void)interstitialFailToPresentAd:(BMMInterstitial * _Nonnull)ad with:(NSError * _Nonnull)error {

}

- (void)interstitialWillPresentAd:(BMMInterstitial * _Nonnull)ad {
    
}

- (void)interstitialDidDismissAd:(BMMInterstitial * _Nonnull)ad {
    
}

- (void)interstitialDidTrackImpression:(BMMInterstitial * _Nonnull)ad {
    
}

- (void)interstitialRecieveUserAction:(BMMInterstitial * _Nonnull)ad {
    
}

@end

```

#### Rewarded

``` objc
@interface Rewarded ()<BMMRewardedDelegate>

@property (nonatomic, strong) BMMRewarded *rewarded;

@end

@implementation Rewarded

- (void)loadRewarded {
    self.rewarded = BMMRewarded.new;
    self.rewarded.delegate = self;
    [self.rewarded loadAd];
}

- (void)showRewarded {
    [self.rewarded presentFrom:self];
}

#pragma mark - BMMRewardedDelegate

- (void)rewardedDidLoadAd:(BMMRewarded *)ad {
    
}

- (void)rewardedFailToLoadAd:(BMMRewarded *)ad with:(NSError *)error {
    
}

- (void)rewardedFailToPresentAd:(BMMRewarded * _Nonnull)ad with:(NSError * _Nonnull)error {
    
}

- (void)rewardedWillPresentAd:(BMMRewarded * _Nonnull)ad {
    
}

- (void)rewardedDidDismissAd:(BMMRewarded * _Nonnull)ad {
    
}

- (void)rewardedDidTrackImpression:(BMMRewarded * _Nonnull)ad {
    
}


- (void)rewardedDidTrackReward:(BMMRewarded * _Nonnull)ad {
    
}

- (void)rewardedRecieveUserAction:(BMMRewarded * _Nonnull)ad {
    
}


@end

```
