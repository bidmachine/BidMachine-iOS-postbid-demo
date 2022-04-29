//
//  BMMediationBanner.m
//  BidMachineSample
//
//  Created by Ilia Lozhkin on 29.04.2022.
//  Copyright © 2022 Appodeal. All rights reserved.
//

#import "BMMediationBanner.h"

@import AppLovinSDK;
@import BidMachine;
@import BidMachine.HeaderBidding;

@interface BMMediationBanner ()

@property (nonatomic, assign, readwrite) double ECPM;

@end

@interface BMMAXMediationBanner ()<MAAdViewAdDelegate>

@property (nonatomic, strong) MAAdView *banner;

@end

@interface BMBidMachineMediationBanner ()<BDMAdEventProducerDelegate, BDMBannerDelegate>

@property (nonatomic, strong) BDMBannerView *banner;

@end

/// Implementation

@implementation BMMediationBanner

- (void)loadWithPriceFloor:(double)priceFloor {
    NSAssert(NO, @"DO NOTHINK...SHOULD BE OVERIDE IN CHILD CLASS");
}

- (nonnull UIView *)banner {
    return nil;
}

@end

@implementation BMMAXMediationBanner

- (void)loadWithPriceFloor:(double)priceFloor {
    [self.banner loadAd];
}

- (MAAdView *)banner {
    if (!_banner) {
        _banner = [[MAAdView alloc] initWithAdUnitIdentifier: @"YOUR_UNIT_ID"];
        _banner.frame = CGRectMake(0, 0, 320, 50);
        _banner.delegate = self;
    }
    return _banner;
}

#pragma mark - delegate

- (void)didLoadAd:(nonnull MAAd *)ad {
    [self.banner stopAutoRefresh];
    
    self.ECPM = ad.revenue * 1000;
    [self.delegate didLoadBanner:self];
}

- (void)didFailToLoadAdForAdUnitIdentifier:(nonnull NSString *)adUnitIdentifier withError:(nonnull MAError *)error {
    NSError *err = [NSError bdm_errorWithCode:BDMErrorCodeNoContent description:error.message];
    [self.delegate didFailToLoadWithError:err];
}

- (void)didDisplayAd:(nonnull MAAd *)ad {
    [self.displayDelegate didImpression];
}

- (void)didClickAd:(nonnull MAAd *)ad {
    [self.displayDelegate didClick];
}

- (void)didCollapseAd:(nonnull MAAd *)ad {
    [self.displayDelegate didCollapse];
}

- (void)didExpandAd:(nonnull MAAd *)ad {
    [self.displayDelegate didExpand];
}

- (void)didHideAd:(nonnull MAAd *)ad {
    
}

- (void)didFailToDisplayAd:(nonnull MAAd *)ad withError:(nonnull MAError *)error {
    
}

@end

@implementation BMBidMachineMediationBanner


- (void)loadWithPriceFloor:(double)priceFloor {
    BDMBannerRequest *request = BDMBannerRequest.new;
    if (priceFloor > 0) {
        BDMPriceFloor *floor = BDMPriceFloor.new;
        floor.ID = @"custom_floor";
        floor.value = [[NSDecimalNumber alloc] initWithDouble: priceFloor];
        request.priceFloors = @[floor];
    }
    
    [self.banner populateWithRequest:request];
}

- (BDMBannerView *)banner {
    if (!_banner) {
        _banner = BDMBannerView.new;
        _banner.frame = CGRectMake(0, 0, 320, 50);
        _banner.delegate = self;
        _banner.producerDelegate = self;
    }
    return _banner;
}

#pragma mark - delegate

- (void)bannerViewReadyToPresent:(nonnull BDMBannerView *)bannerView {
    self.ECPM = bannerView.latestAuctionInfo.price.doubleValue;
    [self.delegate didLoadBanner:self];
}

- (void)bannerView:(nonnull BDMBannerView *)bannerView failedWithError:(nonnull NSError *)error {
    [self.delegate didFailToLoadWithError:error];
}

- (void)bannerViewRecieveUserInteraction:(nonnull BDMBannerView *)bannerView {
    [self.displayDelegate didClick];
}

- (void)bannerViewDidExpire:(nonnull BDMBannerView *)bannerView {
    
}

- (void)bannerViewWillLeaveApplication:(nonnull BDMBannerView *)bannerView {
    
}

- (void)bannerViewWillPresentScreen:(nonnull BDMBannerView *)bannerView {
    [self.displayDelegate didExpand];
}

- (void)bannerViewDidDismissScreen:(nonnull BDMBannerView *)bannerView {
    [self.displayDelegate didCollapse];
}

- (void)didProduceImpression:(nonnull id<BDMAdEventProducer>)producer {
    [self.displayDelegate didImpression];
}

- (void)didProduceUserAction:(nonnull id<BDMAdEventProducer>)producer {
    
}

@end
