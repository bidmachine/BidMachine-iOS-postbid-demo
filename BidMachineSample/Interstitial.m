//
//  Interstitial.m
//
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Interstitial.h"

#define UNIT_ID         "ANY"

@interface Interstitial ()<BDMRequestDelegate, BDMInterstitialDelegate, MAAdDelegate>

@property (nonatomic, strong) MAInterstitialAd *applovinInterstitial;
@property (nonatomic, strong) BDMInterstitialRequest *request;
@property (nonatomic, strong) BDMInterstitial *interstitial;

@end

@implementation Interstitial

- (void)loadAd:(id)sender {
    [self switchState:BSStateLoading];
    [self.applovinInterstitial loadAd];
}

- (void)showAd:(id)sender {
    [self switchState:BSStateIdle];
    
    if ([self.interstitial canShow]) {
        [self.interstitial presentFromRootViewController:self];
        return;
    }
    
    if ([self.applovinInterstitial isReady]) {
        [self.applovinInterstitial showAd];
    }
}

#pragma mark - Lazy

- (MAInterstitialAd *)applovinInterstitial {
    if (!_applovinInterstitial) {
        _applovinInterstitial = [[MAInterstitialAd alloc] initWithAdUnitIdentifier: @UNIT_ID];
        _applovinInterstitial.delegate = self;
    }
    return _applovinInterstitial;
}

#pragma mark - Private

- (BOOL)canShow {
    return [self.interstitial canShow] || [self.applovinInterstitial isReady];
}

- (void)makePostBidWithAd:(MAAd *)ad {
    self.request = BDMInterstitialRequest.new;
    if (ad.revenue > 0) {
        BDMPriceFloor *priceFloor = BDMPriceFloor.new;
        priceFloor.ID = @"applovin_max";
        priceFloor.value = [[NSDecimalNumber alloc] initWithDouble:ad.revenue * 1000];
        self.request.priceFloors = @[priceFloor];
    }
    
    [self.request performWithDelegate:self];
}

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    self.interstitial = BDMInterstitial.new;
    self.interstitial.delegate = self;
    [self.interstitial populateWithRequest:self.request];
    
    self.request = nil;
}

- (void)request:(BDMRequest *)request failedWithError:(NSError *)error {
    self.request = nil;
    [self switchState: self.canShow ? BSStateReady : BSStateIdle];
}

- (void)requestDidExpire:(BDMRequest *)request {
    
}

#pragma mark - BDMInterstitialDelegate

- (void)interstitialReadyToPresent:(nonnull BDMInterstitial *)interstitial {
    [self switchState:BSStateReady];
}

- (void)interstitial:(nonnull BDMInterstitial *)interstitial failedWithError:(nonnull NSError *)error {
    [self switchState: self.canShow ? BSStateReady : BSStateIdle];
}

- (void)interstitial:(nonnull BDMInterstitial *)interstitial failedToPresentWithError:(nonnull NSError *)error {
    
}

- (void)interstitialWillPresent:(nonnull BDMInterstitial *)interstitial {
    
}

- (void)interstitialDidDismiss:(nonnull BDMInterstitial *)interstitial {
    
}

- (void)interstitialRecieveUserInteraction:(nonnull BDMInterstitial *)interstitial {
    
}

#pragma mark - MAAdDelegate

- (void)didLoadAd:(MAAd *)ad {
    [self makePostBidWithAd:ad];
}

- (void)didFailToLoadAdForAdUnitIdentifier:(NSString *)adUnitIdentifier withError:(MAError *)error {
    [self makePostBidWithAd:nil];
}

- (void)didFailToDisplayAd:(MAAd *)ad withError:(MAError *)error {
    
}

- (void)didDisplayAd:(MAAd *)ad {
    
}

- (void)didHideAd:(MAAd *)ad {
    
}

- (void)didClickAd:(MAAd *)ad {
    
}

@end
