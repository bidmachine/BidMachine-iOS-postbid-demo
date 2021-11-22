//
//  Rewarded.m
//
//  Copyright © 2019 bidmachine. All rights reserved.
//

#import "Rewarded.h"

#define UNIT_ID         "ANY"

@interface Rewarded ()<BDMRequestDelegate, BDMRewardedDelegate, MARewardedAdDelegate, MAAdRevenueDelegate>

@property (nonatomic, strong) MARewardedAd *applovinRewardedAd;
@property (nonatomic, strong) BDMRewardedRequest *request;
@property (nonatomic, strong) BDMRewarded *rewarded;

@end

@implementation Rewarded

- (void)loadAd:(id)sender {
    [self switchState:BSStateLoading];
    [self.applovinRewardedAd loadAd];
}

- (void)showAd:(id)sender {
    [self switchState:BSStateIdle];
    
    if ([self.rewarded canShow]) {
        [self.rewarded presentFromRootViewController:self];
        return;
    }
    
    if ([self.applovinRewardedAd isReady]) {
        [self.applovinRewardedAd showAd];
    }
}

#pragma mark - Lazy

- (MARewardedAd *)applovinRewardedAd {
    if (!_applovinRewardedAd) {
        _applovinRewardedAd = [MARewardedAd sharedWithAdUnitIdentifier: @UNIT_ID];
        _applovinRewardedAd.delegate = self;
        _applovinRewardedAd.revenueDelegate = self;
    }
    return _applovinRewardedAd;
}

#pragma mark - Private

- (BOOL)canShow {
    return [self.rewarded canShow] || [self.applovinRewardedAd isReady];
}

- (void)makePostBidWithAd:(MAAd *)ad {
    self.request = BDMRewardedRequest.new;
    if (ad.revenue > 0) {
        BDMPriceFloor *priceFloor = BDMPriceFloor.new;
        priceFloor.ID = @"applovin_max";
        priceFloor.value = [[NSDecimalNumber alloc] initWithDouble:ad.revenue];
        self.request.priceFloors = @[priceFloor];
    }
    
    [self.request performWithDelegate:self];
}

#pragma mark - BDMRequestDelegate

- (void)request:(BDMRequest *)request completeWithInfo:(BDMAuctionInfo *)info {
    self.rewarded = BDMRewarded.new;
    self.rewarded.delegate = self;
    [self.rewarded populateWithRequest:self.request];
    
    self.request = nil;
}

- (void)request:(BDMRequest *)request failedWithError:(NSError *)error {
    self.request = nil;
    [self switchState: self.canShow ? BSStateReady : BSStateIdle];
}

- (void)requestDidExpire:(BDMRequest *)request {
    
}

#pragma mark - BDMRewardedDelegate

- (void)rewardedReadyToPresent:(nonnull BDMRewarded *)rewarded {
    [self switchState:BSStateReady];
}

- (void)rewarded:(nonnull BDMRewarded *)rewarded failedWithError:(nonnull NSError *)error {
    [self switchState: self.canShow ? BSStateReady : BSStateIdle];
}

- (void)rewarded:(nonnull BDMRewarded *)rewarded failedToPresentWithError:(nonnull NSError *)error {
    
}

- (void)rewardedWillPresent:(nonnull BDMRewarded *)rewarded {
    
}

- (void)rewardedDidDismiss:(nonnull BDMRewarded *)rewarded {
    
}

- (void)rewardedRecieveUserInteraction:(nonnull BDMRewarded *)rewarded {
    
}

- (void)rewardedFinishRewardAction:(nonnull BDMRewarded *)rewarded {
    
}

#pragma mark - MARewardedAdDelegate

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

- (void)didStartRewardedVideoForAd:(MAAd *)ad {
    
}

- (void)didCompleteRewardedVideoForAd:(MAAd *)ad {
    
}

- (void)didRewardUserForAd:(MAAd *)ad withReward:(MAReward *)reward {
    
}

#pragma mark - MAAdRevenueDelegate

- (void)didPayRevenueForAd:(MAAd *)ad {
    
}

@end
